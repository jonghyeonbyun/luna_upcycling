import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:luna_upcycling/bindings/discovery_binding.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/themes/color_palette.dart';

class MoodLightController extends GetxController {
  late AnimationController bulbController;
  BluetoothConnection? connection;
  String _messageBuffer = '';
  BluetoothDevice server = Get.arguments['server'];
  final isConnecting = true.obs;
  bool get isConnected => (connection?.isConnected ?? false);
  final isColorPicker = false.obs;
  bool isDisconnecting = false;
  bool bulbState = false;
  final backgroundColor = Colors.white.obs;
  final bulbColor = lunaBlue.obs;


  @override
  void onInit() {
    super.onInit();

    bulbState = false;

    BluetoothConnection.toAddress(server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;


        isConnecting.value = false;
        isDisconnecting = false;
        sendMessage(bulbColor.value.toString());

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
          Fluttertoast.showToast(msg: "연결을 끊었습니다.");
        } else {
          Fluttertoast.showToast(msg: "연결이 끊어졌습니다.");
          print('Disconnected remotely!');
        }
      });
    }).catchError((error) async {
      await Future.delayed(Duration(seconds: 1));
      Fluttertoast.showToast(msg: "연결 실패");
      Get.offAll(DiscoveryPage(), binding: DiscoveryBinding());
      print('Cannot connect, exception occured');
    });
  }
  @override
  void onClose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.onClose();
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
        _messageBuffer = dataString.substring(index);
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void sendMessage(String text) async {
    text = text.trim();
    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
      }
    }
  }
}
