import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<String> _emailErrors = [];
  List<String> _passwordErrors = [];

  // Regular expressions for validation
  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final RegExp passwordUppercase = RegExp(r'[A-Z]');
  final RegExp passwordNumber = RegExp(r'[0-9]');
  final RegExp passwordSpecialChar = RegExp(r'[@$!%*?&]');

  void _validateInputs() {
    setState(() {
      // Validate email
      _emailErrors.clear();
      if (_emailController.text.isEmpty) {
        _emailErrors.add("Email is required");
      } else {
        if (!_emailController.text.contains("@")) {
          _emailErrors.add("Must contain '@' symbol");
        }
        if (!_emailController.text.contains(".")) {
          _emailErrors.add("Must contain a domain (e.g., '.com')");
        }
        if (!emailRegex.hasMatch(_emailController.text)) {
          _emailErrors.add("Enter a valid email format (e.g., user@example.com)");
        }
      }

      // Validate password
      _passwordErrors.clear();
      if (_passwordController.text.isEmpty) {
        _passwordErrors.add("Password is required");
      } else {
        if (_passwordController.text.length < 8) {
          _passwordErrors.add("At least 8 characters");
        }
        if (!passwordUppercase.hasMatch(_passwordController.text)) {
          _passwordErrors.add("At least 1 uppercase letter (A-Z)");
        }
        if (!passwordNumber.hasMatch(_passwordController.text)) {
          _passwordErrors.add("At least 1 number (0-9)");
        }
        if (!passwordSpecialChar.hasMatch(_passwordController.text)) {
          _passwordErrors.add("At least 1 special character (@\$!%*?&)");
        }
      }
    });

    if (_emailErrors.isEmpty && _passwordErrors.isEmpty) {
      Navigator.pushNamed(context, '/homepage');
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
          "Login",
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
            Center(
              child: Text(
                "Welcome back!",
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Email Field
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF777777),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF777777)),
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: Icon(Icons.email, color: Colors.white),
              ),
            ),
            SizedBox(height: 5),

            // Email Validation Errors (Wrapped Text)
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
                    Expanded( // Ensures wrapping
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

            SizedBox(height: 15),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white70),
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

            // Password Validation Errors (Wrapped Text)
            _passwordErrors.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _passwordErrors
                  .map((error) => Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Expanded( // Ensures wrapping
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

            SizedBox(height: 30),

            // Login Button
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _validateInputs,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup1');
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotpassword1');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
