import 'package:flutter/material.dart';
import './profile_page.dart'; // Import the profile screen Dart file
import './network_screen.dart';
import './jobs_screen.dart';
import './message_screen.dart';

class HomeScreen extends StatelessWidget {
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kBottomNavigationBarHeight),
          child: BottomNavigationBar(
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
                label: 'Jobs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messaging',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ), // Add a bottom navigation bar item for the profile screen
            ],
            selectedItemColor: Colors.black, // Change the color of the selected item
            unselectedItemColor: Colors.black.withOpacity(0.5),
            onTap: (index) {
  // Handle navigation based on the tapped index
  switch (index) {
    case 0:
      // Navigate to home screen
      break;
    case 1:
      // Navigate to network screen
      // Replace 'NetworkScreen()' with the actual screen you want to navigate to
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NetworkScreen()),
      );
      break;
    case 2:
      // Navigate to jobs screen
      // Replace 'JobsScreen()' with the actual screen you want to navigate to
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JobsScreen()),
      );
      break;
    case 3:
      // Navigate to messaging screen
      // Replace 'MessagingScreen()' with the actual screen you want to navigate to
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MessagesScreen()),
      );
      break;
    case 4:
      // Navigate to profile screen
      // Replace 'ProfileScreen()' with the actual screen you want to navigate to
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
      break;
  }
},

          ),
        ),
      ),
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(fontSize: 24.0),
        ),
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
