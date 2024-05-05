import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class NetworkScreen extends StatefulWidget {
  @override
  _NetworkScreenState createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  late String userId;
  Set<String> _requestedUsers = Set();
  Set<String> _pendingUsers = Set();
  Set<String> _activeConnections = Set();
  StreamSubscription<User?>? _userSubscription;

  @override
  void initState() {
    super.initState();
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
        _fetchConnections();
      }
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
Future<void> _sendConnectionRequest(String receiverId) async {
  if (!_requestedUsers.contains(receiverId)) {
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


Future<void> _updateConnectionStatus(String connectionId, String status) async {
  await FirebaseFirestore.instance.collection('connections').doc(connectionId).update({
    'status': status,
  });
  if (mounted) {
    setState(() {
      _pendingUsers.removeWhere((id) => id == connectionId);
      _activeConnections.add(connectionId);
    });
  }
}

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

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var userDoc = snapshot.data!.docs[index];
            if (userDoc.id == userId || _activeConnections.contains(userDoc.id) || _requestedUsers.contains(userDoc.id) || _pendingUsers.contains(userDoc.id)) {
              return Container(); // Skip current user and already connected or pending users
            }
            return ListTile(
              title: Text(userDoc['fullName']),
              subtitle: Text(userDoc['email']),
              trailing: ElevatedButton(
                onPressed: () => _sendConnectionRequest(userDoc.id),
                child: Text('Send Request'),
              ),
            );
          },
        );
      },
    );
  }

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
              future: FirebaseFirestore.instance.collection('users').doc(connectionDoc['senderId']).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return CircularProgressIndicator();
                if (userSnapshot.error != null) return Text('Failed to load data');
                if (!userSnapshot.data!.exists) return Text('User data not found');

                Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData['profilePicUrl'] ?? 'default_image_url_here'),
                  ),
                  title: Text(userData['fullName'] ?? 'Unknown'),
                  subtitle: Text('Pending Request'),
                  trailing: ElevatedButton(
                    onPressed: () => _updateConnectionStatus(connectionDoc.id, 'accepted'),
                    child: Text('Accept'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

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

        // Fetch connections where the current user is the sender
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
            // Remove duplicates if any and sort or process as needed
            documents = documents.toSet().toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var connectionDoc = documents[index];
                var otherUserId = connectionDoc['senderId'] == userId ? connectionDoc['receiverId'] : connectionDoc['senderId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) return CircularProgressIndicator();
                    if (userSnapshot.error != null) return Text('Failed to load data');
                    if (!userSnapshot.data!.exists) return Text('User not found');

                    Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: userData['profilePicUrl'] != null
                          ? NetworkImage(userData['profilePicUrl'])
                          : AssetImage('assets/default_image.png') as ImageProvider,
                      ),
                      title: Text(userData['fullName'] ?? 'Unknown'),
                      subtitle: Text('Active Connection'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Interaction logic here, e.g., open chat
                        },
                        child: Text('Message'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Available Users', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildUserList(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Pending Connection Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildPendingRequests(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Active Connections', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildActiveConnections(),
          ],
        ),
      ),
    );
  }
}
