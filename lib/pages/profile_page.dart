

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File _profilePicture;
  late File _backgroundPicture;

  @override
  void initState() {
    super.initState();
    _profilePicture = File('assets/profile_picture.jpg');
    _backgroundPicture = File('assets/background_picture.jpg');
  }

  Future<void> _takeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
      }
    });
  }

  Future<void> _takeBackgroundPicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _backgroundPicture = File(pickedFile.path);
      }
    });
  }

  // Function to handle logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login page or any other appropriate page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Handle logout error
      print('Error logging out: $e');
    }
  }

  // Method to handle the "Update Location" button tap
  void _updateLocation() {
    // Implement the desired action here
    print('Updating location...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(_backgroundPicture),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: _takeProfilePicture,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 60,
              backgroundImage: FileImage(_profilePicture),
            ),
            SizedBox(height: 20),
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Software Engineer | Open to opportunities',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bio:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Passionate software engineer with expertise in mobile app development. Currently exploring Flutter for cross-platform app development.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            // Button to update location

           TextButton(
                  onPressed: _updateLocation,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 4, 198, 211)), // Background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                    // You can also customize other properties such as padding, shape, etc.
                    // For example:
                    // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                    // shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                  child: Text(
                    'Update Location',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
            SizedBox(height: 20),
            Text(
              'Connections:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: 10, // Replace with actual number of connections
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 4, 198, 211),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Connection $index'),
                    subtitle: Text('Software Engineer'),
                    onTap: () {
                      // Navigate to connection's profile
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
