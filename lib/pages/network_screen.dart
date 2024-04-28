// import 'package:flutter/material.dart';

// class NetworkScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Network'),
//       ),
//       body: Center(
//         child: Text(
//           'Network Screen',
//           style: TextStyle(fontSize: 24.0),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'connectiondetail_screen.dart';

class NetworkScreen extends StatefulWidget {
  @override
  _NetworkScreenState createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  // Add your state variables and methods here
//   Future<List<Map<String, dynamic>>> fetchConnections() async {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//     print("Current user's UID: $userId");

//   // final userId = FirebaseAuth.instance.currentUser!.uid;
//     final snapshot = await FirebaseFirestore.instance
//       .collection('connections')
//       .where('receiverId', isEqualTo: userId) // Changed to receiverId
//       .where('status', isEqualTo: 'accepted')
//       .get();


//   return snapshot.docs.map((doc) => doc.data()).toList();
// }

Future<List<Map<String, dynamic>>> fetchConnections() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  print("Current user's UID: $userId");

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('connections')
        .where('senderId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .get();

    final results = snapshot.docs.map((doc) => doc.data()).toList();
    print("Fetched connections: $results"); // This will print the fetched data

    return results;
  } catch (e) {
    print("Error fetching connections: $e"); // This will print if there's an error
    return [];
  }
}



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Network'),
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchConnections(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final connections = snapshot.data!;
          return ListView.builder(
            itemCount: connections.length,
            itemBuilder: (context, index) {
              final connection = connections[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(connection['profilePicUrl']),
                ),
                title: Text(connection['name']),
                onTap: () {
                  // Navigate to the connection details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectionDetailsScreen(connection),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching connections'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}

}
