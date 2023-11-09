import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:smarthomeiot/controler/login_controller.dart';
import 'package:smarthomeiot/controler/registration_controler.dart';
import 'package:smarthomeiot/view/page/Login_screen.dart';
import 'package:smarthomeiot/view/page/homepage.dart';

import '../../model/list_of_homes_model.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  String? _preferdTemp;
  final controller = Get.put(RegistrationControler());
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Do something with the username and password
      print('Username: $_username, Password: $_password');

      await controller.registerNewUser(_username, _password, _preferdTemp);
      await Get.to(() => SignUpScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(251, 234, 230, 213),
      appBar: AppBar(
        title: const Text('Register User'),
        backgroundColor: Color.fromARGB(251, 234, 230, 213),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      //color: Colors.blueAccent,
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 39, 35, 35),
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton(
                    isExpanded: true,
                    value: controller.options.isNotEmpty
                        ? controller.options[0]
                        : null,
                    items: controller.options
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option['homeName']),
                          ),
                        )
                        .toList(),
                    onChanged: (newValue) {
                      controller.options.value = controller.options.toList();

                      controller.options.remove(newValue);
                      controller.options.insert(0, newValue);
                      // print("################" +
                      //     controller.options.value[0]['id'].toString());
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  } else if (!value!.isEmail) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Prefered Temp',
                  hintText: 'Enter your Pref Temp for your home',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your prefered temp';
                  }
                  return null;
                },
                onSaved: (value) {
                  _preferdTemp = value;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () async {
                    _submit();
                  },
                  child: const Text('Register User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
