import 'dart:async'; // Import needed for Timer
import 'package:flutter/material.dart';
import 'package:pdp_kitchen/controllers/auth_controller.dart';
import 'package:pdp_kitchen/pages/login_page.dart';
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
  DateTime _lastActivityTime = DateTime.now();

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Student Page!'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (qrData.isNotEmpty)
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 350.0,
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Your QR code!',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }
}
