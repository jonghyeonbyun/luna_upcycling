import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/bindings/discovery_binding.dart';
import 'package:luna_upcycling/controllers/mood_light_controller.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';

import 'light_color_pick.dart';
import '../widgets/loading.dart';

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class MoodLightPage extends GetView<MoodLightController> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return WillPopScope(
      onWillPop: () async {
        print("will pop");
        return await controller.willpopstate(true);
      },
      child: Scaffold(
        body: Obx(()=> !controller.isConnecting.value ? Loading() : (controller.isColorPicker.value ? LightColorPickPage() : LightMain(height, width)))
      ),
    );
  }

  Column LightMain(height, width) {
    return Column(
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
              controller.bulbColor.value, BlendMode.modulate),
          child: GestureDetector(
            onDoubleTap: () {
              print("double taps");
              controller.sendMessage(controller.bulbState ? "off" : "on");
              controller.bulbState = !controller.bulbState;
              Fluttertoast.showToast(msg: controller.bulbState ? "on" : "off");
              controller.sendMessage("${controller.bulbState}");
              controller.sendMessage("color ${controller.bulbColor.value.red} ${controller.bulbColor.value.green} ${controller.bulbColor.value.blue} ");

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
          onTap: () {
            controller.isColorPicker(true);
           // print("클릭");
           // print(controller.isColorPicker);
    },
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
    );
  }
}
