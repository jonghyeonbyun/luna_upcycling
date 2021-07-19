import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/pages/bluetooth_permission.dart';
import 'package:luna_upcycling/themes/font_themes.dart';
import 'package:luna_upcycling/widgets/fade_animation.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeAnimation(
                2.0,
                LottieBuilder.asset(
                  'assets/lotties/bulbblue.json',
                  fit: BoxFit.cover,
                  height: 70,
                ),
              ),
              Column(
                children: [
                  FadeAnimation(
                    2.2,
                    Text(
                      "루나 업사이클링",
                      style: title1,
                    ),
                  ),
                  FadeAnimation(
                      2.3,
                      Text(
                        ": 환경을 생각하는 아름다운 코딩",
                        style: subtitle,
                      ))
                ],
              ),
              SizedBox(
                width: 30,
              )
            ],
          ),
          Container(
            height: height * 0.4,
            child: LottieBuilder.asset(
              'assets/lotties/box.json',
              repeat: false,
              fit: BoxFit.cover,
            ),
          ),
          FadeAnimation(
            2.5,
            GestureDetector(
              onTap: () => Get.to(() => BlueToothPermission()),
              child: Container(
                width: width * 0.44,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFF0382F7)),
                child: Center(
                  child: Text(
                    "시작하기",
                    style: buttonText,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
