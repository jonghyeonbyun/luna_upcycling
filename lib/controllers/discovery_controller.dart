import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class DiscoveryController extends GetxController {
  late StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  final List<BluetoothDiscoveryResult> results =
  List<BluetoothDiscoveryResult>.empty(growable: true).obs;
  RxBool isDiscovering = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDiscovering.value = true;
    if (isDiscovering.value) {
      _startDiscovery();
    }
  }

  void restartDiscovery() {
      results.clear();
      isDiscovering.value = true;
      _streamSubscription.cancel();
    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
            var existingIndex = results.indexWhere(
                    (element) => element.device.address == r.device.address);
            if (existingIndex >= 0)
              results[existingIndex] = r;
            else
              results.add(r);

        });
    print(_streamSubscription);
    print(results.length);

    _streamSubscription.onDone(() {
        print("onDone");
        isDiscovering.value = false;

    });
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }
}
