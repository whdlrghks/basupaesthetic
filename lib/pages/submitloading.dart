import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/textstyle.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:get/get_utils/get_utils.dart';


enum DotType { square, circle, diamond, icon }

class SubmitLoading extends StatefulWidget {
  @override
  _SubmitLoadingState createState() => _SubmitLoadingState();
}

class _SubmitLoadingState extends State<SubmitLoading>
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
              child: Text(
                'sending_skin_data'.tr,
                style: submitloading_title,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 10),
              child: Text(
                'data_use_disclaimer'.tr,
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
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
