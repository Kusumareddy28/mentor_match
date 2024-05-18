// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// login.dart


//This Flutter file defines a LoginPage widget where users can sign in using their email and password. 
// The page uses Firebase Authentication for login verification. 
//The UI includes text fields for user inputs and a login button that shows a loading indicator while processing. 
//Error handling is provided to alert users of login issues.

// Import necessary Flutter and Firebase packages.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; 

// Define the LoginPage widget as a StatefulWidget to handle state changes.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// State class for LoginPage containing the UI and logic.
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController(); // Controller for the email input field.
  final TextEditingController _passwordController = TextEditingController(); // Controller for the password input field.
  bool _isProcessing = false; // State variable to indicate if the login is processing.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.teal, // Styling the AppBar with a teal background.
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16), // Padding around the form.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centering the form vertically.
          children: [
            SizedBox(height: 20), // Vertical spacing.
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            SizedBox(height: 16), // Vertical spacing.
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true, // Obscuring text for password input.
            ),
            SizedBox(height: 20), // Vertical spacing.
            ElevatedButton(
              onPressed: _isProcessing
                  ? null // Disable button when processing.
                  : () => _signInWithEmailAndPassword(context),
              child: _isProcessing
                  ? CircularProgressIndicator(color: Colors.white) // Show loading indicator when processing.
                  : Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button background color.
                foregroundColor: Colors.white, // Text color.
                minimumSize: Size(double.infinity, 50), // Button size.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Square-shaped button.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create a styled text field for form inputs.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText, // Hide text for password.
      keyboardType: keyboardType,
      cursorColor: Colors.teal, // Cursor color in the text field.
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal), // Label text style.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5), // Rounded corners for the text field.
        ),
        prefixIcon: Icon(icon, color: Colors.black), // Icon inside the text field.
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  // Function to handle sign-in with email and password using Firebase Authentication.
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _isProcessing = true; // Update processing state.
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to the HomeScreen if authentication is successful.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Show an error dialog if authentication fails.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(_getFirebaseAuthErrorMessage(e)), // Display error message based on the exception.
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false; // Reset processing state.
      });
    }
  }

  // Function to determine the error message based on FirebaseAuthException.
  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
