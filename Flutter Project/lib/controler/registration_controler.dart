import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/list_of_homes_model.dart';
import 'package:http/http.dart' as http;

class RegistrationControler extends GetxController {
  String serverUrl = "http://192.168.252.32:8000/smarthome";

  var selectedHome = "";
  RxList<dynamic> options = RxList<dynamic>([]);

  @override
  void onInit() async {
    print("#############");
    fetchHomes();
    super.onInit();
  }

  fetchHomes() async {
    print("##################");
    try {
      var url = "$serverUrl/listhomes/";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        options.value = jsonData;
      }
    } catch (e) {
      print(e);
    }
  }

  registerNewUser(username, password, preferedtemp) async {
    final url = Uri.parse('$serverUrl/registoruser/');
    final headers = {"Content-type": "application/json"};

    var bodycontent = {
      "username": username,
      "password": password,
      "card_number": "to be issued",
      "active_status": false,
      "home_name": options.value[0]['id'],
      "approve_status": false
    };
    print(bodycontent);

    final response =
        await http.post(url, headers: headers, body: jsonEncode(bodycontent));
    if (response.statusCode == 200) {
      Get.snackbar("Success",
          "Your are registerd for this service your account will be active after admin approval",
          backgroundColor: Colors.green, duration: Duration(seconds: 10));
    }
    print('Status code: ${response.statusCode}');

    print('Body: ${response.body}');
  }
}
