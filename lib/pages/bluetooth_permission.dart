import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/pages/light_color_pick.dart';

class BlueToothPermission extends StatelessWidget {
  const BlueToothPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FlutterBluetoothSerial.instance.requestEnable(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text("블루투스를 사용할 수 없습니다."),
            ),
          );
        } else {
          return LightColorPickPage(
            server: BluetoothDevice(address: ""),
          );
        }
      },
    );
  }
}
