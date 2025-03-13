import 'package:flutter/material.dart';

class ForgotPasswordPage1 extends StatefulWidget {
  @override
  _ForgotPassword1State createState() => _ForgotPassword1State();
}

class _ForgotPassword1State extends State<ForgotPasswordPage1> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorText;
  bool _isFormValid = false;

  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9]+$'); // Alphanumeric, no spaces

  void _validateInput() {
    setState(() {
      String input = _emailController.text.trim();

      if (input.isEmpty) {
        _errorText = "This field is required.";
      } else if (!emailRegex.hasMatch(input) && !usernameRegex.hasMatch(input)) {
        _errorText = "Enter a valid email or username.";
      } else {
        _errorText = null;
      }

      _isFormValid = _errorText == null;
    });
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
          "Forgot Password",
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Email or username",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Email or Username Input Field
            TextField(
              controller: _emailController,
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
              onChanged: (value) => _validateInput(),
            ),
            SizedBox(height: 5),

            // Error Message with Icon
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

            SizedBox(height: 30),

            // Next button
            Center(
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                  Navigator.pushNamed(context, '/forgotpassword2');
                }
                    : null, // Disable button if input is invalid
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? Colors.white : Colors.grey[500], // Button disabled color
                  disabledBackgroundColor: Colors.grey[500], // Explicit disabled color
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    color: _isFormValid ? Colors.black : Colors.black54, // Disabled text color
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
