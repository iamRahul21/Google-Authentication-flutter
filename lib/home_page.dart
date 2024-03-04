import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oauth/login_page.dart';

class HomePage extends StatelessWidget {
  final User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomePage(this.user);

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'Logged in successfully!',
            //   style: TextStyle(fontSize: 24.0),
            // ),
            // const SizedBox(height: 20.0),
            Text(
              'Welcome, ${user.displayName}!',
              style: const TextStyle(fontSize: 25.0),
            ),
          ],
        ),
      ),
    );
  }
}
