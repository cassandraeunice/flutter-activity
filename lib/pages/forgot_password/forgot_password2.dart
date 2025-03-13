import 'package:flutter/material.dart';

class ForgotPasswordPage2 extends StatefulWidget {
  @override
  _ForgotPassword2State createState() => _ForgotPassword2State();
}

class _ForgotPassword2State extends State<ForgotPasswordPage2> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  List<String> _passwordErrors = [];
  List<String> _confirmPasswordErrors = [];

  void _validatePasswords() {
    setState(() {
      _passwordErrors.clear();
      _confirmPasswordErrors.clear();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      // Password validation
      if (password.isEmpty) {
        _passwordErrors.add("Password is required.");
      }
      if (password.length < 8) {
        _passwordErrors.add("At least 8 characters.");
      }
      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        _passwordErrors.add("At least 1 uppercase letter (A-Z).");
      }
      if (!RegExp(r'[0-9]').hasMatch(password)) {
        _passwordErrors.add("At least 1 number (0-9).");
      }
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        _passwordErrors.add("At least 1 special character (@\$!%*?&).");
      }

      // Confirm password validation
      if (confirmPassword.isEmpty) {
        _confirmPasswordErrors.add("Confirm password is required.");
      }
      if (password != confirmPassword) {
        _confirmPasswordErrors.add("Passwords do not match.");
      }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "New Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
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

            // Password Errors in List Style
            _passwordErrors.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _passwordErrors
                  .map((error) => Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ))
                  .toList(),
            )
                : SizedBox(),

            SizedBox(height: 20),

            Text(
              "Re-enter New Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
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

            // Confirm Password Errors in List Style
            _confirmPasswordErrors.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _confirmPasswordErrors
                  .map((error) => Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ))
                  .toList(),
            )
                : SizedBox(),

            SizedBox(height: 30),

            // Next button (Always Enabled)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _validatePasswords();
                  if (_passwordErrors.isEmpty && _confirmPasswordErrors.isEmpty) {
                    Navigator.pushNamed(context, '/signup3');
                  }
                },
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
