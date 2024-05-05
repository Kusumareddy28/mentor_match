// import 'package:flutter/material.dart';
// import 'knowledgebase_entry.dart';
// import 'database_service.dart';
// import 'detail_screen.dart';  // Ensure this path is correct

// class KnowledgeBaseScreen extends StatelessWidget {
//   final DatabaseService db = DatabaseService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Knowledge Base"),
//       ),
//       body: StreamBuilder<List<KnowledgeBaseEntry>>(
//         stream: db.getKnowledgeBaseEntries(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           }
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final entries = snapshot.data!;
//           return ListView.builder(
//             itemCount: entries.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(entries[index].title),
//                 subtitle: Text(entries[index].tags.join(', ')),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => DetailScreen(entry: entries[index]))
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'knowledgebase_entry.dart';
import 'database_service.dart';
import 'detail_screen.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  @override
  _KnowledgeBaseScreenState createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  final TextEditingController _searchController = TextEditingController();
  Stream<List<KnowledgeBaseEntry>>? _entriesStream;

  @override
  void initState() {
    super.initState();
    _entriesStream = DatabaseService().getKnowledgeBaseEntries(); // Initial load with all entries
  }

  void _searchByTag(String tag) {
    setState(() {
      _entriesStream = DatabaseService().searchEntriesByTag(tag.trim()); // Update stream with search results
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Knowledge Base"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchByTag(_searchController.text);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by tag',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
              ),
              onSubmitted: _searchByTag,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<KnowledgeBaseEntry>>(
              stream: _entriesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final entries = snapshot.data!;
                if (entries.isEmpty) return Center(child: Text("No entries found"));

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(entries[index].title),
                      subtitle: Text(entries[index].tags.join(', ')),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailScreen(entry: entries[index]))
                        );
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
