import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return FutureBuilder(
      future: _auth.currentUser?.reload(), // Reload user state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (_auth.currentUser == null) {
          // Redirect to login and clear navigation stack
          Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false));
          return SizedBox.shrink();
        }
        return child;
      },
    );
  }
}