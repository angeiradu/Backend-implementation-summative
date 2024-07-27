import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// The Step2Screen widget, representing the second step in a series
class Step2Screen extends StatefulWidget {
  @override
  _Step2ScreenState createState() => _Step2ScreenState();
}

// The state class for Step2Screen, containing the logic and state management
class _Step2ScreenState extends State<Step2Screen> {
  // Controllers for the text fields, managing the input data
  final _beginnerController = TextEditingController();
  final _intermediateController = TextEditingController();
  final _advancedController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed to free up resources
    _beginnerController.dispose();
    _intermediateController.dispose();
    _advancedController.dispose();
    super.dispose();
  }

  // Method to handle the submission of data
  Future<void> _submitData() async {
    final beginnerLevel = _beginnerController.text; // Get beginner level input
    final intermediateLevel = _intermediateController.text; // Get intermediate level input
    final advancedLevel = _advancedController.text; // Get advanced level input

    // Check if all fields are empty and return if true
    if (beginnerLevel.isEmpty && intermediateLevel.isEmpty && advancedLevel.isEmpty) {
      // Handle empty form case
      return;
    }

    // Get the current user's UID
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Save the data to Firestore
    try {
      await FirebaseFirestore.instance.collection('fitness_levels').add({
        'beginner': beginnerLevel,
        'intermediate': intermediateLevel,
        'advanced': advancedLevel,
        'userId': userId, // Include the user ID for reference
        'timestamp': FieldValue.serverTimestamp(), // Optional: add timestamp
      });

      // Navigate to the next step (Step 3)
      Navigator.pushNamed(context, '/step3');
    } catch (e) {
      // Handle any errors that occur during the data submission
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step 2 of 3', // Title indicating the current step
          style: TextStyle(color: Colors.teal), // Text color of the title
        ),
        centerTitle: true, // Center aligns the title horizontally
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to fill the width
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: const Text(
              'Select your fitness level', // Instructional text
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 35.0), // Spacer for layout adjustment
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                const SizedBox(height: 80.0), // Space before the input fields
                _buildLevelInput('Beginner', _beginnerController), // Input field for beginner level
                const SizedBox(height: 20.0), // Space between input fields
                _buildLevelInput('Intermediate', _intermediateController), // Input field for intermediate level
                const SizedBox(height: 20.0), // Space between input fields
                _buildLevelInput('Advanced', _advancedController), // Input field for advanced level
                const SizedBox(height: 80.0), // Space before the submit button
                ElevatedButton(
                  onPressed: _submitData, // Calls _submitData on button press
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF008080), // Button background color
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // Button text color
                    ),
                  ),
                  child: const Text('Next'), // Button label
                ),
              ],
            ),
          ),
          Container(
            height: 20.0, // Height of the progress indicator section
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center aligns the row
              children: [
                _buildCircle(0), // First circle in the progress indicator
                const SizedBox(width: 5.0), // Space between circles
                _buildCircle(1), // Second circle in the progress indicator
                const SizedBox(width: 5.0), // Space between circles
                _buildCircle(2), // Third circle in the progress indicator
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a circle indicator for the progress indicator
  Widget _buildCircle(int index) {
    // Color of the circle, teal if current step, grey otherwise
    Color color = index == 1 ? Colors.teal : Colors.grey;
    return Container(
      width: 15.0, // Width of the circle
      height: 15.0, // Height of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Makes the container circular
        color: color, // Sets the circle color
      ),
    );
  }

  // Helper method to build the input fields for each fitness level
  Widget _buildLevelInput(String level, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start
      children: [
        Text(
          level, // Label for the fitness level
          style: const TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
        const SizedBox(height: 4.0), // Space between label and input field
        TextFormField(
          controller: controller, // Associates the controller with the input field
          decoration: InputDecoration(
            hintText: 'Enter details for $level level', // Hint text for the input field
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!), // Border color when enabled
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal), // Border color when focused
            ),
          ),
        ),
      ],
    );
  }
}
