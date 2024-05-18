// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// network_screen.dart

// This Flutter file implements the NetworkScreen for a mobile application, providing functionality to manage network connections.
// It supports sending connection requests, accepting requests, and viewing current connections. The screen uses a StatefulWidget to handle 
// dynamic data updates from Firebase Firestore and FirebaseAuth to manage user authentication states and interactions. This screen is crucial
// for building a professional networking platform, enabling users to connect, accept connections, and access user profiles.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'chat_screen.dart'; 
import 'user_profile.dart'; 

// StatefulWidget for managing network connections.
class NetworkScreen extends StatefulWidget {
  @override
  _NetworkScreenState createState() => _NetworkScreenState();
}

// State class for NetworkScreen, handling the logic of network interactions.
class _NetworkScreenState extends State<NetworkScreen> {
  late String userId; // Stores the current user's ID
  Set<String> _requestedUsers = Set(); // Users to whom connection requests have been sent
  Set<String> _pendingUsers = Set(); // Users from whom connection requests have been received
  Set<String> _activeConnections = Set(); // Established connections with other users
  StreamSubscription<User?>? _userSubscription; // Subscription to listen to auth state changes

  // Initialize state, setting up listeners for user authentication and fetching initial connections.
  @override
  void initState() {
    super.initState();
    _userSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
        _fetchConnections(); // Fetch existing connections when the user is authenticated
      }
    });
  }

  // Clean up by cancelling subscriptions.
  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  // Sends a connection request to another user.
  Future<void> _sendConnectionRequest(String receiverId) async {
    if (!_requestedUsers.contains(receiverId)) { // Check if the request has already been sent
      await FirebaseFirestore.instance.collection('connections').add({
        'senderId': userId,
        'receiverId': receiverId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        setState(() {
          _requestedUsers.add(receiverId);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection request sent successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection already exists or pending.")),
      );
    }
  }

  // Updates the status of a connection.
  Future<void> _updateConnectionStatus(
      String connectionId, String status) async {
    await FirebaseFirestore.instance
        .collection('connections')
        .doc(connectionId)
        .update({
      'status': status,
    });
    if (mounted) {
      setState(() {
        _pendingUsers.removeWhere((id) => id == connectionId);
        _activeConnections.add(connectionId);
      });
    }
  }

  // Fetches all connections related to the user.
  Future<void> _fetchConnections() async {
    try {
      var connectionsSnapshot = await FirebaseFirestore.instance
          .collection('connections')
          .where('senderId', isEqualTo: userId)
          .get();

      var receivedConnectionsSnapshot = await FirebaseFirestore.instance
          .collection('connections')
          .where('receiverId', isEqualTo: userId)
          .get();

      if (mounted) {
        setState(() {
          _requestedUsers.clear();
          _pendingUsers.clear();
          _activeConnections.clear();
          _requestedUsers.addAll(connectionsSnapshot.docs
              .where((doc) => doc['status'] == 'pending')
              .map((doc) => doc['receiverId'] as String));
          _pendingUsers.addAll(receivedConnectionsSnapshot.docs
              .where((doc) => doc['status'] == 'pending')
              .map((doc) => doc['senderId'] as String));
          _activeConnections.addAll(connectionsSnapshot.docs
              .where((doc) => doc['status'] == 'accepted')
              .map((doc) => doc['receiverId'] as String));
          _activeConnections.addAll(receivedConnectionsSnapshot.docs
              .where((doc) => doc['status'] == 'accepted')
              .map((doc) => doc['senderId'] as String));
        });
      }
    } catch (e) {
      print("Failed to fetch connections: $e");
    }
  }

  // Builds a list of users based on a specified role, excluding self and connected or pending users.
  Widget _buildUserList() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String filterRole = 'mentor'; // Default role to show mentors

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: filterRole)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var userDoc = snapshot.data!.docs[index];
            if (userDoc.id == userId ||
                _activeConnections.contains(userDoc.id) ||
                _requestedUsers.contains(userDoc.id) ||
                _pendingUsers.contains(userDoc.id)) {
              return Container(); // Skip listing the current user and those already connected or requested
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: userDoc['profilePicUrl'] != null
                    ? NetworkImage(userDoc['profilePicUrl'])
                    : AssetImage('assets/default_image.png') as ImageProvider,
              ),
              title: Text(userDoc['fullName']),
              subtitle: Text(
                  '${userDoc['profession'] ?? 'No profession'} (${userDoc['role'] ?? 'No role'})'),
              onTap: () {
                // Navigate to the UserProfilePage with details when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(userData: {
                      'fullName': userDoc['fullName'],
                      'email': userDoc['email'], // Assuming email is available in userDoc
                      'profession': userDoc['profession'],
                      'role': userDoc['role'],
                      'profilePicUrl': userDoc['profilePicUrl'] // Assuming profilePicUrl is available
                    }),
                  ),
                );
              },
              trailing: ElevatedButton(
                onPressed: () => _sendConnectionRequest(userDoc.id),
                child: Text('Send Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Custom background color
                  foregroundColor: Colors.white, // Custom text color
                  shape: RoundedRectangleBorder(
                    // Rounded corners
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0, // No shadow
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Builds a list of pending connection requests.
  Widget _buildPendingRequests() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('connections')
          .where('receiverId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var connectionDoc = snapshot.data!.docs[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(connectionDoc['senderId'])
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return CircularProgressIndicator();
                if (userSnapshot.error != null)
                  return Text('Failed to load data');
                if (!userSnapshot.data!.exists)
                  return Text('User data not found');

                Map<String, dynamic> userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData['profilePicUrl'] ??
                        'assets/default_image.png'),
                  ),
                  title: Text(userData['fullName'] ?? 'Unknown'),
                  subtitle: Text(
                      '${userData['profession'] ?? 'No profession'} (${userData['role'] ?? 'No role'})\nPending Request'),
                  onTap: () {
                    // Navigate to the UserProfilePage when the ListTile is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfilePage(userData: userData),
                      ),
                    );
                  },
                  trailing: ElevatedButton(
                    onPressed: () =>
                        _updateConnectionStatus(connectionDoc.id, 'accepted'),
                    child: Text('Accept'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.teal),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.teal.withOpacity(0.2);
                        }
                        return null; // Default behavior
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.teal))),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Builds a list of active connections for the user.
  Widget _buildActiveConnections() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('connections')
          .where('status', isEqualTo: 'accepted')
          .where('receiverId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('connections')
              .where('status', isEqualTo: 'accepted')
              .where('senderId', isEqualTo: userId)
              .snapshots(),
          builder: (context, senderSnapshot) {
            if (senderSnapshot.hasData) {
              documents.addAll(senderSnapshot.data!.docs);
            }
            documents = documents.toSet().toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var connectionDoc = documents[index];
                var otherUserId = connectionDoc['senderId'] == userId
                    ? connectionDoc['receiverId']
                    : connectionDoc['senderId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData)
                      return CircularProgressIndicator();
                    if (userSnapshot.error != null)
                      return Text('Failed to load data');
                    if (!userSnapshot.data!.exists)
                      return Text('User not found');

                    Map<String, dynamic> userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: userData['profilePicUrl'] != null
                            ? NetworkImage(userData['profilePicUrl'])
                            : AssetImage('assets/default_image.png')
                                as ImageProvider,
                      ),
                      title: Text(userData['fullName'] ?? 'Unknown'),
                      subtitle: Text('Active Connection'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserProfilePage(userData: userData),
                          ),
                        );
                      },
                      trailing: ElevatedButton(
                        onPressed: () {
                          String chatId = _generateChatId(userId, otherUserId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(chatId: chatId),
                              ));
                        },
                        child: Text('Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, // Teal background color
                          foregroundColor: Colors.white, // Text color is white
                          shape: RoundedRectangleBorder(
                              // Adds rounded corners
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // Generates a unique chat ID based on user IDs for direct messaging.
  String _generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }

  // Main widget build method to construct the UI elements of the Network screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Network"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Available Users',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildUserList(), // Displays list of users to connect with.
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Pending Connection Requests',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildPendingRequests(), // Displays list of pending connection requests.
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Active Connections',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildActiveConnections(), // Displays list of active connections.
          ],
        ),
      ),
    );
  }
}
