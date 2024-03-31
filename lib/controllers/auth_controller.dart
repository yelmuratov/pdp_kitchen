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

  Future<String> updateQrCode() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? id = prefs.getString("id");
      var response = await http.post(
      Uri.parse("$url/qr_code/"),
      headers: headers, body: jsonEncode({"user": id})); 
      return response.body;
    } catch (e) {
      throw Exception('while get update new qr $e');
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
    } catch (e) {
      throw Exception(e);
    }
  }
}
