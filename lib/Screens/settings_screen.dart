// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

import '../Login Signup/Screen/login.dart';
import '../Login With Google/google_auth.dart';

// A stateless widget that represents the Settings screen
class SettingsScreen extends StatelessWidget {
  // List of drawer items with their titles, icons, and routes
  final List<Map<String, dynamic>> drawerItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Tips', 'icon': Icons.lightbulb_outline, 'route': '/tips'},
    {'title': 'Workout', 'icon': Icons.fitness_center, 'route': '/workout'},
    {'title': 'Meal Plan', 'icon': Icons.restaurant_menu, 'route': '/meal_plan'},
    {'title': 'Check your process', 'icon': Icons.assignment, 'route': '/check_process'},
    {'title': 'Settings', 'icon': Icons.settings, 'route': '/settings'},
    {'title': 'Support', 'icon': Icons.support_agent, 'route': '/support'},
  ];

  // The currently selected drawer item
  String _currentItemSelected = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings', // The title displayed on the AppBar
          style: TextStyle(
            color: Colors.white, // The color of the title text
          ),
        ),
        centerTitle: true, // Centers the title text horizontally
        backgroundColor: Colors.teal, // The background color of the AppBar
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white, // The color of the menu icon
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer when the menu icon is tapped
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF557E7E), // Background color of the drawer
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                // User profile information in the drawer
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
                              color: Colors.white, // Text color
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Online', // User's status
                            style: TextStyle(
                              color: Colors.green, // Status color
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white), // Divider line
                // List of navigation items in the drawer
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: drawerItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(drawerItems[index]['icon'], color: Colors.white), // Icon for the drawer item
                      title: Text(
                        drawerItems[index]['title'], // Title for the drawer item
                        style: TextStyle(
                          color: _currentItemSelected == drawerItems[index]['title'] ? Colors.blue[900] : Colors.white,
                          fontWeight: _currentItemSelected == drawerItems[index]['title'] ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        if (_currentItemSelected != drawerItems[index]['title']) {
                          Navigator.pushNamed(context, drawerItems[index]['route']); // Navigate to the selected route
                        }
                      },
                    );
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Divider(color: Colors.white),
                        ListTile(
                          leading: const Icon(Icons.exit_to_app, color: Colors.white), // Icon for the logout option
                          title: const Text(
                            'Logout', // Logout label
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onTap: () async {
                            await FirebaseServices().googleSignOut(); // Sign out from Google
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(), // Navigate to the login screen
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.assignment_turned_in_outlined), // Icon for the item
            title: const Text('Reminders'), // Title of the item
            trailing: const Icon(Icons.arrow_right), // Trailing arrow icon
            onTap: () {
              // Handle tap
            },
          ),
          const Divider(), // Divider line
          ListTile(
            leading: const Icon(Icons.help_outline), // Icon for the item
            title: const Text('Help'), // Title of the item
            trailing: const Icon(Icons.arrow_right), // Trailing arrow icon
            onTap: () {
              // Handle tap
            },
          ),
          const Divider(), // Divider line
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined), // Icon for the item
            title: const Text('Privacy checkup'), // Title of the item
            trailing: const Icon(Icons.arrow_right), // Trailing arrow icon
            onTap: () {
              // Handle tap
            },
          ),
          const Divider(), // Divider line
          ListTile(
            leading: const Icon(Icons.update), // Icon for the item
            title: const Text('Status Update'), // Title of the item
            trailing: const Icon(Icons.arrow_right), // Trailing arrow icon
            onTap: () {
              // Handle tap
            },
          ),
          const Divider(), // Divider line
          ListTile(
            leading: const Icon(Icons.lock_outline), // Icon for the item
            title: const Text('Reset password'), // Title of the item
            trailing: const Icon(Icons.arrow_right), // Trailing arrow icon
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
    );
  }
}
