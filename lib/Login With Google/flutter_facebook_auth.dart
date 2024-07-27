import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Service class for handling Facebook authentication
class FacebookAuthService {
  
  // Method to sign in with Facebook and retrieve user data
  static Future<Map<String, dynamic>?> signInWithFacebook() async {
    // Trigger the Facebook login process
    final LoginResult result = await FacebookAuth.instance.login();

    // Check the result status of the login attempt
    if (result.status == LoginStatus.success) {
      // If login is successful, get the access token and user data
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance.getUserData();
      return userData; // Return user data as a map
    } else if (result.status == LoginStatus.cancelled) {
      // If login is cancelled, print a message
      print('Facebook login cancelled');
    } else if (result.status == LoginStatus.failed) {
      // If login failed, print the error message
      print('Facebook login failed: ${result.message}');
    }
    return null; // Return null if login was not successful
  }

  // Method to log out from Facebook
  static Future<void> signOut() async {
    await FacebookAuth.instance.logOut(); // Perform the logout operation
  }
}
