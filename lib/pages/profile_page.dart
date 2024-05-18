// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// profile_page.dart

// This Flutter file implements the ProfileScreen for a mobile application, enabling users to manage their personal profiles.
// It features functionalities such as viewing and updating user information, logging out, and updating the current location using geolocation services.
// The screen uses a StatefulWidget to handle dynamic updates to the user's profile picture, background image, and location data.
// This implementation integrates Firebase for data storage and user authentication, Geolocator for location services, and Image Picker for capturing new profile pictures.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './login.dart'; // Screen for login functionality

// StatefulWidget for managing the user profile screen.
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

// State class for ProfileScreen, handling personal profile management.
class _ProfileScreenState extends State<ProfileScreen> {
  late File _profilePicture; // File for storing the user's profile picture
  late File _backgroundPicture; // File for storing the user's background image
  String _location = 'Unknown'; // String to store the user's current location
  DocumentSnapshot? userProfileData; // DocumentSnapshot to store fetched user profile data from Firestore

  // Initializes state, sets default values for profile and background images, and fetches user profile data.
  @override
  void initState() {
    super.initState();
    _profilePicture = File('assets/profile_picture.jpg'); // Default profile picture
    _backgroundPicture = File('assets/background_picture.jpg'); // Default background image
    _fetchUserProfile(); // Fetch user profile data from Firestore
  }

  // Fetches user profile data from Firestore.
  Future<void> _fetchUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser; // Gets the current authenticated user
    if (currentUser != null) {
      try {
        var doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          setState(() {
            userProfileData = doc; // Set fetched data to userProfileData
            print('User profile data fetched successfully.');
          });
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    } else {
      print('No authenticated user found.');
    }
  }

  // Updates the user's location using the Geolocator plugin.
  Future<void> _updateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Checks if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Checks and requests location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Fetches the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Reverse geocoding to obtain location name
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String location = '${placemark.locality}, ${placemarks.first.administrativeArea}';

      // Updates location state
      setState(() {
        _location = location;
      });
    }
  }

  // Logs out the user and navigates to the login page.
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Main build method to construct UI elements of the profile screen.
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? userData = userProfileData?.data() as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Log out action
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_backgroundPicture), // Background image display
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.teal.withOpacity(0.5), BlendMode.darken),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(_profilePicture), // Profile image display
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _takeProfilePicture, // Action to take new profile picture
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 2), // Shadow positioning
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData?['fullName'] ?? 'John Doe', // Displays user's full name
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    userData?['profession'] ?? 'Software Engineer | Open to opportunities', // Displays user's profession
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                  Text('Bio',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      userData?['bio'] ?? 'Passionate software engineer with expertise in mobile app development. Currently exploring Flutter for cross-platform app development.', // Displays user's bio
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateLocation, // Action to update user's location
                    child: Text('Update Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Current Location: $_location', // Displays current location
                      style: TextStyle(fontSize: 16, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to capture a new profile picture using the camera.
  Future<void> _takeProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path); // Sets new profile picture
      });
    }
  }
}
