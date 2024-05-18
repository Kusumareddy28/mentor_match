// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// conversations_screen.dart

// This Flutter file implements a conversations screen for a mobile application using Firebase Authentication and Firestore. 
// It features a ConversationsScreen stateless widget that lists recent chats by querying messages where the current user is a participant. 
// The list is dynamically updated with Firestore's real-time capabilities, displayed using a StreamBuilder. Each conversation item is clickable, 
// leading to a detailed chat screen for that conversation. The screen handles various states like loading, errors, and empty results, providing a robust user experience.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart'; 

// Stateless widget for displaying the list of conversations.
class ConversationsScreen extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid; // Retrieves the current user's ID from Firebase Auth.

  @override
  // Builds the UI elements for the conversations screen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Chats"), // Title of the conversations screen.
        backgroundColor: Colors.teal, // Custom color for the AppBar.
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('participants', arrayContains: currentUserId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Shows a loading spinner while waiting for data.
          }
          if (snapshot.hasError) {
            // Handles specific Firestore index building errors.
            if (snapshot.error.toString().contains('index is currently building')) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.build, size: 50, color: Colors.teal),
                    SizedBox(height: 20),
                    Text(
                      'Setting things up...',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This may take a few moments. Please check back shortly.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Error: ${snapshot.error}')); // Displays other errors.
            }
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No recent chats found.")); // Message when no chats are found.
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>; // Retrieves data for each chat document.

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.chat, color: Colors.white), // Icon for each chat item.
                ),
                title: Text(data['text'] ?? "No message text"), // Displays the latest message text or a default text.
                subtitle: Text(data['participants'].join(', ')), // Shows the participants in the chat.
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(chatId: doc.id), // Navigates to the detailed chat screen when tapped.
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
