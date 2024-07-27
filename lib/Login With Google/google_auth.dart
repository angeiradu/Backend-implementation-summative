import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Service class for handling Firebase and Google authentication
class FirebaseServices {
  final auth = FirebaseAuth.instance; // Instance of FirebaseAuth
  final googleSignIn = GoogleSignIn(); // Instance of GoogleSignIn

  // Method to sign in with Google
  // Don't forget to add the Firebase Auth and Google Sign-In packages in your dependencies
  signInWithGoogle() async {
    try {
      // Initiate the Google sign-in process
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Get authentication details from the signed-in Google account
        final GoogleSignInAuthentication googleSignInAuthentication = 
            await googleSignInAccount.authentication;

        // Create a new credential using the authentication details
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase using the Google credential
        await auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      print(e.toString());
    }
  }

  // Method to sign out from Google and Firebase
  googleSignOut() async {
    await googleSignIn.signOut(); // Sign out from Google
    auth.signOut(); // Sign out from Firebase
  }
}

// You can call these Firebase services in your "Continue with Google" button
