import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/pages/mood_light.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:luna_upcycling/widgets/BluetoothDeviceListEntry.dart';

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;

  DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage>
    with TickerProviderStateMixin {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;
  _DiscoveryPage();

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          results[existingIndex] = r;
        else
          results.add(r);
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        print("onDone");
        isDiscovering = false;
        Get.snackbar("검색 중지", "다시 검색하려면 블루투스 아이콘을 누르세요",
            colorText: Colors.white,
            backgroundColor: lunaBlue,
            margin: EdgeInsets.all(16),
            snackPosition: SnackPosition.BOTTOM);
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    color: Color(0xFF0382F7),
                    height: 11,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "아두이노는 보통 HGD214i 로 시작합니다.",
                    style: descrip,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    color: Color(0xFF0382F7),
                    height: 11,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("해당 기기를 선택하여 연결하고 연결합니다.", style: descrip)
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              if (!isDiscovering) {
                Fluttertoast.showToast(msg: "다시 검색중 ...");
                _restartDiscovery();
              }
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
            child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (BuildContext context, index) {
                  BluetoothDiscoveryResult result = results[index];
                  final device = result.device;
                  final address = device.address;
                  return BluetoothDeviceListEntry(
                    device: device,
                    rssi: result.rssi,
                    onTap: () {
                      Get.to(() => MoodLightPage(server: result.device));
                    },
                    onLongPress: () async {
                      try {
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
                            Get.to(() => MoodLightPage(server: device),
                                arguments: Color(0xfff));
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
                        setState(() {
                          results[results.indexOf(result)] =
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
                        });
                      } catch (ex) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error occured while bonding'),
                              content: Text("${ex.toString()}"),
                              actions: <Widget>[
                                new TextButton(
                                  child: new Text("닫기"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                }),
          ))
        ]));
  }
}
