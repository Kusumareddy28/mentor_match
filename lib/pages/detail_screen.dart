import 'package:flutter/material.dart';
import 'knowledgebase_entry.dart';  // Ensure this path is correct

class DetailScreen extends StatelessWidget {
  final KnowledgeBaseEntry entry;

  DetailScreen({required this.entry});

  @override
  Widget build(BuildContext context) {
    TextStyle headlineStyle = Theme.of(context).textTheme.headline6?.copyWith(
      fontWeight: FontWeight.bold,
    ) ?? TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);

    TextStyle bodyTextStyle = Theme.of(context).textTheme.bodyText1 ?? TextStyle(fontSize: 16.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              entry.title,
              style: headlineStyle,
            ),
            SizedBox(height: 20),
            Text(
              entry.content,
              style: bodyTextStyle,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: entry.tags.map((tag) => ActionChip(
                label: Text(tag),
                onPressed: () {
                  // Optionally handle tag press, e.g., for filtering or search
                  print("Tag '$tag' was pressed.");
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
