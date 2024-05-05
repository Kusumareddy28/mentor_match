import 'package:flutter/material.dart';
import './profile_page.dart'; // Import the profile screen Dart file
import './network_screen.dart';
import './knowledgebase_screen.dart';
import './message_screen.dart';

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
            // Implement search functionality
            showSearch(context: context, delegate: DataSearch());
          },
        ),
      ),
      body: Column(
        children: [
                    BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Network',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'Knowledge Base',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messaging',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
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
                Center(
                  child: Text('Home Screen', style: TextStyle(fontSize: 24.0)),
                ),
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
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some results based on the search
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions when typing
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
