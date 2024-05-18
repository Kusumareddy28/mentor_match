// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// connection_details_screen.dart

// This Flutter file implements a details screen for viewing connection profiles in a mobile application. 
// It features a ConnectionDetailsScreen stateless widget that displays details such as profile picture, name, and bio using a clean and simple layout.
// The screen is structured to display a central CircleAvatar widget for the profile picture, fetched from a URL, and Text widgets for the name and bio, 
// ensuring that the content is both visually appealing and easy to read. This setup provides a straightforward way to view detailed information about a connection within the app.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Stateless widget for displaying connection details.
class ConnectionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> connection; // Holds the details of the connection.

  // Constructor that requires a connection map.
  ConnectionDetailsScreen(this.connection);

  @override
  // Builds the UI elements for the connection details screen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Details'), // Title of the details screen.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(connection['profilePicUrl']), // Displays the connection's profile picture.
              radius: 50.0,
            ),
            SizedBox(height: 16.0), // Adds space between the profile picture and name.
            Text(
              connection['name'], // Displays the connection's name.
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0), // Adds space between the name and bio.
            Text(
              connection['bio'], // Displays the connection's bio.
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
