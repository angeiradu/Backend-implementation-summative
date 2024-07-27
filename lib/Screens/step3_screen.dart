import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Step3Screen extends StatefulWidget {
  @override
  _Step3ScreenState createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  String selectedGender = 'Male'; // Default selected gender
  final _birthDayController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _birthDayController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final birthDay = _birthDayController.text;
    final height = _heightController.text;
    final weight = _weightController.text;

    if (birthDay.isEmpty || height.isEmpty || weight.isEmpty) {
      // Handle empty form case
      return;
    }

    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where user is not logged in
      return;
    }

    final userName = user.displayName ?? 'Unknown'; // Default to 'Unknown' if name is not set
    final userId = user.uid; // Get the user ID

    // Save to Firestore
    try {
      await FirebaseFirestore.instance.collection('personal_details').add({
        'user_name': userName,
        'userId': userId, // Include the user ID
        'birth_day': birthDay,
        'height': height,
        'weight': weight,
        'gender': selectedGender,
        'timestamp': FieldValue.serverTimestamp(), // Optional: add timestamp
      });

      // Navigate to the dashboard
      Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _birthDayController.text = '${pickedDate.toLocal()}'.split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step 3 of 3',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: const Text(
              'Personal Details',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                const SizedBox(height: 80.0),
                _buildLevelInput('Birth Day', _birthDayController, true), // Pass true to show date picker
                const SizedBox(height: 20.0),
                _buildLevelInput('Height', _heightController, false),
                const SizedBox(height: 20.0),
                _buildLevelInput('Weight', _weightController, false),
                const SizedBox(height: 10.0),
                Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedGender = 'Male';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Male' ? Colors.teal : Colors.white,
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Male' ? Colors.white : Colors.teal,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(color: Colors.teal),
                                ),
                              ),
                            ),
                            child: const Text('Male'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedGender = 'Female';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Female' ? Colors.teal : Colors.white,
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                selectedGender == 'Female' ? Colors.white : Colors.teal,
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(color: Colors.teal),
                                ),
                              ),
                            ),
                            child: const Text('Female'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100.0),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF008080),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  child: const Text('Finish'),
                ),
              ],
            ),
          ),
          Container(
            height: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircle(0),
                const SizedBox(width: 5.0),
                _buildCircle(1),
                const SizedBox(width: 5.0),
                _buildCircle(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(int index) {
    Color color = index == 2 ? Colors.teal : Colors.grey;
    return Container(
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildLevelInput(String hintText, TextEditingController controller, bool isDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          readOnly: isDate, // Make field read-only if it's a date picker
          onTap: isDate ? () => _selectDate(context) : null, // Show date picker when tapped
          decoration: InputDecoration(
            hintText: hintText,
            labelText: hintText,
            labelStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!, width: 0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
        ),
        if (hintText == 'Weight') const SizedBox(height: 20.0),
      ],
    );
  }
}
