// To parse this JSON data, do
//
//     final listOfHomesModel = listOfHomesModelFromJson(jsonString);

import 'dart:convert';

List<ListOfHomesModel> listOfHomesModelFromJson(String str) =>
    List<ListOfHomesModel>.from(
        json.decode(str).map((x) => ListOfHomesModel.fromJson(x)));

String listOfHomesModelToJson(List<ListOfHomesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfHomesModel {
  ListOfHomesModel({
    this.id,
    this.homeName,
  });

  int? id;
  String? homeName;

  factory ListOfHomesModel.fromJson(Map<String, dynamic> json) =>
      ListOfHomesModel(
        id: json["id"],
        homeName: json["homeName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "homeName": homeName,
      };
}
