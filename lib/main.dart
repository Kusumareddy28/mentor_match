// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// main.dart

// This Flutter file serves as the main entry point for the Mentor Match application.
// It initializes Firebase, sets up the primary theme, and determines the initial screen to display based on the user's authentication state.


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentor_match/firebase_options.dart'; 
import './pages/home_screen.dart'; 
import './pages/login.dart'; 
import './pages/signup.dart'; 

// Main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that Flutter bindings are initialized.
  await Firebase.initializeApp( // Initialize Firebase app with default settings for the platform.
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); // Runs the MyApp class.
}

// MyApp widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentor Match', // Title of the application.
      theme: ThemeData(
        primarySwatch: Colors.teal, // Theme color of the application.
      ),
      home: AuthenticationWrapper(), // Root widget which checks authentication state.
    );
  }
}

// AuthenticationWrapper decides which page to show based on the user's authentication state.
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to the Firebase Auth state changes.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Show loading spinner while waiting for auth state.
          );
        } else {
          if (snapshot.hasData) {
            // If snapshot has user data, user is logged in.
            return HomeScreen(); // Navigate to the home screen.
          } else {
            // If no user data, user is not logged in.
            return SignUpPage(); // Navigate to the sign-up page.
          }
        }
      },
    );
  }
}
