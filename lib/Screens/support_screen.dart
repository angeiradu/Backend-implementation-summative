import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for database operations
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication for managing user sessions
import 'package:flutter/material.dart'; // Flutter's material design package

import '../Login Signup/Screen/login.dart'; // Import for the login screen
import '../Login With Google/google_auth.dart'; // Import for Google authentication

// StatelessWidget for the support screen
class SupportScreen extends StatelessWidget {
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

  // Controllers for managing text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  String _currentItemSelected = 'Support'; // Default selected drawer item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support',
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
                Scaffold.of(context).openDrawer(); // Open drawer on button press
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
                // User profile section in the drawer
                Container(
                  height: 100.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28.0,
                        backgroundImage: AssetImage('assets/profile.png'), // Profile image
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IRADUKUNDA Ange', // User's name
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Online', // Online status
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
                const Divider(color: Colors.white), // Divider line in the drawer
                // List of drawer items
                for (var item in drawerItems)
                  ListTile(
                    leading: Icon(item['icon'], color: Colors.white),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        color: _currentItemSelected == item['title']
                            ? Colors.blue[900]
                            : Colors.white, // Highlight selected item
                        fontWeight: _currentItemSelected == item['title']
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close drawer on item tap
                      if (_currentItemSelected != item['title']) {
                        Navigator.pushNamed(context, item['route']); // Navigate to the selected screen
                      }
                    },
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Divider(color: Colors.white), // Divider above logout option
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
                            await FirebaseAuth.instance.signOut(); // Sign out the user
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
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              const Text(
                'What do you need from us?', // Title for the support form
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50.0),
              // Text field for user's full name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 20.0),
              // Text field for user's email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 20.0),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your problem', // Label for the problem description field
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              // Text field for entering the problem description
              TextFormField(
                controller: _problemController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text.trim(); // Get the entered name
                    final email = _emailController.text.trim(); // Get the entered email
                    final problem = _problemController.text.trim(); // Get the entered problem description

                    if (name.isEmpty || email.isEmpty || problem.isEmpty) {
                      // Show error message if any field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields.')),
                      );
                      return;
                    }

                    try {
                      final firestore = FirebaseFirestore.instance;
                      // Add support request to Firestore
                      await firestore.collection('support_requests').add({
                        'name': name,
                        'email': email,
                        'problem': problem,
                        'timestamp': FieldValue.serverTimestamp(), // Add server timestamp
                      });

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Request submitted successfully.')),
                      );

                      // Clear form fields
                      _nameController.clear();
                      _emailController.clear();
                      _problemController.clear();
                    } catch (e) {
                      // Handle errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('An error occurred: $e')),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.teal), // Button background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Button text color
                  ),
                  child: const Text('Send'), // Button label
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
