import 'package:flutter/material.dart';

// Function to show a snackbar with a message
void showSnackBar(BuildContext context, String text) {
  // Show the snackbar using the ScaffoldMessenger
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text), // The message to be displayed
    ),
  );
}
