import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';

import 'light_color_pick.dart';
import 'loading.dart';

class MoodLightPage extends StatefulWidget {
  final BluetoothDevice server;

  const MoodLightPage({required this.server});

  @override
  _MoodLightPage createState() => new _MoodLightPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _MoodLightPage extends State<MoodLightPage> {
  BluetoothConnection? connection;
  String _messageBuffer = '';

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  bool bulbState = false;
  Color? bulbColor;

  @override
  void initState() {
    super.initState();
    bulbState = false;
    bulbColor = Get.arguments;
    print(bulbColor.toString());

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;

      setState(() {
        isConnecting = false;
        isDisconnecting = false;
        _sendMessage(bulbColor.toString());
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
          Fluttertoast.showToast(msg: "연결을 끊었습니다.");
        } else {
          Fluttertoast.showToast(msg: "연결이 끊어졌습니다.");
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      Get.snackbar("오류", error.message,
          colorText: Colors.white,
          backgroundColor: lunaBlue,
          margin: EdgeInsets.all(16),
          snackPosition: SnackPosition.BOTTOM);
      print('Cannot connect, exception occured');
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return (Scaffold(
        body: !isConnecting
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chapter 1. 무드등",
                    style: title2,
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
                            "이중 탭을 하여 무드등을 끄고 킬 수 있습니다.",
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
                          Text(
                            "다양한 색상을 선택하여 적용할 수 있습니다.",
                            style: descrip,
                          )
                        ],
                      )
                    ],
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        bulbColor ?? Color(0xffdee2e6), BlendMode.modulate),
                    child: GestureDetector(
                      onDoubleTap: () {
                        print("double taps");
                        _sendMessage(bulbState ? "off" : "on");
                        bulbState = !bulbState;
                        Fluttertoast.showToast(msg: bulbState ? "on" : "off");
                      },
                      child: Container(
                        height: height * 0.13,
                        margin: EdgeInsets.all(100),
                        child: LottieBuilder.asset(
                          'assets/lotties/bulb.json',
                          height: height * 0.13,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.off(
                        () => LightColorPickPage(
                              server: widget.server,
                            ),
                        arguments: widget.server),
                    child: Container(
                      width: width * 0.44,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFF0382F7)),
                      child: Center(
                        child: Text(
                          "색 고르기",
                          style: buttonText,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Loading()));
  }
}
