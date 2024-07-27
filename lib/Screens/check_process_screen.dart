import 'package:flutter/material.dart';
import '../Login Signup/Screen/login.dart';
import '../Login With Google/google_auth.dart';

// A StatefulWidget for the "Check Your Process" screen
class CheckProcessScreen extends StatefulWidget {
  const CheckProcessScreen({super.key});

  @override
  _CheckProcessScreenState createState() => _CheckProcessScreenState();
}

class _CheckProcessScreenState extends State<CheckProcessScreen> {
  // A list of drawer items with their titles, icons, and routes
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
  String _currentItemSelected = 'Check your process';

  // Controllers for the weight and height text fields
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // Function to calculate BMI
  void _calculateBMI() {
    final String weightText = _weightController.text;
    final String heightText = _heightController.text;

    if (weightText.isEmpty || heightText.isEmpty) {
      _showDialog('Error', 'Please enter both weight and height.');
      return;
    }

    final double weight = double.tryParse(weightText) ?? 0;
    final double height = double.tryParse(heightText) ?? 0;

    if (weight <= 0 || height <= 0) {
      _showDialog('Error', 'Please enter valid numbers for weight and height.');
      return;
    }

    // Calculate BMI
    final double heightInMeters = height; // Assuming the input height is in meters
    if (heightInMeters <= 0) {
      _showDialog('Error', 'Height must be greater than zero.');
      return;
    }

    final double bmi = weight / (heightInMeters * heightInMeters);

    // Display the result in a dialog
    _showDialog('BMI Result', 'Your BMI is ${bmi.toStringAsFixed(2)}');
  }

  // Function to show a dialog with a title and message
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Check Your Process',
          textAlign: TextAlign.center,
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
                // Iterate through the drawer items and create a list tile for each
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
                      Navigator.pop(context);
                      if (_currentItemSelected != item['title']) {
                        Navigator.pushNamed(context, item['route']); // Navigate to the selected route
                      }
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
                          leading: const Icon(Icons.exit_to_app, color: Colors.white),
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onTap: () async {
                            // Sign out from Google and navigate to the login screen
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/process.png',
                fit: BoxFit.cover, // Fit the image to the container
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Please enter your weight and height for checking your process',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'My Weight (kg)',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(), // Outline border for the text field
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'My Height (cm)',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(), // Outline border for the text field
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 66.0),
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.teal,
                ),
                child: TextButton(
                  onPressed: _calculateBMI, // Call the BMI calculation function
                  child: const Text(
                    'Check',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
