import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';
import 'package:luna_upcycling/widgets/fade_animation.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 60,
          ),
          FadeAnimation(
            5,
            GestureDetector(
              onTap: () => Get.to(DiscoveryPage()),
              child: Container(
                width: 200,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: lunaBlue, blurRadius: 10, spreadRadius: 0)
                    ]),
                child: Center(
                    child:
                        Text("다른 기기와 연결하기", style: otherConnectionButtonText)),
              ),
            ),
          )
        ],
      )),
    );
  }
}
