import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentor_match/firebase_options.dart';
import './pages/home_screen.dart'; // Import your home screen widget
import './pages/login.dart'; // Import your login page widget
import './pages/signup.dart'; // Import your sign-up page widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentor Match',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            // User is logged in, navigate to home screen
            return HomeScreen(); // Replace with your home screen widget
          } else {
            // User is not logged in, navigate to login page
            return SignUpPage(); // Replace with your login page widget
          }
        }
      },
    );
  }
}
