import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isLoading = false;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildTextField("Old Password", _oldPasswordController, _isOldPasswordVisible),
              SizedBox(height: 20), // Equal height between text fields
              _buildTextField("New Password", _newPasswordController, _isNewPasswordVisible),
              SizedBox(height: 20), // Equal height between text fields
              _buildTextField("Confirm Password", _confirmPasswordController, _isConfirmPasswordVisible),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: isLoading ? null : _onSaveChangesPressed,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Password text field with toggle visibility
  Widget _buildTextField(String label, TextEditingController controller, bool isPasswordVisible) {
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
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (label == "Old Password") {
                    _isOldPasswordVisible = !_isOldPasswordVisible;
                  } else if (label == "New Password") {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  } else if (label == "Confirm Password") {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onSaveChangesPressed() {
    // You can add your password change logic here
    // This is where you would call the backend to update the password
    setState(() {
      isLoading = true;
    });

    // Simulating the password update process
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully')));
      Navigator.pop(context);
    });
  }
}
