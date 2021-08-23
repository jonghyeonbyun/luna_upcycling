import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/bindings/mood_light_binding.dart';
import 'package:luna_upcycling/controllers/discovery_controller.dart';
import 'package:luna_upcycling/pages/mood_light.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:luna_upcycling/widgets/BluetoothDeviceListEntry.dart';

class DiscoveryPage extends GetView<DiscoveryController> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    Get.put(DiscoveryController());

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "루나 업사이클링",
                style: title2,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 32,
                child: LottieBuilder.asset(
                  'assets/lotties/bulbblue.json',
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.2,
                  ),
                  Container(
                    width: 2,
                    color: Color(0xFF0382F7),
                    height: 11,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "검색이 안되면 블루투스 아이콘을 눌러주세요.",
                    style: descrip,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.2,
                  ),
                  Container(
                    width: 2,
                    color: Color(0xFF0382F7),
                    height: 11,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("해당 기기를 선택하여 페어링합니다.", style: descrip)
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: "다시 검색중 ...");
              controller.restartDiscovery();
            },
            child: Container(
              height: height * 0.3,
              child: LottieBuilder.asset(
                'assets/lotties/bluetooth.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "사용가능 블루투스",
                style: subtitleRoboto,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Obx(()=>ListView.builder(
                itemCount: controller.results.length ,
                itemBuilder: (BuildContext context, index) {
                  BluetoothDiscoveryResult result = controller.results[index];
                  final device = result.device;
                  final address = device.address;
                  return BluetoothDeviceListEntry(
                    device: device,
                    rssi: result.rssi,
                    onTap: () {
                      Get.to(() => MoodLightPage(),
                          arguments: {'color': Color(0xffdee2e6), 'server':device },binding: MoodLightBinding());
                    },
                    onLongPress: () async {
                        bool bonded = false;
                        if (device.isBonded) {
                          print('Unbonding from ${device.address}...');
                          await FlutterBluetoothSerial.instance
                              .removeDeviceBondWithAddress(address);
                          print('Unbonding from ${device.address} has succed');
                        } else {
                          print('Bonding with ${device.address}...');
                          bonded = (await FlutterBluetoothSerial.instance
                              .bondDeviceAtAddress(address))!;
                          if (bonded) {
                            Get.to(() => MoodLightPage(),
                                arguments: {'color': Color(0xffdee2e6), 'server':device }, binding: MoodLightBinding());
                            Fluttertoast.showToast(
                                msg: "연결 성공!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "연결 실패 ㅠ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          print(
                              'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                        }
                        controller.results[controller.results.indexOf(result)] =
                            BluetoothDiscoveryResult(
                                device: BluetoothDevice(
                                  name: device.name ?? '',
                                  address: address,
                                  type: device.type,
                                  bondState: bonded
                                      ? BluetoothBondState.bonded
                                      : BluetoothBondState.none,
                                ),
                                rssi: result.rssi);
                    },
                  );
                }),)
          ))
        ]));
  }
}
