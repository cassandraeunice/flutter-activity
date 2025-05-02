import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_up4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage3 extends StatefulWidget {
  final String email;
  final String password;

  SignUpPage3({required this.email, required this.password});

  @override
  _SignUpPage3State createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText;

  void _validatePhoneNumber() async {
    setState(() {
      List<String> phoneErrors = [];
      String phone = _phoneController.text.trim();

      if (phone.isEmpty) {
        phoneErrors.add("Phone number is required.");
      } else {
        if (phone.length < 10) {
          phoneErrors.add("Phone number must be 10 digits.");
        }
        if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
          phoneErrors.add("Only numbers are allowed.");
        }
      }

      _errorText = phoneErrors.isNotEmpty ? phoneErrors.join("\n") : null;
    });

    if (_errorText == null) {
      QuerySnapshot phoneQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: _phoneController.text.trim())
          .get();

      if (phoneQuery.docs.isNotEmpty) {
        setState(() {
          _errorText = "Phone number is already in use.";
        });
      }
    }
  }

  void _onNextPressed() async {
    _validatePhoneNumber();

    if (_errorText == null) {
      // Check if phone number already exists
      QuerySnapshot phoneQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: _phoneController.text.trim())
          .get();

      if (phoneQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Phone number is already in use.')),
        );
        return;
      }

      // Navigate to the next page if phone number is unique
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpPage4(
            email: widget.email,
            password: widget.password,
            phone: _phoneController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "What's your number?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Phone Number Input Field
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF777777),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF777777)),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 5),

            // Error Message
            _errorText != null
                ? Padding(
              padding: const EdgeInsets.only(left: 10, top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 16),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            )
                : SizedBox(),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
