import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Login Signup/Screen/signup.dart';
import 'Login Signup/Screen/login.dart';
import 'screens/step1_screen.dart';
import 'screens/step2_screen.dart';
import 'screens/step3_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/meal_plan_screen.dart';
import 'screens/check_process_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/support_screen.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Run your app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
      routes: {
        '/createAccount': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/step1': (context) => Step1Screen(),
        '/step2': (context) => Step2Screen(),
        '/step3': (context) => Step3Screen(),
        '/dashboard': (context) => DashboardScreen(),
        '/tips': (context) => TipsScreen(),
        '/workout': (context) => WorkoutScreen(),
        '/meal_plan': (context) => MealPlanScreen(),
        '/check_process': (context) => CheckProcessScreen(),
        '/settings': (context) => SettingsScreen(),
        '/support': (context) => SupportScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Newsreader',
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.asset(
                  'assets/GetStarted.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: 0,
                right: 0,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIFE HAS NO REMOTE.\nGET UP AND CHANGE IT YOURSELF.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Commit to be fit-',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/createAccount');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF008080),
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                      child: const Text('Get Started'),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already a member? ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  color: Color(0xFF008080),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
