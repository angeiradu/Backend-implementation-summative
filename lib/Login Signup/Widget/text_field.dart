import 'package:flutter/material.dart';

// Custom widget for a styled text field input
class TextFieldInput extends StatelessWidget {
  // Controller to manage the text being edited
  final TextEditingController textEditingController;
  // Flag to indicate if the text field is for password input
  final bool isPass;
  // Placeholder text for the text field
  final String hintText;
  // Optional icon to display inside the text field
  final IconData? icon;
  // Keyboard type (e.g., text, email, number) for the text field
  final TextInputType textInputType;

  // Constructor to initialize required properties
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.icon,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adds padding around the text field
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        style: const TextStyle(fontSize: 20), // Sets the font size for the text field
        controller: textEditingController, // Binds the controller to the text field
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54), // Optional icon before the text input
          hintText: hintText, // Placeholder text
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 18), // Style for the hint text
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none, // No border when the text field is enabled
            borderRadius: BorderRadius.circular(30), // Rounds the corners of the text field
          ),
          border: InputBorder.none, // Removes the default border
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2), // Border when focused
            borderRadius: BorderRadius.circular(30), // Rounds the corners of the text field
          ),
          filled: true, // Fills the background color
          fillColor: const Color(0xFFedf0f8), // Background color of the text field
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ), // Padding inside the text field
        ),
        keyboardType: textInputType, // Sets the keyboard type
        obscureText: isPass, // Hides the text if it is a password field
      ),
    );
  }
}
