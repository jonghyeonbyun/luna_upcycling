import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/pages/connection_page.dart';
import 'package:luna_upcycling/themes/font_themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              LottieBuilder.asset(
                'assets/lotties/bulb.json',
                fit: BoxFit.cover,
                height: 70,
              ),
              Column(
                children: [
                  Text(
                    "루나 업사이클링",
                    style: title1,
                  ),
                  Text(
                    "환경을 생각하는 아름다운 코딩",
                    style: subtitle,
                  )
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
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => ConnectionPage()),
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
          )
        ],
      ),
    );
  }
}
