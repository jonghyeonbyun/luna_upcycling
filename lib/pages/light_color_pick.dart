import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as CustomColorPicker;
import 'package:get/get.dart';
import 'package:luna_upcycling/bindings/mood_light_binding.dart';
import 'package:luna_upcycling/pages/mood_light.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';

class LightColorPickPage extends StatefulWidget {
  const LightColorPickPage({Key? key}) : super(key: key);

  @override
  _LightColorPickPageState createState() => _LightColorPickPageState();
}

class _LightColorPickPageState extends State<LightColorPickPage> {
  Color choiceColor = lunaBlue;
  Color backgroundColor = Colors.white;

  void changeColor(Color color) => setState(() => choiceColor = backgroundColor = color);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
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
                elevation: 2,
                child: ColorPicker(
                  // Use the screenPickerColor as start color.
                  color: choiceColor,
                  // Update the screenPickerColor using the callback.
                  onColorChanged: (Color color) => changeColor(color),
                  width: 33,
                  height: 33,
                  borderRadius: 16,
                  heading: Text(
                    '색 지정하기',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subheading: Text(
                    '색 채도 조절',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
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
                        pickerColor: choiceColor,
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
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              child: Center(
                child: Text(
                  "사용자 지정 색상",
                  style: whiteButtonText,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.17,
          ),
          GestureDetector(
            onTap: () {
              Get.off(() => MoodLightPage(), binding: MoodLightBinding(), arguments: choiceColor);
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