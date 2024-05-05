<<<<<<<<< Temporary merge branch 1
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
=========
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
>>>>>>>>> Temporary merge branch 2

// import 'login.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// // class _SignUpPageState extends State<SignUpPage> {
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Sign Up'),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextField(
// //               controller: _emailController,
// //               decoration: InputDecoration(labelText: 'Email'),
// //             ),
// //             TextField(
// //               controller: _passwordController,
// //               decoration: InputDecoration(labelText: 'Password'),
// //               obscureText: true,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 _signUpWithEmailAndPassword(context);
// //               },
// //               child: Text('Sign Up'),
// //             ),
// //             SizedBox(height: 20),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text('Already have an account?'),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.pushReplacement(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => LoginPage()),
// //                     );
// //                   },
// //                   child: Text('Login'),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
// //     try {
// //       if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
// //         showDialog(
// //           context: context,
// //           builder: (context) => AlertDialog(
// //             title: Text('Error'),
// //             content: Text('Please enter a valid email address.'),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           ),
// //         );
// //         return;
// //       }

// //       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
// //         email: _emailController.text,
// //         password: _passwordController.text,
// //       );

// //       // If signup is successful, navigate to the login page
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => LoginPage()),
// //       );
// //     } on FirebaseAuthException catch (e) {
// //       if (e.code == 'weak-password') {
// //         showDialog(
// //           context: context,
// //           builder: (context) => AlertDialog(
// //             title: Text('Error'),
// //             content: Text('The password provided is too weak.'),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           ),
// //         );
// //       } else if (e.code == 'email-already-in-use') {
// //         // Account already exists for the email, navigate to login page
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => LoginPage()),
// //         );
// //       }
// //     } catch (e) {
// //       print(e);
// //     }
// //   }
// // }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _profilePicUrlController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             TextField(
//               controller: _fullNameController,
//               decoration: InputDecoration(labelText: 'Full Name'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _profilePicUrlController,
//               decoration: InputDecoration(labelText: 'Profile Picture URL (optional)'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _signUpWithEmailAndPassword(context);
//               },
//               child: Text('Sign Up'),
//             ),
//             SizedBox(height: 20),
//             // ...rest of your code
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
//     try {
//       // ...existing email validation code...

//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );

//       // Add the new user's additional information to Firestore
//       if (userCredential.user != null) {
//         await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
//           'fullName': _fullNameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'profilePicUrl': _profilePicUrlController.text.isEmpty ? null : _profilePicUrlController.text.trim(),
//         });
//       }

//       // If signup is successful, navigate to the login page
//       // ...existing navigation code...

//     } on FirebaseAuthException catch (e) {
//       // ...existing error handling code...
//     } catch (e) {
//       print(e);
//     }
//   }
// }

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
  // Add the new controllers and variables
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  String _gender = 'Female'; // Default gender value
  String _role = 'mentee'; // Default role value
=========
>>>>>>>>> Temporary merge branch 2

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
<<<<<<<<< Temporary merge branch 1


            // Add new TextField for Profession

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
<<<<<<<<< Temporary merge branch 1
=========
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
>>>>>>>>> Temporary merge branch 2
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
=========
  Future<void> _signUp() async {
    try {
      if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
>>>>>>>>> Temporary merge branch 2
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

<<<<<<<<< Temporary merge branch 1
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
=========
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
>>>>>>>>> Temporary merge branch 2
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

<<<<<<<<< Temporary merge branch 1
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
=========
      // If signup is successful, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('The password provided is too weak.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        // Account already exists for the email, navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
>>>>>>>>> Temporary merge branch 2
    } catch (e) {
      print(e);
    }
  }
}
