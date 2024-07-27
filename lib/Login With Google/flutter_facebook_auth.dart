import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  static Future<Map<String, dynamic>?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance.getUserData();
      return userData;
    } else if (result.status == LoginStatus.cancelled) {
      print('Facebook login cancelled');
    } else if (result.status == LoginStatus.failed) {
      print('Facebook login failed: ${result.message}');
    }
    return null;
  }

  static Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
  }
}
