import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File _profilePicture;
  late File _backgroundPicture;
  String _location = 'Unknown';
  DocumentSnapshot? userProfileData;
  Set<String> connectedUserIds = {};

  List<DocumentSnapshot> acceptedConnections = [];

  @override
  void initState() {
    super.initState();
    _profilePicture = File('assets/profile_picture.jpg');
    _backgroundPicture = File('assets/background_picture.jpg');
    _fetchUserProfile();
    _fetchConnections();
    _fetchAcceptedConnections();

  }

Future<void> _fetchUserProfile() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      var doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        userProfileData = doc; // DocumentSnapshot already fetched
        setState(() {});
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }
}

  Future<void> _fetchAcceptedConnections() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        var acceptedConnectionsSnapshot = await FirebaseFirestore.instance
            .collection('connections')
            .where('status', isEqualTo: 'accepted')
            .where('senderId', isEqualTo: currentUser.uid)
            .get();

        setState(() {
          acceptedConnections = acceptedConnectionsSnapshot.docs;
        });
      } catch (e) {
        print('Error fetching accepted connections: $e');
      }
    }
  }

Future<void> _fetchConnections() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        var connectionsSnapshot = await FirebaseFirestore.instance
            .collection('connections')
            .where('status', whereIn: ['pending', 'accepted'])
            .where('senderId', isEqualTo: currentUser.uid)
            .get();
        var receivedConnectionsSnapshot = await FirebaseFirestore.instance
            .collection('connections')
            .where('status', whereIn: ['pending', 'accepted'])
            .where('receiverId', isEqualTo: currentUser.uid)
            .get();

        connectedUserIds.addAll(connectionsSnapshot.docs.map((doc) => doc['receiverId'] as String));
        connectedUserIds.addAll(receivedConnectionsSnapshot.docs.map((doc) => doc['senderId'] as String));

        setState(() {});
      } catch (e) {
        print('Error fetching connections: $e');
      }
    }
  }

  Widget _buildAvailableUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users')
          .where(FieldPath.documentId, isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var userDoc = snapshot.data!.docs[index];
            var userId = userDoc.id;

            if (connectedUserIds.contains(userId)) {
              return Container(); // Skip rendering this user
            }

            return ListTile(
              leading: CircleAvatar(),
              title: Text(userDoc['fullName'] ?? 'No Name'),
              subtitle: Text(userDoc['email'] ?? 'No Email'),
              onTap: () {}, // Handle tap
            );
          },
        );
      },
    );
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
      Map<String, dynamic>? userData = userProfileData?.data() as Map<String, dynamic>?;  // Cast here

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
              child: Positioned(
                bottom: 20,
                right: 20,
                child: GestureDetector(
                  onTap: _takeProfilePicture,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 60,
              backgroundImage: FileImage(_profilePicture),
            ),
            SizedBox(height: 20),
            Text(
            userData?['fullName'] ?? 'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
            userData?['profession'] ?? 'Software Engineer | Open to opportunities',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text('Bio:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
              userData?['bio'] ?? 'Passionate software engineer with expertise in mobile app development. Currently exploring Flutter for cross-platform app development.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _updateLocation,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text('Update Location', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            Text(
              'Current Location: $_location',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Connections:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: 10, // Replace with actual number of connections
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text('Connection $index'),
                    subtitle: Text('Software Engineer'),
                    onTap: () {},
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




