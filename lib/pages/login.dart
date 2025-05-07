import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


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
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _validateInputs() async {
    setState(() {
      _emailErrors.clear();
      _passwordErrors.clear();
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      _emailErrors.add("Email is required");
    } else if (email.length > 64) {
      _emailErrors.add("Email must not exceed 64 characters");
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      _emailErrors.add("Enter a valid email format (e.g., user@example.com)");
    }

    if (password.isEmpty) {
      _passwordErrors.add("Password is required");
    }

    if (_emailErrors.isEmpty && _passwordErrors.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushNamed(context, '/homepage');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _passwordErrors.add("Invalid email or password.");
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
              maxLength: 120,
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
                counterText: '', // Hides character counter
              ),
            ),
            SizedBox(height: 5),

            if (_emailErrors.isNotEmpty)
              ..._emailErrors.map((error) => Padding(
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
              )),

            SizedBox(height: 15),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              maxLength: 64,
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
                counterText: '',
              ),
            ),
            SizedBox(height: 5),

            if (_passwordErrors.isNotEmpty)
              ..._passwordErrors.map((error) => Padding(
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
              )),

            SizedBox(height: 30),

            // Login Button
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _validateInputs,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text(
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
