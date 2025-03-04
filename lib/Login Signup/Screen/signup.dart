import 'package:flutter/material.dart'; // Importing Flutter material package
import '../../Screens/step1_screen.dart'; // Importing Step1 screen
import '../Services/authentication.dart'; // Importing custom authentication service
import '../Widget/snackbar.dart'; // Importing custom snackbar widget

// Defining a stateful widget for the Signup screen
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final TextEditingController nameController = TextEditingController(); // Controller for name input
  final TextEditingController emailController = TextEditingController(); // Controller for email input
  final TextEditingController passwordController = TextEditingController(); // Controller for password input
  bool isLoading = false; // Indicator for loading state
  bool _termsAccepted = false; // Indicator if terms and conditions are accepted

  @override
  void dispose() {
    // Disposing of controllers when the widget is removed from the widget tree
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  // Method to handle user signup
  void signupUser() async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      print('Sending signup request...');

      // Attempt to sign up the user with provided details
      String res = await AuthMethod().signupUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text);

      print('Signup response received: $res');

      if (res == "success") {
        setState(() {
          isLoading = false; // Hide loading indicator
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful! Logging in...')),
        );

        // Delay for 5 seconds before navigating
        await Future.delayed(const Duration(seconds: 5));

        // Automatically log in the user and navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Step1Screen(), // Replace with your main screen
          ),
        );
      } else {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
        showSnackBar(context, res); // Show error message
      }
    } else if (!_termsAccepted) {
      showSnackBar(context, 'Please accept the terms and conditions'); // Show error if terms are not accepted
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
          // Button to navigate to login screen
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Login', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
                const Text('Full Name'),
                const SizedBox(height: 8),
                // Input field for full name
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Email'),
                const SizedBox(height: 8),
                // Input field for email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Password'),
                const SizedBox(height: 8),
                // Input field for password
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  obscureText: true, // Hide password input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Checkbox for accepting terms and conditions
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                      const Text('I accept the', style: TextStyle(fontSize: 16)),
                      const Text(
                        ' terms',
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                      const Text(' and ', style: TextStyle(fontSize: 16)),
                      const Text(
                        'conditions',
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Button to sign up the user
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  onPressed: isLoading ? null : signupUser,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                // Link to navigate to login screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an account?', style: TextStyle(color: Colors.black)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Login', style: TextStyle(color: Colors.teal)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
