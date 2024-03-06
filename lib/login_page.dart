import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oauth/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> handleSignIn() async {
    try {
      await googleSignIn.signOut();
      User? user = _auth.currentUser;
      if (user == null) {
        GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          GoogleSignInAuthentication googleAuth =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          UserCredential authResult =
              await _auth.signInWithCredential(credential);
          return authResult.user;
        }
      } else {
        return user;
      }
      return null;
    } catch (error) {
      // print("Error signing in with Google: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $error'),
        ),
      );
      return null;
    }
  }

  void signInWithGoogle() async {
    User? user = await handleSignIn();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Google'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sign-in-bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: SizedBox(
          // width: 150.0,
          height: 40.0,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: signInWithGoogle,
            label: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            icon: Image.asset(
              'assets/Google-logo.png',
              width: 24,
              height: 24,
              // color: Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
