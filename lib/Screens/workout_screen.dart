import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Login Signup/Screen/login.dart'; // Import for the login screen
import '../Login With Google/google_auth.dart'; // Import for Google authentication

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String _userName = 'User'; // User's name, default is 'User'
  final List<Map<String, dynamic>> drawerItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Tips', 'icon': Icons.lightbulb_outline, 'route': '/tips'},
    {'title': 'Workout', 'icon': Icons.fitness_center, 'route': '/workout'},
    {'title': 'Meal Plan', 'icon': Icons.restaurant_menu, 'route': '/meal_plan'},
    {'title': 'Check your process', 'icon': Icons.assignment, 'route': '/check_process'},
    {'title': 'Settings', 'icon': Icons.settings, 'route': '/settings'},
    {'title': 'Support', 'icon': Icons.support_agent, 'route': '/support'},
  ];

  String _currentItemSelected = 'Workout'; // Currently selected item in the drawer

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the user's name when the widget initializes
  }

  // Fetch the user's name from Firestore
  Future<void> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.data()?['name'] ?? 'User';
        });
      } else {
        setState(() {
          _userName = 'User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Center the title in the AppBar
        backgroundColor: Colors.teal, // Background color of the AppBar
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF557E7E), // Background color of the drawer
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28.0,
                        backgroundImage: AssetImage('assets/profile.png'), // User's profile image
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white), // Divider between profile and drawer items
                Expanded(
                  child: ListView.builder(
                    itemCount: drawerItems.length,
                    itemBuilder: (context, index) {
                      var item = drawerItems[index];
                      return ListTile(
                        tileColor: _currentItemSelected == item['title'] ? Colors.blue[900] : Colors.transparent,
                        leading: Icon(item['icon'], color: Colors.white),
                        title: Text(
                          item['title'],
                          style: TextStyle(
                            color: _currentItemSelected == item['title'] ? Colors.white : Colors.white,
                            fontWeight: _currentItemSelected == item['title'] ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                          if (_currentItemSelected != item['title']) {
                            Navigator.pushNamed(context, item['route']); // Navigate to selected route
                          }
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.white), // Divider between drawer items and logout
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.white),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    await FirebaseServices().googleSignOut(); // Sign out user
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(), // Navigate to login screen
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                tabs: [
                  Tab(text: 'My Workout'), // Tab for user's workout
                  Tab(text: 'All Workout'), // Tab for all workouts
                ],
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.teal,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding around the GridView
                child: TabBarView(
                  children: [
                    _buildWorkoutTabView(), // View for user's workouts
                    _buildAllWorkoutTabView(), // View for all workouts
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context), // Show dialog to add new item
        child: Icon(Icons.add, color: Colors.white), // Icon color
        backgroundColor: Colors.teal, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Fully rounded button
        ),
      ),
    );
  }

  // Build the view for the "My Workout" tab
  Widget _buildWorkoutTabView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('items').where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        }

        var documents = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0, // Spacing between columns
            mainAxisSpacing: 4.0, // Spacing between rows
            childAspectRatio: 1.0,
          ),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var item = documents[index];
            return GestureDetector(
              onTap: () => _showDetailDialog(
                context,
                item['title'],
                item['url'],
              ), // Show item details dialog on tap
              child: Container(
                margin: EdgeInsets.all(4.0), // Margin around each grid item
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item['url'],
                        fit: BoxFit.cover,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 8.0,
                        right: 8.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _showEditDialog(context, item.id, item['title'], item['url']), // Show edit dialog
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red), // Delete icon in red
                              onPressed: () => _showDeleteDialog(context, item.id), // Show delete confirmation dialog
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Build the view for the "All Workout" tab
  Widget _buildAllWorkoutTabView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        }

        var documents = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0, // Spacing between columns
            mainAxisSpacing: 4.0, // Spacing between rows
            childAspectRatio: 1.0,
          ),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var item = documents[index];
            return GestureDetector(
              onTap: () => _showDetailDialog(
                context,
                item['title'],
                item['url'],
              ), // Show item details dialog on tap
              child: Container(
                margin: EdgeInsets.all(4.0), // Margin around each grid item
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item['url'],
                        fit: BoxFit.cover,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 8.0,
                        right: 8.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _showEditDialog(context, item.id, item['title'], item['url']), // Show edit dialog
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red), // Delete icon in red
                              onPressed: () => _showDeleteDialog(context, item.id), // Show delete confirmation dialog
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show dialog for adding new item
  void _showAddDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog without action
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('items').add({
                  'title': titleController.text,
                  'url': urlController.text,
                  'userId': FirebaseAuth.instance.currentUser?.uid,
                });
                Navigator.pop(context); // Close dialog after adding item
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog for editing an existing item
  void _showEditDialog(BuildContext context, String docId, String currentTitle, String currentUrl) {
    TextEditingController titleController = TextEditingController(text: currentTitle);
    TextEditingController urlController = TextEditingController(text: currentUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog without action
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('items').doc(docId).update({
                  'title': titleController.text,
                  'url': urlController.text,
                });
                Navigator.pop(context); // Close dialog after updating item
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog for confirming deletion of an item
  void _showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Workout'),
          content: Text('Are you sure you want to delete this workout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog without action
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('items').doc(docId).delete();
                Navigator.pop(context); // Close dialog after deleting item
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog displaying details of an item
  void _showDetailDialog(BuildContext context, String title, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
