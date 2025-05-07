import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  bool _isLoading = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final RegExp passwordUppercase = RegExp(r'[A-Z]');
  final RegExp passwordNumber = RegExp(r'[0-9]');
  final RegExp passwordSpecialChar = RegExp(r'[@$!%*?&]');

  void _validateInputs() async {
    setState(() {
      _currentPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      _currentPasswordError = "Current password is required.";
    }

    if (newPassword.isEmpty) {
      _newPasswordError = "New password is required.";
    } else {
      if (newPassword.length < 8) {
        _newPasswordError = "At least 8 characters.";
      } else if (!passwordUppercase.hasMatch(newPassword)) {
        _newPasswordError = "At least 1 uppercase letter (A-Z).";
      } else if (!passwordNumber.hasMatch(newPassword)) {
        _newPasswordError = "At least 1 number (0-9).";
      } else if (!passwordSpecialChar.hasMatch(newPassword)) {
        _newPasswordError = "At least 1 special character (@\$!%*?&).";
      }
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = "Confirm password is required.";
    } else if (newPassword != confirmPassword) {
      _confirmPasswordError = "Passwords do not match.";
    }

    if (_currentPasswordError == null &&
        _newPasswordError == null &&
        _confirmPasswordError == null) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = _auth.currentUser;

        // Reauthenticate user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully.')),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          setState(() {
            _currentPasswordError = "Incorrect current password.";
          });
        } else if (e.code == 'invalid-credential') {
          setState(() {
            _currentPasswordError = "Incorrect current password.";
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
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
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordField("Current Password", _currentPasswordController, _currentPasswordError, _isCurrentPasswordVisible, (value) {
              setState(() {
                _isCurrentPasswordVisible = value;
              });
            }),
            SizedBox(height: 16),
            _buildPasswordField("New Password", _newPasswordController, _newPasswordError, _isNewPasswordVisible, (value) {
              setState(() {
                _isNewPasswordVisible = value;
              });
            }),
            SizedBox(height: 16),
            _buildPasswordField("Confirm Password", _confirmPasswordController, _confirmPasswordError, _isConfirmPasswordVisible, (value) {
              setState(() {
                _isConfirmPasswordVisible = value;
              });
            }),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: _isLoading ? null : _validateInputs,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, String? errorText, bool isPasswordVisible, Function(bool) toggleVisibility) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: !isPasswordVisible,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Color(0xFF222222),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: () {
                toggleVisibility(!isPasswordVisible);
              },
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 16),
                SizedBox(width: 5),
                Text(
                  errorText,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
