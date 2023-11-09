import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarthomeiot/view/page/Login_screen.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';

void main() => bugsnag.start(
      apiKey: 'c7e93a9426b0fa189792e5d78434ec5b',
      appVersion: '1.2.3-alpha',
      enabledReleaseStages: const {'production'},
      runApp: () => runApp(const MyApp()),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nahom\'s Smart Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.brown,
      ),
      home: SignUpScreen(),
    );
  }
}
