// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// home_screen.dart

// This Flutter file implements a HomeScreen for a mobile application, providing a central hub with multiple functional sections including a network screen, 
// knowledge base screen, messaging screen, and profile management. It features a StatefulWidget with a BottomNavigationBar to facilitate navigation 
// between different pages dynamically using a PageController. The home screen also integrates a FloatingActionButton for quick actions and uses a PageView 
// to manage the rendering of different screens based on user selection. Additionally, a custom SearchDelegate is used to handle search functionality 


// Importing necessary Flutter and Firebase libraries.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './profile_page.dart';  
import './network_screen.dart';
import './knowledgebase_screen.dart';
import 'conversation_screen.dart'; 
import './picture_screen.dart';

// HomeScreen StatefulWidget to manage state that changes over time.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// State class for HomeScreen, managing the selected index and page controller.
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Tracks the current selected index of bottom navigation.
  late PageController _pageController; // Controller to manage page view navigation.

  // Initializes state, setting up the page controller.
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  // Builds the UI elements of the home screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor Match'), // AppBar title
        backgroundColor: Colors.teal, // Sets the background color of AppBar
        elevation: 4.0, // Shadow depth beneath the AppBar.
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: DataSearch()); // Initiates a search delegate when pressed.
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
            selectedItemColor: Colors.teal, // Highlight color for selected item.
            unselectedItemColor: Colors.grey, // Color for unselected items.
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeIn, // Animation curve for page transition.
                );
              });
            },
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                _buildHomePage(), // Builds the home page view.
                NetworkScreen(), // Network screen widget.
                KnowledgeBaseScreen(), // Knowledge base screen widget.
                ConversationsScreen(), // Conversations screen widget.
                ProfileScreen(), // Profile screen widget.
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PictureScreen()), // Navigates to the picture screen.
          );
          setState(() {}); // Refresh the home screen to display new pictures
        },
        child: Icon(Icons.add), // Icon inside FloatingActionButton
      ),
    );
  }

  // Builds the home page content within a stream builder fetching pictures.
  Widget _buildHomePage() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('pictures').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator()); // Loading indicator
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return Card(
              clipBehavior: Clip.antiAlias, // Card clipping behavior
              color: Colors.grey[200], // Background color of the card
              margin: EdgeInsets.all(8), // Margin around the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(doc['url'], fit: BoxFit.cover), // Displays image from URL
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(doc['caption'], style: TextStyle(fontSize: 16)), // Displays image caption
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Custom search delegate class to handle search operations.
class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''), // Clear the search query.
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, // Leading icon with animation
        progress: transitionAnimation, // Animation progress
      ),
      onPressed: () => close(context, ''), // Closes the search when tapped.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text(query)); // Displays the search query as a result.
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? ['Recent search'] // Default suggestions
        : ['Example suggestion 1', 'Example suggestion 2']; // Suggestions based on the user's input
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
        onTap: () {
          query = suggestionList[index]; // Update the query with the selected suggestion.
          showResults(context); // Show results based on the selected suggestion.
        },
      ),
    );
  }
}
