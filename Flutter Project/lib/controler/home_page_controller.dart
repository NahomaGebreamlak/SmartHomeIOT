import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

import '../model/home_info_model.dart';

class HomeController extends GetxController {
  RxBool door_status = false.obs;
  RxBool fan_status = false.obs;
  RxBool light_status = false.obs;
  RxString temprature = "".obs;
  RxString himudity = "".obs;
  RxString homeName = "".obs;
  HomeInfoModel? homeinfo;
  String serverUrl = "http://192.168.252.32:8000/smarthome";
  @override
  void onInit() async {
    super.onInit();
    await fetchData();
  }

  fetchData() async {
    print("fetch data caled");
    String url = "$serverUrl/homeinfo/1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      ///data successfully

      var result = jsonDecode(response.body);

      homeinfo = HomeInfoModel.fromJson(result);
      temprature.value = homeinfo!.temp;
      himudity.value = homeinfo!.humudity;
      door_status.value = homeinfo!.doorStatus;
      fan_status.value = homeinfo!.fanStatus;
      light_status.value = homeinfo!.lightStatus;
      //Remeber to add home name here
    } else {
      Get.snackbar("Error", "Error loding home page please reload");
    }
  }

  switchFun() async {
    final url = Uri.parse('$serverUrl/updatefromApp/1');
    final headers = {"Content-type": "application/json"};
    var bodycontent = {
      "fan_status": fan_status.value,
      "light_status": light_status.value
    };
    print(bodycontent);

    final response =
        await http.put(url, headers: headers, body: jsonEncode(bodycontent));
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
  }

  switchLight() async {}
}
