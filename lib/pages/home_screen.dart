import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './profile_page.dart';
import './network_screen.dart';
import './knowledgebase_screen.dart';
import './message_screen.dart';
import './picture_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor Match'),
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },
        ),
      ),
      body: Column(
        children: [
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Network'),
              BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Knowledge Base Screen'),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messaging'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.5),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
          Expanded(
            child: PageView(
              children: [
                _buildHomePage(),
                NetworkScreen(),
                KnowledgeBaseScreen(),
                MessagesScreen(),
                ProfileScreen(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              controller: _pageController,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PictureScreen()),
          );
          setState(() {}); // Refresh the home screen to display new pictures
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHomePage() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('pictures').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return ListTile(
              title: Image.network(doc['url']),
              subtitle: Text(doc['caption']),
            );
          },
        );
      },
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? ['Recent search']
        : ['Example suggestion 1', 'Example suggestion 2'];
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
        onTap: () {
          query = suggestionList[index];
          showResults(context);
        },
      ),
    );
  }
}
