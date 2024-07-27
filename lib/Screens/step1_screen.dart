// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

// A stateless widget representing the first step screen in a series of steps
class Step1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step 1 of 3', // Title indicating the current step
          style: TextStyle(color: Colors.teal), // Text color of the title
        ),
        centerTitle: true, // Center aligns the title horizontally
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to fill the width
        children: [
          Expanded(
            child: ListView(
              children: [
                Image.asset(
                  'assets/fitness.png', // Fitness image asset
                  fit: BoxFit.cover, // Scale the image to cover its box
                ),
                const SizedBox(height: 20.0), // Space between image and text
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to', // Introduction text
                        style: TextStyle(fontSize: 24.0, color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0), // Space between texts
                      const Text(
                        'Be Fit Application', // App name
                        style: TextStyle(fontSize: 20.0, color: Colors.grey),
                      ),
                      const SizedBox(height: 15.0), // Space between texts
                      const Text(
                        'Personalized workouts will help you gain strength, get in better shape, and embrace a healthy lifestyle',
                        textAlign: TextAlign.center, // Center aligns the text
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      const SizedBox(height: 40.0), // Space before the button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/step2'); // Navigate to the next step
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF008080), // Button background color
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white, // Button text color
                          ),
                        ),
                        child: const Text('Get Started'), // Button label
                      ),
                    ],
                  ),
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
    Color color = index == 0 ? Colors.teal : Colors.grey;
    return Container(
      width: 15.0, // Width of the circle
      height: 15.0, // Height of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Makes the container circular
        color: color, // Sets the circle color
      ),
    );
  }
}
