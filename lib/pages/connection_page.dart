import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/bindings/mood_light_binding.dart';
import 'package:luna_upcycling/pages/discovery_page.dart';
import 'package:luna_upcycling/pages/mood_light.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

List dummyData = [
  'arduino 1',
  'arduino 2',
  'arduino 3',
  'arduino 4',
];

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage>
    with TickerProviderStateMixin {
  late AnimationController lottieCtl;
  @override
  void initState() {
    super.initState();
    lottieCtl = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "루나 업사이클링",
                style: title2,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 32,
                child: LottieBuilder.asset(
                  'assets/lotties/bulbblue.json',
                  fit: BoxFit.cover,
                ),
              )
            ],
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
                    "아두이노는 보통 HGD214i 로 시작합니다.",
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
                  Text("해당 기기를 선택하여 연결하고 연결합니다.", style: descrip)
                ],
              )
            ],
          ),
          Container(
            height: height * 0.3,
            child: LottieBuilder.asset(
              'assets/lotties/bluetooth.json',
              controller: lottieCtl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "사용가능 블루투스",
                style: subtitleRoboto,
              ),
            ),
          ),
          Expanded(child: DiscoveryPage())
        ]));
  }
}
