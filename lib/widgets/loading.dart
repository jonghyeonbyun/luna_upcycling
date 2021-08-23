import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';
import 'package:luna_upcycling/widgets/fade_animation.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final height = size.height;

    return Center(
      child: Container(
        height: height * 0.08,
        child: LottieBuilder.asset(
          'assets/lotties/loading.json',
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}
