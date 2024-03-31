import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? access_token;
  final url = 'https://pdp.diyarbek.ru';
  var headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<String> getQrCode() async {
  final prefs = await SharedPreferences.getInstance();
  try {
    String? id = prefs.getString("id");
    var response = await http.post(
      Uri.parse("$url/qr_code/"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRFToken": "Reb04mZGrBoVEF92aEJhNBKQsFxdKGCPXrYMmmd1U7qZwSx08VvSmpAVoDc7fFZd" // Replace with your actual CSRF token
      },
      body: jsonEncode({"user": id}),
    );

    if (response.statusCode == 201) {
      var decodedResponse = jsonDecode(response.body);
      
      // Make sure the key 'code' matches the key in your actual response
      String qrCode = decodedResponse['code'];
      return qrCode;
    } else {
      // Consider logging response body for better debugging
      print('Server response: ${response.body}');
      throw Exception('Failed to load QR Code: Server responded with status code ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error while getting QR code: $e');
  }
}

  Future<void> updateAccessToken()async{
    final prefs = await SharedPreferences.getInstance();
    try {
      String ? token =  prefs.getString("accessToken");
      String ? refreshToken =  prefs.getString("refresh_token");

      var response = await http.post(
        Uri.parse('$url/users/refresh/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            "refresh_token":refreshToken
          }
        )
      );

      var result = jsonDecode(response.body);
      prefs.setString("accessToken", result["access_token"]);
      prefs.setBool("isLoggedin", true);
    } catch (e) {
      throw Exception("While get new accestoke$e");
    }
  }

  Future<void> loginUser() async {
    var response = await http.post(
      Uri.parse("$url/users/login/"),
      headers: headers,
      body: jsonEncode({
        "username": usernameController.text,
        "password": passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      access_token = res['access_token'];
      // Save the access token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', access_token!);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString("id", res["user_id"]);
      await prefs.setString("refresh_token", res['refresh_token']);
    } else {
      throw Exception("Error");
    }
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
        prefs.remove("accessToken");
        prefs.setBool("isLoggedIn", false);
    } catch (e) {
      throw Exception(e);
    }
  }
}
