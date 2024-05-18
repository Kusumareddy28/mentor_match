// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// user_profile.dart

// This Flutter file implements the UserProfilePage, a StatelessWidget that displays detailed information about a user.
// It showcases user-specific data such as bio, email, profession, and role, provided through a passed-in userData map.
// The page utilizes various UI components like Text, ListTile, and CircleAvatar to present the data effectively.
// The layout is structured to be visually appealing and informative, making it suitable for professional or social networking contexts.

import 'package:flutter/material.dart';

// Stateless widget for displaying user profiles.
class UserProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData; // Data for the user profile.

  UserProfilePage({Key? key, required this.userData}) : super(key: key); // Constructor with required userData parameter.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'), // AppBar title.
        backgroundColor: Colors.teal, // AppBar background color.
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildProfileHeader(context), // Builds the profile header with user image and name.
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                'About Me',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Section title for the bio.
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                userData['bio'] ?? 'This user has not provided a bio yet.', // Displays user bio or default text.
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            _buildInfoSection('Email', Icons.email, userData['email'] ?? 'N/A'), // Section for email information.
            _buildInfoSection(
                'Profession', Icons.work, userData['profession'] ?? 'N/A'), // Section for profession information.
            _buildInfoSection('Role', Icons.group, userData['role'] ?? 'N/A'), // Section for role information.
          ],
        ),
      ),
    );
  }

  // Builds the profile header with user's image, name, and headline.
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Background color for the header.
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: userData['profilePicUrl'] != null
                ? NetworkImage(userData['profilePicUrl']) // Profile picture from URL.
                : AssetImage('assets/default_image.png') as ImageProvider, // Default profile image.
          ),
          SizedBox(height: 8),
          Text(
            userData['fullName'] ?? 'Unknown User', // Displays user's full name.
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            userData['headline'] ?? 'No headline provided. Add a headline!', // Displays user's headline.
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // Builds a section with an icon and information text, used for email, profession, and role.
  Widget _buildInfoSection(String title, IconData icon, String info) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal), // Icon for the section.
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)), // Section title.
      subtitle: Text(info), // Information text.
    );
  }
}
