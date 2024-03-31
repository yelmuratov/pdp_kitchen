import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late SharedPreferences _prefs;
  String _userId = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _startTimer(); // Start the timer after initial setup
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    String? userId = _prefs.getString('id');
    if (userId != null && userId.isNotEmpty) {
      setState(() {
        _userId = userId;
      });
    }
  }

  void _startTimer() {
    // Fetch and update the user ID every 5 minutes
    _timer = Timer.periodic(
        const Duration(minutes: 5), (Timer t) => _updateUserId());
  }

  Future<void> _updateUserId() async {
    try {
      String newUserId = await updateUserIdFromServer();
      await _prefs.setString('id', newUserId); // Update the stored user ID with the new one
      setState(() {
        _userId = newUserId; // Update the user ID used for the QR code
      });
    } catch (e) {
      throw Exception("Error updating user ID: $e");
    }
  }

  Future<String> updateUserIdFromServer() async {
    // Simulate fetching a new user ID from the server
    // This should be replaced with your actual HTTP request logic
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return "new_user_id_${DateTime.now().millisecondsSinceEpoch}"; // Simulate a new user ID
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Page'),
      ),
      body: Center(
        child: _userId.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your QR Code', style: TextStyle(fontSize: 30)),
                  const SizedBox(height: 20),
                  QrImageView(
                    data: _userId,
                    version: QrVersions.auto,
                    size: 400.0,
                  ),
                ],
              )
            : const Text('Loading QR Code...', style: TextStyle(fontSize: 20)),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Important to cancel the timer to avoid memory leaks
    super.dispose();
  }
}
