import 'package:flutter/material.dart';

// Custom button widget
class MyButtons extends StatelessWidget {
  // Callback function to be executed on button tap
  final VoidCallback onTap;
  // Button text
  final String text;

  // Constructor to initialize required properties
  const MyButtons({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Executes the provided callback when the button is tapped
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Adds padding around the button
        child: Container(
          alignment: Alignment.center, // Centers the text within the button
          padding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding inside the button
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30), // Rounds the corners of the button
              ),
            ),
            color: Colors.teal, // Sets the background color of the button
          ),
          child: Text(
            text, // Displays the provided text on the button
            style: const TextStyle(
              fontSize: 20, // Sets the font size of the text
              color: Colors.white, // Sets the color of the text
              fontWeight: FontWeight.bold, // Makes the text bold
            ),
          ),
        ),
      ),
    );
  }
}
