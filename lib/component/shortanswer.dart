import 'package:basup_ver2/data/surveyitem.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget ShortFormAnswer(hinttext, controller, surveycontroller, textcontroller) {
  SurveyItem currentItem =
      surveycontroller.getSurveyItemList()[surveycontroller.current_idx];
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 350,
        height: 157,
        child: Column(children: [
          Expanded(
            child: SizedBox(
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 6,
                //Normal textInputField will be displayed
                maxLines: 10,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 19, 20, 19),
                  isDense: true,
                  alignLabelWithHint: true,
                  enabledBorder: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: Colors.black38, width: 1.0),
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38, width: 1.0),
                  ),
                  focusColor: Colors.black38,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(
                    color: Color(0xff979797),
                    fontSize: 14,
                    height: 1,
                  ),
                  labelText: hinttext,
                ),
                controller: textcontroller,
                onChanged: (text) {
                  // text 등록
                  currentItem.setUserAnswer(text);
                  if (text != "") {
                    surveycontroller.shortform.value = true;
                  } else {
                    surveycontroller.shortform.value = false;
                  }
                },
                style: TextStyle(
                  fontFamily: "Pretendard",
                ),
              ),
            ),
          ),
        ]),
      ),
    ],
  );
}
