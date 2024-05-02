import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/textstyle.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';


enum DotType { square, circle, diamond, icon }

class AnalyzeLoading extends StatefulWidget {
  @override
  _AnalyzeLoadingState createState() => _AnalyzeLoadingState();
}

class _AnalyzeLoadingState extends State<AnalyzeLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 여기서 false를 반환하면 뒤로 가기 버튼의 기본 동작이 차단됩니다.
        // 필요한 로직을 구현하거나 단순히 false를 반환할 수 있습니다.
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                child: Text(
                  'analyzing_skin'.tr,
                  style: submitloading_title,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 10),
                child: Text(
                  'analyzing_skin_detail'.tr,
                  style: submitloading_content,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
                child: CircularProgressIndicator(
                  strokeWidth: 10.0,
                  value: controller.value,
                  semanticsLabel: 'Circular progress indicator',
                  color: main_Button_Color,
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
