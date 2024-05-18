// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// signup.dart


//This Flutter file defines a SignUpPage widget that facilitates user registration through Firebase Authentication and Firestore. 
//It includes text fields for personal details, gender and role selection via radio buttons, and buttons for registration and redirection. 
//The UI supports input validation, user data storage, and navigation control for signed-in or newly registered users.

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
  final TextEditingController _profilePicUrlController =
      TextEditingController();
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
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  controller: _dobController,
                  label: 'Date of Birth',
                  icon: Icons.calendar_today,
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _professionController,
              label: 'Profession',
              icon: Icons.work,
            ),
            SizedBox(height: 16),
            _buildRadioGroup('Role', 'Mentor', 'Mentee', _role,
                (String? value) {
              setState(() {
                _role = value!;
              });
            }),
            SizedBox(height: 16),
            _buildRadioGroup('Gender', 'Female', 'Male', _gender,
                (String? value) {
              setState(() {
                _gender = value!;
              });
            }),
            SizedBox(height: 16),
            _buildTextField(
              controller: _profilePicUrlController,
              label: 'Profile Picture URL (optional)',
              icon: Icons.link,
            ),
            SizedBox(height: 20),
            _buildSignUpButton(context),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
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
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.teal, // Set the cursor color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal), // Set the label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5), // Square-like corners
        ),
        prefixIcon: Icon(icon, color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(5), // Square-like corners
        ),
      ),
    );
  }

  Widget _buildRadioGroup(String title, String value1, String value2,
      String groupValue, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(value1),
                leading: Radio(
                  value: value1.toLowerCase(),
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: Colors.teal,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(value2),
                leading: Radio(
                  value: value2.toLowerCase(),
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _signUpWithEmailAndPassword(context),
      child: _isProcessing
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text('Sign Up', style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Square-like corners
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'profilePicUrl': _profilePicUrlController.text.isEmpty
              ? null
              : _profilePicUrlController.text.trim(),
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
