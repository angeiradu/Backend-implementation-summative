import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:be_fit_test/Login Signup/Widget/snackbar.dart';

// ForgotPassword widget for handling password reset functionality
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Controller to handle the email input
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance; // Firebase authentication instance

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            myDialogBox(context); // Show the dialog box when "Forgot Password?" is tapped
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }

  // Function to show a dialog box for entering the email to reset password
  void myDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners for the dialog
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the dialog
              borderRadius: BorderRadius.circular(20), // Rounded corners for the container
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize the size of the dialog to its content
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(), // Empty container to space out the title and close button
                    const Text(
                      "Forgot Your Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), // Outline border for the text field
                    labelText: "Your Email",
                    hintText: "eg abc@gmail.com",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () async {
                    // Send password reset email using FirebaseAuth
                    await auth
                        .sendPasswordResetEmail(email: emailController.text)
                        .then((value) {
                      // Show success message
                      showSnackBar(context,
                          "We have sent you the reset password link to your email id. Please check it.");
                    }).onError((error, stackTrace) {
                      // Show error message if there was an error
                      showSnackBar(context, error.toString());
                    });
                    Navigator.pop(context); // Close the dialog
                    emailController.clear(); // Clear the text field
                  },
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
