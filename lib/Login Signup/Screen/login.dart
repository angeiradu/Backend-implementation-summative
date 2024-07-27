import 'package:flutter/material.dart'; // Importing necessary Flutter material package
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Importing Facebook authentication package
import '../../Login With Google/google_auth.dart'; // Importing Google authentication service
import '../../Password Forgot/forgot_password.dart'; // Importing forgot password screen
import '../../Screens/dashboard_screen.dart'; // Importing dashboard screen
import '../Services/authentication.dart'; // Importing custom authentication methods
import '../Widget/button.dart'; // Importing a custom button widget
import '../Widget/snackbar.dart'; // Importing a custom snackbar widget
import 'signup.dart'; // Importing signup screen

// Defining a stateful widget called LoginScreen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(); // Controller for email input
  final TextEditingController passwordController = TextEditingController(); // Controller for password input
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool isLoading = false; // Loading state indicator

  @override
  void dispose() {
    // Disposing of controllers when the widget is removed from the widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Method to handle user login
  void loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true; // Show loading indicator
      });
      // Attempt to log in the user with email and password
      String res = await AuthMethod().loginUser(
          email: emailController.text, password: passwordController.text);

      if (res == "success") {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
        // Navigate to dashboard screen if login is successful
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
        showSnackBar(context, res); // Show error message
      }
    }
  }

  // Method to handle login with Facebook
  Future<void> _loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    // Print detailed information about the login result
    print('Facebook login status: ${result.status}');
    print('Facebook login message: ${result.message}');
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance.getUserData();
      print('User Data: $userData');
      // Navigate to dashboard screen if login is successful
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    } else if (result.status == LoginStatus.failed) {
      showSnackBar(context, result.message ?? "Facebook login failed"); // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text('Back'),
          ],
        ),
        actions: [
          // Button to navigate to signup screen
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createAccount');
            },
            child: const Text('Sign Up', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text('Email'),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Password'),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password',
                      ),
                      obscureText: true, // Hide the password input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ForgotPassword(), // Forgot password widget
                  const SizedBox(height: 16),
                  MyButtons(onTap: loginUser, text: "Log In"), // Login button
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      ),
                      const Text("  or  "),
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Button to log in with Google
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () async {
                        await FirebaseServices().signInWithGoogle();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Button to log in with Facebook
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: _loginWithFacebook,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.facebook, color: Colors.white),
                          const SizedBox(width: 10),
                          const Text(
                            "Continue with Facebook",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Link to navigate to signup screen
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text("Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
