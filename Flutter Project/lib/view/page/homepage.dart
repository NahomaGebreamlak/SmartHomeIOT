import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarthomeiot/view/page/setting.dart';
import 'package:smarthomeiot/view/widgets/widgets.dart';

import '../../controler/home_page_controller.dart';
import '../../controler/login_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());
  final _loginController = Get.put(LoginController());

  int _selectedIndex = 0;
  bool _lightValue = false;
  bool _fanValue = false;

  List<Widget> _widgetOptions = <Widget>[Homewidget(), Setting()];

  void _onItemTapped(int index) {
    print("Index-----" + index.toString());
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      _loginController.logOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Nahoms Home'),
        actions: [
          IconButton(
              onPressed: () async {
                // await Future.delayed(Duration(seconds: 1));
                // setState(() {});
                await controller.fetchData();
              },
              icon: Icon(Icons.refresh_rounded))
        ],
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
          controller.dispose();
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/backgroundimage.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    backgroundBlendMode: BlendMode.darken,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: double.infinity,
                  height: Get.height / 1.5,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Living room \n",
                        style: TextStyle(
                            color: Color.fromARGB(255, 213, 242, 21),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Your living room is connected with 3 devices and 2 users have access to the living room.\n",
                        style: TextStyle(
                            color: Color.fromARGB(255, 213, 242, 21),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Obx(() => Text(
                            "${controller.temprature.value}\u{00B0}",
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          )),
                      Divider(
                        color: Colors.white,
                        thickness: 1.5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              displayWidgets(Icons.light, "Light", true, "",
                                  controller.light_status.value, controller),
                              displayWidgets(
                                  Icons.thermostat,
                                  "Temp",
                                  false,
                                  "${controller.temprature.value}\u{00B0}",
                                  true,
                                  controller),
                              displayWidgets(Icons.mode_fan_off, "Fan", true,
                                  "", controller.fan_status.value, controller),
                              displayWidgets(
                                  Icons.water_drop,
                                  "Himdity",
                                  false,
                                  "${controller.himudity.value} %",
                                  true,
                                  controller),
                            ],
                          ))
                    ],
                  )),
            )
          ],
        ),
      ),
      //

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Log Out',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget Homewidget() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/backgroundimage.jpeg"),
        fit: BoxFit.cover,
      ),
    ),
    //child: Column(children: [Text("Test")]),
  );
}
