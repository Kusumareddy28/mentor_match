// import 'package:cloud_firestore/cloud_firestore.dart';
// import './knowledgebase_entry.dart';  // Update this path

// class DatabaseService {
//   final CollectionReference collection = FirebaseFirestore.instance.collection('knowledgebase');

//   Stream<List<KnowledgeBaseEntry>> getKnowledgeBaseEntries() {
//     return collection.snapshots().map((snapshot) => snapshot.docs
//       .map((doc) => KnowledgeBaseEntry.fromFirestore(doc))
//       .toList());
//   }

// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'knowledgebase_entry.dart';  // Make sure this path is correct

class DatabaseService {
  final CollectionReference collection = FirebaseFirestore.instance.collection('knowledgebase');

  // Method to get all knowledge base entries
  Stream<List<KnowledgeBaseEntry>> getKnowledgeBaseEntries() {
    return collection.snapshots().map((snapshot) => snapshot.docs
      .map((doc) => KnowledgeBaseEntry.fromFirestore(doc))
      .toList());
  }

  // Method to search entries by tag
Stream<List<KnowledgeBaseEntry>> searchEntriesByTag(String tag) {
  return collection
    .snapshots()
    .map((snapshot) => snapshot.docs
      .map((doc) => KnowledgeBaseEntry.fromFirestore(doc))
      .where((entry) => entry.tags.any((t) => t.contains(tag)))
      .toList());
}

}
