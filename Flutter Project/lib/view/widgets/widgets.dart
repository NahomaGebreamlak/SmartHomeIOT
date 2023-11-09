import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarthomeiot/controler/home_page_controller.dart';
import 'package:smarthomeiot/controler/login_controller.dart';

Widget textField(TextEditingController controler, String label, String hint,
    String errorMessage, bool isemail, bool isObsecure) {
  return TextFormField(
    controller: controler,
    obscureText: isObsecure,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      labelText: label,
      hintText: hint,
      //errorText: controler.text.isEmpty ? errorMessage : ""
    ),
    validator: (value) {
      if (isemail) {
        if (!GetUtils.isEmail(value!)) {
          return errorMessage;
        } else {
          return null;
        }
      } else {
        if (!GetUtils.isLengthGreaterThan(value!, 5)) {
          return errorMessage;
        } else {
          return null;
        }
      }
    },
  );
}

Widget displayWidgets(IconData icon, String label, bool isbutton, String value,
    bool switchvalue, HomeController controller) {
  return Container(
      width: 80,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            size: 40,
          ),
          Text(label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          isbutton
              ? Switch(
                  value: switchvalue,
                  activeTrackColor: Colors.green,
                  onChanged: (bool value) async {
                    if (label == "Fan") {
                      controller.fan_status.value = value;
                      controller.switchFun();
                    } else {
                      controller.light_status.value = value;
                      await controller.switchFun();
                    }
                    switchvalue = value;
                  })
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
        ],
      ));
}
