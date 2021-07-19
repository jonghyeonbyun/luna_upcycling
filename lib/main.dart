import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:luna_upcycling/pages/mood_light.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  BluetoothDevice btd = BluetoothDevice(address: "test");
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LUNA UPCYCLING',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
