import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdp_kitchen/controllers/auth_controller.dart';
import 'package:pdp_kitchen/pages/login_page.dart';
import 'package:pdp_kitchen/pages/user_info.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  AuthController authController = AuthController();
  String qrData = "";
  Timer? _qrCodeTimer;
  Timer? _accessTokenTimer;

  @override
  void initState() {
    super.initState();
    _fetchQRCode();
    _startQrCodeTimer();
  }

  void _startQrCodeTimer() {
    _qrCodeTimer = Timer.periodic(const Duration(minutes: 4), (timer) {
      _fetchQRCode();
    });
  }

  Future<void> _fetchQRCode() async {
    try {
      String code = await authController.getQrCode();
      if (mounted) {
        setState(() {
          qrData = code;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          qrData = "Error fetching QR code";
        });
      }
    }
  }

  @override
  void dispose() {
    _qrCodeTimer?.cancel();
    _accessTokenTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfoPage()));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Student Page!',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue, // Custom color for AppBar
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: _handleLogout,
            ),
            SizedBox(width: 10), // Add spacing between icons
          ],
        ),
        backgroundColor: Colors.white, // Custom color for the background
        body: Container(
          color: Colors.lightBlue[50], // Custom color for the body background
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.purple],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                qrData.isNotEmpty
                    ? QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 400.0,
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'Your QR code!',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }
}
