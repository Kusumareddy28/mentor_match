import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import './login.dart';
=======
>>>>>>> dev-0.1

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _profilePicUrlController =
      TextEditingController();
  // Add the new controllers and variables
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  String _gender = 'Female'; // Default gender value
  String _role = 'mentee'; // Default role value

  @override
  Widget build(BuildContext context) {
    // Check if a user is already signed in
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // If user is already signed in, navigate to login page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
<<<<<<< HEAD
            // Add new TextField for Profession
=======


            // Add new TextField for Profession

>>>>>>> dev-0.1
            GestureDetector(
              onTap: () => _selectDate(context), // Open date picker on tap
              child: AbsorbPointer(
                // to prevent manual editing
                child: TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'Select your date of birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _professionController,
              decoration: InputDecoration(labelText: 'Profession'),
            ),
            ListTile(
              title: Text('Mentor'),
              leading: Radio(
                value: 'mentor',
                groupValue: _role,
                onChanged: (value) {
                  setState(() {
                    _role = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Mentee'),
              leading: Radio(
                value: 'mentee',
                groupValue: _role,
                onChanged: (value) {
                  setState(() {
                    _role = value.toString();
                  });
                },
              ),
            ),
<<<<<<< HEAD
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Gender',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            ),
=======
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Gender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          ),
>>>>>>> dev-0.1
            ListTile(
              title: Text('Female'),
              leading: Radio(
                value: 'Female',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Male'),
              leading: Radio(
                value: 'Male',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
              ),
            ),
            TextField(
              controller: _profilePicUrlController,
<<<<<<< HEAD
              decoration: InputDecoration(
                  labelText: 'Profile Picture URL (optional)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signUpWithEmailAndPassword(context),
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Already Registered? Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 40, 202, 214),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
=======
              decoration:
                  InputDecoration(labelText: 'Profile Picture URL (optional)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signUpWithEmailAndPassword(context),
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),
>>>>>>> dev-0.1
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Format the date and show it in the text field
        _dobController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      // Basic email validation
      if (!_emailController.text.contains('@') ||
          !_emailController.text.contains('.')) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a valid email address.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'profilePicUrl': _profilePicUrlController.text.isEmpty ? null : _profilePicUrlController.text.trim(),
        'dob': _dobController.text,  // Ensure the date format is correct
        'profession': _professionController.text.trim(),
        'gender': _gender,
        'role': _role,
      });

        // Navigate to login page upon successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      String errorMessage = 'An unexpected error occurred. Please try again.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }
<<<<<<< HEAD
=======
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('Login Page Placeholder'),
      ),
    );
  }
>>>>>>> dev-0.1
}