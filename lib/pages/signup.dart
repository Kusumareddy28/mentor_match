import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _profilePicUrlController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  String _gender = 'Female'; // Default gender value
  String _role = 'mentee'; // Default role value
  bool _isProcessing = false;

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
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),


            // Add new TextField for Profession

            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Gender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          ),
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
              decoration:
                  InputDecoration(labelText: 'Profile Picture URL (optional)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signUpWithEmailAndPassword(context),
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),
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
        _dobController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Basic email validation
      if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
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

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'profilePicUrl': _profilePicUrlController.text.isEmpty ? null : _profilePicUrlController.text.trim(),
          'dob': _dobController.text,
          'profession': _professionController.text.trim(),
          'gender': _gender,
          'role': _role,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(_getFirebaseAuthErrorMessage(e)),
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
        _isProcessing = false;
      });
    }
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'An account already exists for that email.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
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
}