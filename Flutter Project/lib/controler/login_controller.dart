import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../view/page/Login_screen.dart';
import '../view/page/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController unameText_controler = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  RxString username = "".obs;
  RxString password = "".obs;
  String serverUrl = "http://192.168.252.32:8000/smarthome";

  @override
  void onInit() async {
    // Get called when controller is created
    super.onInit();

    var login = await getLoginStatus();
    if (login) {
      Get.to(() => HomeScreen());
    }
  }

  void logOut() async {
    await saveLoginStatus(false);
    Get.to(() => SignUpScreen());
  }

// Save login status
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // Retrieve login status
  Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn == false) {
      // If shared preferences is empty, assign it a default value of false
      isLoggedIn = false;
      await prefs.setBool('isLoggedIn', isLoggedIn);
    }
    return isLoggedIn;
  }

  void submit() async {
    if (unameText_controler.value.text.trim().isEmail &&
        password_controller.value.text.trim().length.isGreaterThan(5)) {
      final url = Uri.parse('$serverUrl/login/');
      final headers = {"Content-type": "application/json"};

      var bodycontent = {
        "username": unameText_controler.value.text.trim(),
        "password": password_controller.value.text.trim(),
      };
      print(bodycontent);

      final response =
          await http.post(url, headers: headers, body: jsonEncode(bodycontent));
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Logged in successfully ",
            backgroundColor: Colors.green, duration: Duration(seconds: 5));
        saveLoginStatus(true);
        Get.to(() => HomeScreen());
      } else {
        Get.snackbar("Error", "Invalid UserName or Password ",
            backgroundColor: Colors.redAccent);
      }
      print('Status code: ${response.statusCode}');

      print('Body: ${response.body}');
    } else {
      Get.snackbar("Error", "Please enter Valid User Name and Password",
          backgroundColor: Colors.redAccent);
    }
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }
}
