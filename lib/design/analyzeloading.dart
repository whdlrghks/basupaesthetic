import 'dart:async';

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
  late Timer _timer;
  int _minuteCounter = 0;

  @override
  void initState() {
    _minuteCounter = 0;
    // 이 예시 timer는 1분(60초) 간격으로 실행
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _minuteCounter++;
        // 원하시는 로직:
        //   0 -> detail_1
        //   1 -> detail_2
        //   2,3,4 -> detail_3 (3분간)
        //   5 -> detail_4
      });
      // 총 6분 후 timer.cancel(), 페이지 이동 등.
      if (_minuteCounter > 5) {
        _timer.cancel();
        // do something if needed
      }
    });
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  /// 분 카운터에 따라 tr키를 선택
  String getAnalyzingTextKey() {
    // 0분 ~1분
    if (_minuteCounter == 0) return "analyzing_skin_detail_1";
    // 1분 ~2분
    if (_minuteCounter == 1) return "analyzing_skin_detail_2";
    // 2~4분 (2,3,4)
    if (_minuteCounter >= 2 && _minuteCounter <= 4) {
      return "analyzing_skin_detail_3";
    }
    // 5분
    if (_minuteCounter == 5) return "analyzing_skin_detail_4";

    // 그 이후라면 그냥 마지막 문구 유지
    return "analyzing_skin_detail_4";
  }

  @override
  Widget build(BuildContext context) {

    final textKey = getAnalyzingTextKey();
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
                  textKey.tr,
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
    _timer.cancel();
    super.dispose();
  }
}
