import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Service class for handling Facebook authentication
class FacebookAuthService {

  // Method to sign in with Facebook and retrieve user data
  static Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      // Trigger the Facebook login process
      final LoginResult result = await FacebookAuth.instance.login();

      // Check the result status of the login attempt
      if (result.status == LoginStatus.success) {
        // If login is successful, get the access token and user data
        final AccessToken? accessToken = result.accessToken;
        if (accessToken != null) {
          final userData = await FacebookAuth.instance.getUserData();
          return userData; // Return user data as a map
        } else {
          print('Access token is null');
        }
      } else if (result.status == LoginStatus.cancelled) {
        // If login is cancelled, print a message
        print('Facebook login cancelled');
      } else if (result.status == LoginStatus.failed) {
        // If login failed, print the error message
        print('Facebook login failed: ${result.message}');
      }
    } catch (error) {
      // Catch any unexpected errors
      print('An error occurred during Facebook login: $error');
    }
    return null; // Return null if login was not successful
  }

  // Method to log out from Facebook
  static Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut(); // Perform the logout operation
      print('Logged out from Facebook');
    } catch (error) {
      // Catch any errors that occur during logout
      print('An error occurred during Facebook logout: $error');
    }
  }
}
