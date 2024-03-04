import 'package:flutter/material.dart';
import 'package:oauth/home_page.dart';
import 'package:oauth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomePage(snapshot.data!); // User is signed in
        } else {
          return LoginPage(); // User is not signed in
        }
      },
    );
  }
}