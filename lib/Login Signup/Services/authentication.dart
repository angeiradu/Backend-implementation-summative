import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore for database operations
import 'package:firebase_auth/firebase_auth.dart'; // Importing FirebaseAuth for authentication

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance for database operations
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance for authentication operations

  // Method to sign up a new user
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred"; // Default response message
    try {
      // Check if any field is not empty
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        // Register user in Firebase Auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        // Add user data to Firestore database
        print(cred.user!.uid); // Print user UID for debugging
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });

        res = "success"; // Update response message on success
      }
    } catch (err) {
      return err.toString(); // Return error message if any exception occurs
    }
    return res; // Return response message
  }

  // Method to log in an existing user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred"; // Default response message
    try {
      // Check if email and password are not empty
      if (email.isNotEmpty || password.isNotEmpty) {
        // Log in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success"; // Update response message on success
      } else {
        res = "Please enter all the fields"; // Prompt to fill all fields
      }
    } catch (err) {
      return err.toString(); // Return error message if any exception occurs
    }
    return res; // Return response message
  }

  // Method to sign out the current user
  Future<void> signOut() async {
    // Sign out the current user from FirebaseAuth
    await _auth.signOut();
  }
}
