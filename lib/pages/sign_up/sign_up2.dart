import 'package:flutter/material.dart';

class SignUpPage2 extends StatefulWidget {
  @override
  _SignUpPage2State createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  List<String> _passwordErrors = [];
  String? _confirmPasswordError;

  final RegExp passwordUppercase = RegExp(r'[A-Z]');
  final RegExp passwordNumber = RegExp(r'[0-9]');
  final RegExp passwordSpecialChar = RegExp(r'[@$!%*?&]');

  void _validatePasswords() {
    setState(() {
      _passwordErrors.clear();
      _confirmPasswordError = null;

      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password.isEmpty) {
        _passwordErrors.add("Password is required.");
      } else {
        if (password.length < 8) _passwordErrors.add("At least 8 characters.");
        if (!passwordUppercase.hasMatch(password)) _passwordErrors.add("At least 1 uppercase letter (A-Z).");
        if (!passwordNumber.hasMatch(password)) _passwordErrors.add("At least 1 number (0-9).");
        if (!passwordSpecialChar.hasMatch(password)) _passwordErrors.add("At least 1 special character (@\$!%*?&).");
      }

      if (confirmPassword.isEmpty) {
        _confirmPasswordError = "Confirm Password is required.";
      } else if (password != confirmPassword) {
        _confirmPasswordError = "Passwords do not match.";
      }
    });
  }

  void _onNextPressed() {
    _validatePasswords();

    if (_passwordErrors.isEmpty && _confirmPasswordError == null) {
      Navigator.pushNamed(context, '/signup3');
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
              "Create a password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF777777),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF777777)),
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 5),

            // Password Validation Errors (List Style)
            _passwordErrors.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _passwordErrors
                  .map(
                    (error) => Padding(
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
                ),
              )
                  .toList(),
            )
                : SizedBox(),

            SizedBox(height: 10),

            Text(
              "Confirm Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF777777),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF777777)),
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 5),

            // Confirm Password Error
            _confirmPasswordError != null
                ? Padding(
              padding: const EdgeInsets.only(left: 10, top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 16),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _confirmPasswordError!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            )
                : SizedBox(),

            SizedBox(height: 30),

            // Next button (Always Enabled)
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
