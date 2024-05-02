import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/container.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/pages/surveyshortform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserInfoState();
  }
}

class _UserInfoState extends State<UserInfo> {
  var controller = Get.find<SizeController>(tag: "size");
  var resultcontroller = Get.find<ResultController>(tag: "result");

  List<String> dropdownYearList = ["년"];
  List<String> dropdownMonthList = ["월"];
  List<String> dropdownDateList = ["일"];

  TextEditingController textcontroller = TextEditingController();
  TextEditingController textcontroller_center = TextEditingController();
  // Function to retrieve the login ID from SharedPreferences
  Future<String?> getLoginId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginId'); // This will return null if no loginId is set
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var strToday = formatter.format(now).split("-");
    for (int i = 1950; i < int.parse(strToday[0]); i++) {
      dropdownYearList.add(i.toString());
    }
    for (int i = 1; i < 13; i++) {
      dropdownMonthList.add(i.toString());
    }
    for (int i = 1; i < 32; i++) {
      dropdownDateList.add(i.toString());
    }

    textcontroller.addListener(() {
      resultcontroller.name.value = textcontroller.text;
      if (textcontroller.text != "") {
        resultcontroller.name_check.value = true;
      } else {
        resultcontroller.name_check.value = false;
      }
    });

    resultcontroller.aestheticId.value == "" ? getLoginId() : "";


    // fetchSurveyResultNo();
  }

  @override
  Widget build(BuildContext context) {
    controller.width(MediaQuery.of(context).size.width.toInt());
    controller.height(MediaQuery.of(context).size.height.toInt());

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          BlankTopProGressMulti(controller),
          BlankTopGap(controller),
          Subtitle("기본 정보", controller),
          QuestionTitle("피부 진단을 위한\n간단한 기본 정보를 입력해주세요.", controller),
          nameField(resultcontroller, textcontroller),
          centerField(resultcontroller,textcontroller_center),
          dateYearPicker(),
          sexCheck(resultcontroller),
          FirstNextButton("진단 시작하기", resultcontroller, onPressedButton)
        ],
      )),
    );
  }

  dateYearPicker() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
      width: 350,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DropdownButton<String>(
          value: resultcontroller.selectedyear.value,
          onChanged: (String? newValue) {
            setState(() {
              resultcontroller.selectedyear.value = newValue!;
              if (resultcontroller.selectedyear.value != "년" &&
                  resultcontroller.selectedmonth.value != "월" &&
                  resultcontroller.selecteddate.value != "일") {
                resultcontroller.selectedDatecheck.value = true;
              }
            });
          },
          items: dropdownYearList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, textAlign: TextAlign.center),
            );
          }).toList(),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(
              "년",
              style: TextStyle(
                fontFamily: "Pretendard",
                fontSize: 16,
              ),
            )),
        DropdownButton<String>(
          value: resultcontroller.selectedmonth.value,
          onChanged: (String? newValue) {
            setState(() {
              resultcontroller.selectedmonth.value = newValue!;
              if (resultcontroller.selectedyear.value != "년" &&
                  resultcontroller.selectedmonth.value != "월" &&
                  resultcontroller.selecteddate.value != "일") {
                resultcontroller.selectedDatecheck.value = true;
              }
            });
          },
          items:
              dropdownMonthList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, textAlign: TextAlign.center),
            );
          }).toList(),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(
              "월",
              style: TextStyle(
                fontFamily: "Pretendard",
                fontSize: 16,
              ),
            )),
        DropdownButton<String>(
          value: resultcontroller.selecteddate.value,
          onChanged: (String? newValue) {
            setState(() {
              resultcontroller.selecteddate.value = newValue!;
              print(newValue);
              if (resultcontroller.selectedyear.value != "년" &&
                  resultcontroller.selectedmonth.value != "월" &&
                  resultcontroller.selecteddate.value != "일") {
                resultcontroller.selectedDatecheck.value = true;
                DateTime now = DateTime.now();
                // int age = now.year - dob.year;
                // if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
                //   age--;
                // }
              }
            });
          },
          items: dropdownDateList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, textAlign: TextAlign.center),
            );
          }).toList(),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(
              "일",
              style: TextStyle(
                fontFamily: "Pretendard",
                fontSize: 16,
              ),
            )),
      ]),
    );
  }

  onPressedButton() {
    resultcontroller.calAge();
    return Get.to(ShortForm());
  }
}
