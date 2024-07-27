import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// The Step3Screen widget, representing the third step in a series
class Step3Screen extends StatefulWidget {
  @override
  _Step3ScreenState createState() => _Step3ScreenState();
}

// The state class for Step3Screen, managing the state and logic
class _Step3ScreenState extends State<Step3Screen> {
  String selectedGender = 'Male'; // Default selected gender
  final _birthDayController = TextEditingController(); // Controller for the birth date input
  final _heightController = TextEditingController(); // Controller for the height input
  final _weightController = TextEditingController(); // Controller for the weight input

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed to free up resources
    _birthDayController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Method to handle the submission of personal details
  Future<void> _submitData() async {
    final birthDay = _birthDayController.text; // Get birth date input
    final height = _heightController.text; // Get height input
    final weight = _weightController.text; // Get weight input

    if (birthDay.isEmpty || height.isEmpty || weight.isEmpty) {
      // Handle the case where any field is empty
      return;
    }

    // Get the current authenticated user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      return;
    }

    final userName = user.displayName ?? 'Unknown'; // Use the user's display name or 'Unknown'
    final userId = user.uid; // Get the user's unique ID

    // Save the data to Firestore
    try {
      await FirebaseFirestore.instance.collection('personal_details').add({
        'user_name': userName,
        'userId': userId, // Include the user ID
        'birth_day': birthDay,
        'height': height,
        'weight': weight,
        'gender': selectedGender, // Include the selected gender
        'timestamp': FieldValue.serverTimestamp(), // Optional: add a timestamp
      });

      // Navigate to the dashboard or next screen
      Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      // Handle any errors that occur during the data submission
      print('Error: $e');
    }
  }

  // Method to show the date picker for selecting a birth date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the current date as initial date
      firstDate: DateTime(1900), // Set the earliest date selectable
      lastDate: DateTime(2100), // Set the latest date selectable
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _birthDayController.text = '${pickedDate.toLocal()}'.split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step 3 of 3', // Title indicating the current step
          style: TextStyle(color: Colors.teal), // Set the title color
        ),
        centerTitle: true, // Center align the title
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to fill the width
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: const Text(
              'Personal Details', // Section header
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                const SizedBox(height: 80.0), // Space before input fields
                _buildLevelInput('Birth Day', _birthDayController, true), // Birth date input
                const SizedBox(height: 20.0), // Space between input fields
                _buildLevelInput('Height', _heightController, false), // Height input
                const SizedBox(height: 20.0), // Space between input fields
                _buildLevelInput('Weight', _weightController, false), // Weight input
                const SizedBox(height: 10.0), // Space before gender selection
                Container(
                  height: 40.0, // Set the height of the container
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
                    children: [
                      const Text(
                        'Gender', // Label for the gender selection
                        style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedGender = 'Male'; // Set selected gender to 'Male'
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Male' ? Colors.teal : Colors.white, // Color based on selection
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Male' ? Colors.white : Colors.teal, // Text color based on selection
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0), // Rounded button corners
                                  side: BorderSide(color: Colors.teal), // Border color
                                ),
                              ),
                            ),
                            child: const Text('Male'), // Button text
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedGender = 'Female'; // Set selected gender to 'Female'
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Female' ? Colors.teal : Colors.white, // Color based on selection
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Female' ? Colors.white : Colors.teal, // Text color based on selection
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0), // Rounded button corners
                                  side: BorderSide(color: Colors.teal), // Border color
                                ),
                              ),
                            ),
                            child: const Text('Female'), // Button text
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100.0), // Space before the submit button
                ElevatedButton(
                  onPressed: _submitData, // Call _submitData on button press
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF008080), // Button background color
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // Button text color
                    ),
                  ),
                  child: const Text('Finish'), // Button label
                ),
              ],
            ),
          ),
          Container(
            height: 20.0, // Height of the progress indicator section
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center align the row
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
    Color color = index == 2 ? Colors.teal : Colors.grey; // Set color based on the current step
    return Container(
      width: 15.0, // Set the width of the circle
      height: 15.0, // Set the height of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Make the container circular
        color: color, // Set the circle color
      ),
    );
  }

  // Helper method to build input fields for different personal details
  Widget _buildLevelInput(String hintText, TextEditingController controller, bool isDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
      children: [
        TextFormField(
          controller: controller,
          readOnly: isDate, // Make the field read-only if it's a date picker
          onTap: isDate ? () => _selectDate(context) : null, // Show date picker if it's a date field
          decoration: InputDecoration(
            hintText: hintText, // Hint text for the field
            labelText: hintText, // Label for the field
            labelStyle: const TextStyle(color: Colors.grey), // Style for the label
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding inside the field
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!, width: 0), // Border color for enabled state
              borderRadius: BorderRadius.circular(4.0), // Rounded corners for the border
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal), // Border color when focused
            ),
          ),
        ),
        if (hintText == 'Weight') const SizedBox(height: 20.0), // Add space below the weight input field
      ],
    );
  }
}
