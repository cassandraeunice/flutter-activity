import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage4 extends StatefulWidget {
  final String email;
  final String password;
  final String phone;

  SignUpPage4({required this.email, required this.password, required this.phone});

  @override
  _SignUpPage4State createState() => _SignUpPage4State();
}

class _SignUpPage4State extends State<SignUpPage4> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _validateName() {
    setState(() {
      String name = _nameController.text.trim();

      if (name.isEmpty) {
        _errorText = "Name is required.";
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
        _errorText = "Only letters and spaces are allowed.";
      } else {
        _errorText = null;
      }
    });
  }

  Future<void> _createUser() async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // Store additional user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': widget.email,
        'phone': widget.phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Navigate to the homepage
      Navigator.pushNamed(context, '/homepage');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  void _onCreateAccountPressed() {
    _validateName();

    if (_errorText == null) {
      _createUser();
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
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "What's your name?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Name Input Field
                TextField(
                  controller: _nameController,
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

                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "This appears on your moody profile.",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(height: 20),

                Divider(
                  color: Color(0xFF777777),
                  thickness: 1,
                ),

                SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Terms of Use",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "By tapping on “Create account”, you agree to Moody’s Terms of Use.",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "To learn more about how Moody collects, uses, shares, and protects your personal data, please see the Privacy Policy.",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: _onCreateAccountPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}