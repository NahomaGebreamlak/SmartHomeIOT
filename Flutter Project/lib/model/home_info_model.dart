// To parse this JSON data, do
//
//     final homeInfoModel = homeInfoModelFromJson(jsonString);

import 'dart:convert';

HomeInfoModel homeInfoModelFromJson(String str) =>
    HomeInfoModel.fromJson(json.decode(str));

String homeInfoModelToJson(HomeInfoModel data) => json.encode(data.toJson());

class HomeInfoModel {
  HomeInfoModel({
    required this.temp,
    required this.humudity,
    required this.desiredTemp,
    required this.homeName,
    required this.doorStatus,
    required this.fanStatus,
    required this.lightStatus,
  });

  String humudity;
  String desiredTemp;
  String temp;
  int homeName;
  bool doorStatus;
  bool fanStatus;
  bool lightStatus;

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) => HomeInfoModel(
        humudity: json["humudity"],
        temp: json["temp"],
        desiredTemp: json["desiredTemp"],
        homeName: json["home_name"],
        doorStatus: json["door_status"],
        fanStatus: json["fan_status"],
        lightStatus: json["light_status"],
      );

  Map<String, dynamic> toJson() => {
        "humudity": humudity,
        "desiredTemp": desiredTemp,
        "home_name": homeName,
        "door_status": doorStatus,
        "fan_status": fanStatus,
        "light_status": lightStatus,
        "temp": temp
      };
}
