import 'package:flutter/material.dart';
import 'package:pdp_kitchen/pages/login_page.dart';
import 'package:pdp_kitchen/pages/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              // User is logged in, direct them to the UserPage
              return UserPage(); // Ensure you have a UserPage widget
            } else {
              // User is not logged in, direct them to the LoginPage
              return const LoginPage();
            }
          } else {
            // While checking the login state, show a loading indicator
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
