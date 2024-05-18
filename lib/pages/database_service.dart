// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// database_service.dart

// This Flutter file provides the implementation of a database service for accessing and querying a Firestore collection titled 'knowledgebase'.
// It features a DatabaseService class that offers methods to retrieve all entries from the knowledge base and to search entries by specific tags.
// These methods return streams of lists containing KnowledgeBaseEntry objects, allowing real-time updates and interactions within the application.
// The class effectively manages the Firestore data operations, ensuring efficient data retrieval and query capabilities for the knowledge base.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'knowledgebase_entry.dart'; 

// Service class to interact with the Firestore 'knowledgebase' collection.
class DatabaseService {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('knowledgebase'); // Reference to the Firestore collection.

  // Method to get all knowledge base entries
  Stream<List<KnowledgeBaseEntry>> getKnowledgeBaseEntries() {
    return collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => KnowledgeBaseEntry.fromFirestore(doc))
        .toList()); // Maps each document snapshot to a KnowledgeBaseEntry object and collects them into a list.
  }

  // Method to search entries by tag
  Stream<List<KnowledgeBaseEntry>> searchEntriesByTag(String tag) {
    return collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => KnowledgeBaseEntry.fromFirestore(doc))
        .where((entry) => entry.tags.any((t) => t.contains(tag)))
        .toList()); // Filters entries by tags and collects them into a list.
  }
}
