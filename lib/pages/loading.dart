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
      child: (CircularProgressIndicator()),
    );
  }
}
