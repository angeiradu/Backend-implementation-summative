import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Login Signup/Screen/login.dart';
import '../Login With Google/google_auth.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String _userName = 'User';
  final List<Map<String, dynamic>> drawerItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Tips', 'icon': Icons.lightbulb_outline, 'route': '/tips'},
    {'title': 'Workout', 'icon': Icons.fitness_center, 'route': '/workout'},
    {'title': 'Meal Plan', 'icon': Icons.restaurant_menu, 'route': '/meal_plan'},
    {'title': 'Check your process', 'icon': Icons.assignment, 'route': '/check_process'},
    {'title': 'Settings', 'icon': Icons.settings, 'route': '/settings'},
    {'title': 'Support', 'icon': Icons.support_agent, 'route': '/support'},
  ];

  String _currentItemSelected = 'Workout';

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the user's name when the widget initializes
  }

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
        centerTitle: true,
        backgroundColor: Colors.teal,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF557E7E),
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
                        backgroundImage: AssetImage('assets/profile.png'),
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
                Divider(color: Colors.white),
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
                          Navigator.pop(context);
                          if (_currentItemSelected != item['title']) {
                            Navigator.pushNamed(context, item['route']);
                          }
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.white),
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
                    await FirebaseServices().googleSignOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
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
        length: 2, // Changed from 3 to 2
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                tabs: [
                  Tab(text: 'My Workout'), // No change here
                  Tab(text: 'All Workout'), // Changed from 'Foot' to 'All Workout'
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
                    _buildWorkoutTabView(),
                    _buildAllWorkoutTabView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add, color: Colors.white), // Icon color
        backgroundColor: Colors.teal, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Fully rounded button
        ),
      ),
    );
  }

  Widget _buildWorkoutTabView() {
    // Display only user's items
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('items').where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var documents = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0, // Reduced spacing between columns
            mainAxisSpacing: 4.0, // Reduced spacing between rows
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
              ),
              child: Container(
                margin: EdgeInsets.all(4.0), // Reduced margin around each grid item
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
                              onPressed: () => _showEditDialog(context, item.id, item['title'], item['url']),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red), // Delete icon in red
                              onPressed: () => _showDeleteDialog(context, item.id),
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

  Widget _buildAllWorkoutTabView() {
    // Display all items
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var documents = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0, // Reduced spacing between columns
            mainAxisSpacing: 4.0, // Reduced spacing between rows
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
              ),
              child: Container(
                margin: EdgeInsets.all(4.0), // Reduced margin around each grid item
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
                      // No edit and delete icons in the All Workout tab
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

  Future<void> _showAddDialog(BuildContext context) async {
    final _titleController = TextEditingController();
    final _urlController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                String title = _titleController.text;
                String url = _urlController.text;
                if (title.isNotEmpty && url.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('items').add({
                    'title': title,
                    'url': url,
                    'userId': FirebaseAuth.instance.currentUser?.uid,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, String itemId, String itemTitle, String itemUrl) async {
    final _titleController = TextEditingController(text: itemTitle);
    final _urlController = TextEditingController(text: itemUrl);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String title = _titleController.text;
                String url = _urlController.text;
                if (title.isNotEmpty && url.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('items').doc(itemId).update({
                    'title': title,
                    'url': url,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, String itemId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDetailDialog(BuildContext context, String itemTitle, String itemUrl) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // User can tap outside to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(itemTitle),
          content: Image.network(itemUrl),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
