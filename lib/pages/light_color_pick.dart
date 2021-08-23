import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'
    as CustomColorPicker;
import 'package:get/get.dart';
import 'package:luna_upcycling/bindings/mood_light_binding.dart';
import 'package:luna_upcycling/controllers/mood_light_controller.dart';
import 'package:luna_upcycling/pages/mood_light.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';


class LightColorPickPage extends GetView<MoodLightController> {

  void changeColor(Color color) =>
       controller.bulbColor.value = controller.backgroundColor.value = color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: controller.backgroundColor.value,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Card(
                shadowColor: Colors.black38,
                elevation: 5,
                child: ColorPicker(
                  pickerTypeLabels: {
                    ColorPickerType.primary: "기본",
                    ColorPickerType.accent: "강조",
                  },
                  pickerTypeTextStyle: liteSHtext,
                  // Use the screenPickerColor as start color.
                  color: controller.bulbColor.value,
                  // Update the screenPickerColor using the callback.
                  onColorChanged: (Color color) => changeColor(color),
                  width: 33,
                  height: 33,
                  borderRadius: 16,
                  heading: Text(
                    '색 지정하기',
                    style: title1,
                  ),
                  subheading: Text(
                    '색 채도 조절',
                    style: subtitle,
                  ),
                  columnSpacing: 15,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: CustomColorPicker.ColorPicker(
                        pickerColor: controller.bulbColor.value,
                        onColorChanged: changeColor,
                        colorPickerWidth: 300.0,
                        pickerAreaHeightPercent: 0.7,
                        enableAlpha: false,
                        displayThumbColor: true,
                        showLabel: true,
                        paletteType: CustomColorPicker.PaletteType.hsv,
                        pickerAreaBorderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(2.0),
                          topRight: const Radius.circular(2.0),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              width: width * 0.44,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      color: lunaBlack.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 10,
                    )
                  ]),
              child: Center(
                child: Text(
                  "사용자 지정 색상",
                  style: whiteButtonText,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.1,
          ),
          GestureDetector(
            onTap: () {
              controller.isColorPicker.value = false;
              controller.sendMessage(controller.bulbColor.value.toString());
            },
            child: Container(
              width: width * 0.44,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF0382F7)),
              child: Center(
                child: Text(
                  "색 선택완료",
                  style: buttonText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
