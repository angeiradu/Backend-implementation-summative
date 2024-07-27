import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Step2Screen extends StatefulWidget {
  @override
  _Step2ScreenState createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final _beginnerController = TextEditingController();
  final _intermediateController = TextEditingController();
  final _advancedController = TextEditingController();

  @override
  void dispose() {
    _beginnerController.dispose();
    _intermediateController.dispose();
    _advancedController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final beginnerLevel = _beginnerController.text;
    final intermediateLevel = _intermediateController.text;
    final advancedLevel = _advancedController.text;

    if (beginnerLevel.isEmpty && intermediateLevel.isEmpty && advancedLevel.isEmpty) {
      // Handle empty form case
      return;
    }

    // Get the current user's UID
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Save to Firestore
    try {
      await FirebaseFirestore.instance.collection('fitness_levels').add({
        'beginner': beginnerLevel,
        'intermediate': intermediateLevel,
        'advanced': advancedLevel,
        'userId': userId, // Include the user ID
        'timestamp': FieldValue.serverTimestamp(), // Optional: add timestamp
      });

      // Navigate to the next step
      Navigator.pushNamed(context, '/step3');
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step 2 of 3',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: const Text(
              'Select your fitness level',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 35.0),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                const SizedBox(height: 80.0),
                _buildLevelInput('Beginner', _beginnerController),
                const SizedBox(height: 20.0),
                _buildLevelInput('Intermediate', _intermediateController),
                const SizedBox(height: 20.0),
                _buildLevelInput('Advanced', _advancedController),
                const SizedBox(height: 80.0),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF008080),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          Container(
            height: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircle(0),
                const SizedBox(width: 5.0),
                _buildCircle(1),
                const SizedBox(width: 5.0),
                _buildCircle(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(int index) {
    Color color = index == 1 ? Colors.teal : Colors.grey;
    return Container(
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildLevelInput(String level, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          level,
          style: const TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
        const SizedBox(height: 4.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter details for $level level',
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
        ),
      ],
    );
  }
}
