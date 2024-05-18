// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// knowledge_base_screen.dart

// This Flutter file implements the KnowledgeBaseScreen for a mobile application, providing a user interface to view and search through knowledge base entries.
// The screen features a StatefulWidget that manages a search functionality, allowing users to filter entries by tags. It utilizes a custom DatabaseService to fetch entries,
// and displays them in a list. Users can tap on any entry to view detailed information on a separate DetailScreen. The screen handles loading states and search inputs dynamically.

import 'package:flutter/material.dart';
import 'knowledgebase_entry.dart'; // Models for knowledge base entries
import 'database_service.dart'; // Access to database functions for fetching knowledge base data
import 'detail_screen.dart'; // Screen to display detailed entry information

// StatefulWidget to create and maintain the state of the Knowledge Base screen.
class KnowledgeBaseScreen extends StatefulWidget {
  @override
  _KnowledgeBaseScreenState createState() => _KnowledgeBaseScreenState(); // State creation for the screen
}

// State class for the KnowledgeBaseScreen, managing UI state and data interactions.
class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  final TextEditingController _searchController = TextEditingController(); // Controller for the search text field
  Stream<List<KnowledgeBaseEntry>>? _entriesStream; // Stream to handle real-time entry updates

  @override
  void initState() {
    super.initState();
    _entriesStream = DatabaseService().getKnowledgeBaseEntries(); // Fetch all entries on initial load
  }

  // Function to handle search by tags, updating the entries stream based on the search term.
  void _searchByTag(String tag) {
    setState(() {
      _entriesStream = DatabaseService().searchEntriesByTag(tag.trim()); // Fetch entries that match the specified tag
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KnowledgeBase"), // AppBar title for the screen
        backgroundColor: Colors.teal, // AppBar background color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController, // Text field for entering search tags
              decoration: InputDecoration(
                labelText: 'Search by tag', // Label text for the text field
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _searchController.clear(), // Clear the search field
                ),
              ),
              onSubmitted: _searchByTag, // Perform search when a tag is submitted
            ),
          ),
          Expanded(
            child: StreamBuilder<List<KnowledgeBaseEntry>>(
              stream: _entriesStream, // Listening to the stream of entries
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}"); // Display errors if any
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator()); // Show loading indicator while data is loading

                final entries = snapshot.data!;
                if (entries.isEmpty)
                  return Center(child: Text("No entries found")); // Message displayed if no entries are found

                return ListView.builder(
                  itemCount: entries.length, // Number of entries to display
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(entries[index].title), // Display the title of the entry
                      subtitle: Text(entries[index].tags.join(', ')), // Display the tags associated with the entry
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(entry: entries[index]))); // Navigate to the DetailScreen on tap
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
