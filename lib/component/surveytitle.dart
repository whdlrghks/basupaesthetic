import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'button.dart';

Widget Subtitle(title, controller) {
  return
  Container(width: 500,

    child:
    Row(

        mainAxisAlignment: MainAxisAlignment.start,
    // width: present_width,
    children: [

      backKey(),
      Container(
        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
        decoration: BoxDecoration(
          color: survey_subtitle,
          borderRadius: BorderRadius.all(
            Radius.circular(24.0),
          ),
        ),
        height: 22,
        width: 88,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  ),);
}

Widget SubMultititle(title, controller, surveycontroller) {
  print(surveycontroller.questionsize.value);
  return Row(
    // width: present_width,
    children: [
      Obx(
        () => Container(
          width: figma_width > controller.present_width.value
              ? 64
              : (controller.present_width.value - figma_width) / 2 + 50,
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
          color: survey_subtitle,
          borderRadius: BorderRadius.all(
            Radius.circular(24.0),
          ),
        ),
        height: 22,
        // width: 88,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
                height: 1.0),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        width: 45,
        child: Center(
          child: Obx(
            () => Text(
              (surveycontroller.current_idx+1).toString() +
                  "/" +
                  surveycontroller.questionsize.value.toString(),
              style: TextStyle(
                  color: Color(0xff49a85e),
                  fontSize: 12,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                  height: 1.0),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget MultiQuestionTitle(title, controller) {
  return Row(mainAxisAlignment: MainAxisAlignment.center,
    // width: present_width,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 14),
          height: 120,
        width: 300,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
    ],
  );
}

Widget QuestionTitle(title, controller) {
  return Row(mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Container(
        height: 170,
        width: 400,
        padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
        child:Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w700,
            ),
          ),
      ),
    ],
  );
}

Widget QuestionDescrption(desc, controller) {
  return Row(
    // width: present_width,
    children: [
      Obx(
        () => Container(
          width: figma_width > controller.present_width.value
              ? 42
              : (controller.present_width.value - figma_width) / 2 + 10,
        ),
      ),
      Text(
        desc,
        style: TextStyle(
          color: Color(0xff7d7d7d),
          fontFamily: "Pretendard",
          fontSize: 16,
        ),
      ),
    ],
  );
}


Widget ResultTitle(title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          color: survey_subtitle,
          borderRadius: BorderRadius.all(
            Radius.circular(24.0),
          ),
        ),
        // height: 40,
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        // width: 120,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
                height: 1.0),
          ),
        ),
      ),
    ],
  );
}
