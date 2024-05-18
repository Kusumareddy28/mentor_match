// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// knowledge_base_entry.dart

// This Dart file defines the KnowledgeBaseEntry class, which models an entry in a knowledge base for a mobile application.
// The class includes properties such as id, title, content, and tags, making it well-suited for storing and retrieving 
// knowledge base data from Firestore. It includes a factory constructor to create instances from Firestore documents 
// and a method to serialize instances into a Firestore-compatible format. This setup ensures that the data structure 
// is maintained consistently across the application and database, facilitating easy data management and retrieval.

import 'package:cloud_firestore/cloud_firestore.dart';

// Represents an entry in the knowledge base.
class KnowledgeBaseEntry {
  final String id;        // Unique identifier for the entry.
  final String title;     // Title of the entry.
  final String content;   // Content of the entry.
  final List<String> tags; // Tags associated with the entry.

  // Constructor to create a new knowledge base entry.
  KnowledgeBaseEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
  });

  // Factory constructor to create an entry from a Firestore document.
  factory KnowledgeBaseEntry.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return KnowledgeBaseEntry(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      tags: List.from(data['tags'] ?? []),
    );
  }

  // Converts an entry to a map for Firestore storage.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
    };
  }
}
