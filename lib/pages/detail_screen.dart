// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// detail_screen.dart

// This Flutter file implements a detail view for individual entries in a knowledge base application. 
// It features a DetailScreen stateless widget that displays extensive information about a KnowledgeBaseEntry object. 
// The screen layout includes the entry's title and content with appropriate styling, and showcases tags associated with the entry using ActionChips.
// This design provides an interactive and informative user experience, allowing users to view detailed information and interact with entry tags.

import 'package:flutter/material.dart';
import 'knowledgebase_entry.dart';

// Stateless widget for displaying detailed information about a knowledge base entry.
class DetailScreen extends StatelessWidget {
  final KnowledgeBaseEntry entry; // The knowledge base entry to display.

  // Constructor requiring a KnowledgeBaseEntry object.
  DetailScreen({required this.entry});

  @override
  // Builds the UI elements for the detail screen.
  Widget build(BuildContext context) {
    TextStyle headlineStyle = Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ) ??
        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold); // Style for the entry title.

    TextStyle bodyTextStyle =
        Theme.of(context).textTheme.bodyText1 ?? TextStyle(fontSize: 16.0); // Style for the entry content.

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title), // AppBar title set to the entry's title.
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0), // Padding for the body content.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              entry.title,
              style: headlineStyle, // Applies headline style to the title.
            ),
            SizedBox(height: 20), // Spacer between title and content.
            Text(
              entry.content,
              style: bodyTextStyle, // Applies body text style to the content.
            ),
            SizedBox(height: 20), // Spacer between content and tags.
            Wrap(
              spacing: 8.0, // Spacing between tag chips.
              children: entry.tags
                  .map((tag) => ActionChip(
                        backgroundColor: Colors.teal, // Custom background color for tag chips.
                        label: Text(
                          tag,
                          style: TextStyle(
                              color: Colors.white), // Custom text color for tag chips.
                        ),
                        onPressed: () {
                          // Optionally handle tag press, e.g., for filtering or search
                          print("Tag '$tag' was pressed.");
                        },
                      ))
                  .toList(), // Converts the iterable to a list of widgets.
            ),
          ],
        ),
      ),
    );
  }
}
