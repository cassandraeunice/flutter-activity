import 'package:flutter/material.dart';
import 'sign_up2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage1 extends StatefulWidget {
  @override
  _SignUpPage1State createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {
  final TextEditingController _emailController = TextEditingController();
  List<String> _emailErrors = [];

  // Regular expression for basic email validation
  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  void _validateEmail() async {
    setState(() {
      _emailErrors.clear();
      String email = _emailController.text.trim();

      if (email.isEmpty) {
        _emailErrors.add("Email is required.");
      } else {
        if (!email.contains("@")) {
          _emailErrors.add("Must contain '@' symbol.");
        }
        if (!email.contains(".")) {
          _emailErrors.add("Must contain a domain (e.g., '.com').");
        }
        if (!emailRegex.hasMatch(email)) {
          _emailErrors.add("Enter a valid email format (e.g., user@example.com).");
        }
      }
    });

    if (_emailErrors.isEmpty) {
      QuerySnapshot emailQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (emailQuery.docs.isNotEmpty) {
        setState(() {
          _emailErrors.add("Email is already in use.");
        });
      }
    }
  }

  void _onNextPressed() async {
    _validateEmail();

    if (_emailErrors.isEmpty) {
      // Check if email already exists
      QuerySnapshot emailQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (emailQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Email is already in use.')),
        );
        return;
      }

      // Navigate to the next page if email is unique
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpPage2(email: _emailController.text.trim()),
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
              "What's your email?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Email Field
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white70),
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

            _emailErrors.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _emailErrors
                  .map((error) => Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ))
                  .toList(),
            )
                : SizedBox(),

            SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "You’ll need to confirm this email later.",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            SizedBox(height: 30),

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
