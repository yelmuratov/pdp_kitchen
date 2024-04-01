import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdp_kitchen/controllers/auth_controller.dart';
import 'package:pdp_kitchen/pages/userpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthController authController = AuthController();
  Timer? _timer;
  bool isLoading = false; // Added isLoading state variable

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: authController.usernameController,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: authController.passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isLoading ? Colors.grey : Colors.green, // Corrected parameter
                      foregroundColor: Colors.white, // Corrected parameter
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              _Footer()
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
  setState(() {
    isLoading = true;
  });
  try {
    await authController.loginUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserPage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invalid username or password. Please try again.'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red, // Set the SnackBar's background color to red
      ),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  Widget _header(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Image.asset('assets/images/logo.png'),
        ),
        const Text(
          "PDP Kitchen",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Text("Enter your account"),
      ],
    );
  }
}

Widget _Footer() {
    return Container(
        child: Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: 'by Aral',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'Tech',
                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
  }

