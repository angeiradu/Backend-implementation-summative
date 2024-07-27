import 'package:flutter/material.dart'; // Importing necessary Flutter material package
import '../../Login With Google/google_auth.dart'; // Importing Google authentication service
import '../Widget/button.dart'; // Importing a custom button widget
import 'login.dart'; // Importing the login screen

// Defining a stateless widget called HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Building the UI for the HomeScreen
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying a congratulatory message
            const Text(
              "Congratulations\nYou have successfully logged in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            // Custom button to log out
            MyButtons(
                onTap: () async {
                  // Sign out from Google
                  await FirebaseServices().googleSignOut();
                  // Navigate back to the login screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                text: "Log Out"),
                
            // Uncomment the following lines to display user's Google account details:
            // Display user's profile picture
            // Image.network("${FirebaseAuth.instance.currentUser!.photoURL}"),
            // Display user's email
            // Text("${FirebaseAuth.instance.currentUser!.email}"),
            // Display user's name
            // Text("${FirebaseAuth.instance.currentUser!.displayName}")
          ],
        ),
      ),
    );
  }
}
