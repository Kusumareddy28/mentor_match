// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// chat_screen.dart

// This Flutter file implements a chat screen for a mobile application using Firebase Authentication and Firestore. 
// It features a ChatScreen stateful widget that displays real-time messages using a StreamBuilder. 
// Users can send messages through a text input field, and messages are managed with Firestore, where each message includes sender details and a timestamp. 
// The app provides live updates and handles errors effectively, ensuring a smooth user chat experience.



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Defines a stateful widget for the chat screen.
class ChatScreen extends StatefulWidget {
  final String chatId; // Unique identifier for the chat.

  // Constructor requiring a chatId.
  ChatScreen({required this.chatId});

  @override
  // Creates state for the ChatScreen widget.
  _ChatScreenState createState() => _ChatScreenState();
}

// State class for ChatScreen widget handling chat operations.
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController(); // Controller for the message input field.
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid; // Retrieves the current user's ID from Firebase Auth.

  @override
  // Builds the UI elements for the chat screen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"), // Title of the chat screen.
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Stream of messages for the current chat, ordered by timestamp.
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                // Shows loading indicator until data is fetched.
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length, // Number of messages.
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>; // Maps each message to a list tile.
                    return ListTile(
                      title: Text(message['text']), // Displays message text.
                      subtitle: Text(
                          message['fromId'] == currentUserId ? "You" : "Other"), // Checks if the message was sent by the current user.
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController, // Controls the text input for sending messages.
                    decoration: InputDecoration(
                      labelText: "Send a message...", // Placeholder text.
                      border: OutlineInputBorder(), // Border style for the input field.
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send), // Send icon button.
                  onPressed: () => _sendMessage(), // Calls the sendMessage function when pressed.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to send a message.
  void _sendMessage() {
    if (_messageController.text.isEmpty) {
      print("No message to send."); // Prints to console if no message is entered.
      return;
    }

    var message = {
      'text': _messageController.text, // Text of the message.
      'fromId': FirebaseAuth.instance.currentUser!.uid, // ID of the user sending the message.
      'timestamp': FieldValue.serverTimestamp(), // Server timestamp for the message.
    };

    FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chatId)
        .collection('messages')
        .add(message) // Adds message to Firestore.
        .then((docRef) {
      print("Message sent: ${docRef.id}"); // Confirmation message with document reference ID.
      _messageController.clear(); // Clears the message input field after sending.
    }).catchError((error) {
      print("Error sending message: $error"); // Prints error if message sending fails.
    });
  }
}
