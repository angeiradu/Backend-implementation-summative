// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../Login Signup/Screen/login.dart';
import '../Login With Google/google_auth.dart';

// The main screen for the dashboard
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

// The state for the DashboardScreen
class _DashboardScreenState extends State<DashboardScreen> {
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
  String _currentItemSelected = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dashboard'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
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
                // User profile and status display in the drawer
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
                // Display drawer items as list tiles
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
                      setState(() {
                        _currentItemSelected = item['title'];
                      });
                      Navigator.pop(context); // Close the drawer after selection
                      Navigator.pushNamed(context, item['route']); // Navigate to the selected route
                    },
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                            // Log out and navigate to the login screen
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
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the dashboard image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/dashboard.png',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            // Grid view with dashboard options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(8.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: <Widget>[
                  _buildCard('Home', Icons.home, '/home'),
                  _buildCard('Meal Plan', Icons.restaurant_menu, '/meal_plan'),
                  _buildCard('Tips', Icons.lightbulb_outline, '/tips'),
                  _buildCard('Check', Icons.check_circle_outline, '/check'),
                  _buildCard('Workout', Icons.fitness_center, '/workout'),
                  _buildCard('Support', Icons.support_agent, '/support'),
                  _buildCard('Settings', Icons.settings, '/settings'),
                ].map((Widget widget) {
                  return SizedBox(
                    width: 150.0,
                    height: 150.0,
                    child: widget,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a card for each dashboard option
  Widget _buildCard(String title, IconData icon, String route) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route); // Navigate to the specified route
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 40.0),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
