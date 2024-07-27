import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Login Signup/Screen/login.dart';
import '../Login With Google/google_auth.dart';

class TipsScreen extends StatelessWidget {
  // List of drawer items with titles, icons, and routes
  final List<Map<String, dynamic>> drawerItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Tips', 'icon': Icons.lightbulb_outline, 'route': '/tips'},
    {'title': 'Workout', 'icon': Icons.fitness_center, 'route': '/workout'},
    {'title': 'Meal Plan', 'icon': Icons.restaurant_menu, 'route': '/meal_plan'},
    {'title': 'Check your process', 'icon': Icons.assignment, 'route': '/check_process'},
    {'title': 'Settings', 'icon': Icons.settings, 'route': '/settings'},
    {'title': 'Support', 'icon': Icons.support_agent, 'route': '/support'},
  ];

  String _currentItemSelected = 'Tips'; // Currently selected item in the drawer

  TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tips',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer when the menu icon is tapped
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF557E7E),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                // Drawer header with user profile picture and name
                Container(
                  height: 100.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Row(
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
                            'IRADUKUNDA Ange',
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
                const Divider(color: Colors.white),
                // List of items in the drawer
                for (var item in drawerItems)
                  ListTile(
                    leading: Icon(item['icon'], color: Colors.white),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        color: _currentItemSelected == item['title'] ? Colors.blue[900] : Colors.white,
                        fontWeight: _currentItemSelected == item['title'] ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer first
                      if (_currentItemSelected != item['title']) {
                        Navigator.pushNamed(context, item['route']); // Navigate to the selected route
                      }
                    },
                  ),
                const SizedBox(height: 16.0),
                const Divider(color: Colors.white),
                // Logout option
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    await FirebaseServices().googleSignOut(); // Sign out from Google
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
      // StreamBuilder to fetch and display tips from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tips').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator while waiting
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return const Center(child: Text('No tips available')); // Show message if no tips are available
          }

          final tips = snapshot.data?.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            return {
              'id': doc.id,
              'image': data?['url'] as String? ?? '',
              'text': data?['title'] as String? ?? '',
            };
          }).toList() ?? [];

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.05,
            ),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final imageUrl = tips[index]['image'] as String?;
              final title = tips[index]['text'] as String?;
              final id = tips[index]['id'] as String?;

              if (imageUrl != null && title != null && id != null) {
                return _buildTipCard(context, id, imageUrl, title); // Build each tip card
              } else {
                return const SizedBox.shrink(); // Return empty space if data is missing
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTipDialog(context); // Show dialog to add a new tip
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  // Show dialog to add or edit a tip
  Future<void> _showTipDialog(BuildContext context, [String? id]) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    if (id != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('tips').doc(id).get();
        final data = doc.data() as Map<String, dynamic>?;
        titleController.text = data?['title'] ?? '';
        urlController.text = data?['url'] ?? '';
      } catch (e) {
        print('Error fetching tip: $e');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? 'Add New Tip' : 'Edit Tip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Tips Title',
                ),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final title = titleController.text;
                final url = urlController.text;
                final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                if (title.isNotEmpty && url.isNotEmpty) {
                  try {
                    if (id == null) {
                      // Add new tip
                      await FirebaseFirestore.instance.collection('tips').add({
                        'title': title,
                        'url': url,
                        'timestamp': FieldValue.serverTimestamp(),
                        'userId': userId, // Add userId to the document
                      });
                    } else {
                      // Update existing tip
                      await FirebaseFirestore.instance.collection('tips').doc(id).update({
                        'title': title,
                        'url': url,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    }
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error adding/updating tip: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving tip')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out both fields')),
                  );
                }
              },
              child: Text(id == null ? 'Submit' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Delete a tip from Firestore
  Future<void> _deleteTip(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance.collection('tips').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tip deleted')),
      );
    } catch (e) {
      print('Error deleting tip: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting tip')),
      );
    }
  }

  // Build a card widget to display a tip
  Widget _buildTipCard(BuildContext context, String id, String imageUrl, String title) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showTipDialog(context, id); // Show dialog to edit the tip
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Tip'),
                          content: const Text('Are you sure you want to delete this tip?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await _deleteTip(context, id);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
