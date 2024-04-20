import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import './login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File _profilePicture;
  late File _backgroundPicture;
  String _location = 'Unknown';

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

  Future<void> _updateLocation() async {
    try {
      // Request location permissions
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, request the user to enable them
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, show an error message
          return Future.error('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, show an error message
        return Future.error('Location permissions are denied forever.');
      }

      // Get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode the position to get the location name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String location = '${placemark.locality}, ${placemark.administrativeArea}';

        // Update the location in the state
        setState(() {
          _location = location;
        });

        // Display a dialog to confirm the location update
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Update Location'),
            content: Text('Your location will be updated to: $location'),
            actions: [
              TextButton(
                onPressed: () {
                  // Update the user's location in your app's data
                  // You can save the location to a database, user profile, or any other storage
                  print('Location updated to: $location');
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      } else {
        // Handle the case where no placemarks are found
        print('Unable to determine location name.');
      }
    } catch (e) {
      // Handle any errors that occur during the location update process
      print('Error updating location: $e');
    }
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
            TextButton(
              onPressed: _updateLocation,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 4, 198, 211)), // Background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
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
              'Current Location: $_location',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
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
