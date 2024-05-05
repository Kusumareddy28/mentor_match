import 'package:cloud_firestore/cloud_firestore.dart';

class KnowledgeBaseEntry {
  final String id;
  final String title;
  final String content;
  final List<String> tags;

  KnowledgeBaseEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
  });

  factory KnowledgeBaseEntry.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return KnowledgeBaseEntry(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      tags: List.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
    };
  }
}
