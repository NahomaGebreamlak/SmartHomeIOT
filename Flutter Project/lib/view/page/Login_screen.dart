import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarthomeiot/view/page/homepage.dart';
import 'package:smarthomeiot/view/page/registration_screen.dart';

import '../../controler/login_controller.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  final _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //title: const Text('Nahom\'s Smart Home'),
          backgroundColor: Colors.brown,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
              child: Text(
                "       Hey! \n Welcome Back",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(251, 234, 230, 213),
                  borderRadius: BorderRadius.circular(30)),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.c,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.home,
                            size: 80,
                          ),
                        ),
                        textField(
                            _loginController.unameText_controler,
                            "User Name",
                            "Enter your username",
                            "invalid email",
                            true,
                            false),
                        const SizedBox(
                          height: 10,
                        ),
                        textField(
                            _loginController.password_controller,
                            "Password",
                            "Enter your password",
                            "length must be > 5",
                            false,
                            true),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ElevatedButton(
                            onPressed: _loginController.submit,
                            child: Text('Log in'),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(" You don't have accout?"),
                            TextButton(
                                onPressed: () async {
                                  try {
                                    throw Exception('handled exception');
                                  } catch (e, stack) {
                                    await bugsnag.notify(e, stack);
                                  }

                                  Get.to(() => const RegisterUser());
                                },
                                child: const Text("Register here"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ))
          ],
        ));
  }
}
