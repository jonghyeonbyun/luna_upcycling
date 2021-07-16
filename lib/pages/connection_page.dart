import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luna_upcycling/bindings/mood_light_binding.dart';
import 'package:luna_upcycling/pages/mood_light.dart';
import 'package:luna_upcycling/themes/color_palette.dart';
import 'package:luna_upcycling/themes/font_themes.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  @override
  void initState() {
    super.initState();
    // 블루투스 연결 시작
  }

  List dummyData = [
    'arduino 1',
    'arduino 2',
    'arduino 3',
    'arduino 4',
  ];

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
          Expanded(
            child: dummyData.length == 0
                ? waitBT(width, height)
                : ListView.builder(
                    itemCount: dummyData.length,
                    itemBuilder: (context, index) => availableBT(index),
                  ),
          ),
        ],
      ),
    );
  }

  Widget availableBT(int index) {
    return GestureDetector(
      onTap: () {
        //연결 성공하면
        Get.to(() => MoodLightPage(), binding: MoodLightBinding());
      }, // 해당 기기 블루투스 연결
      child: Container(
        margin: EdgeInsets.only(
          right: 60,
          left: 60,
          bottom: 20,
        ),
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: lunaGrey),
        child: Center(child: Text(dummyData[index])),
      ),
    );
  }

  Widget waitBT(double width, double height) {
    return Expanded(
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) => Container(
          width: width * 0.6,
          height: 31,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xffCED4DA)),
        ),
      ),
    );
  }
}
