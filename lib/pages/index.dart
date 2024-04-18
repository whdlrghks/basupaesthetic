import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sessionmanager.dart';
import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/textstyle.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:basup_ver2/pages/skinmachine.dart';
import 'package:basup_ver2/pages/skinscope.dart';
import 'package:basup_ver2/pages/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:html' as html;

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  var resultcontroller = Get.find<ResultController>(tag: "result");

  Future<void> _buttonPressed(int buttonNumber) async {
    var nextroute = "";

    switch (buttonNumber) {
      case 1:
        nextroute = resultcontroller.user_id.value != ""
            ? "/shortform"
            : "/s"
                "urvey";
        break;
      case 2:
        nextroute = "/machine";
        break;
      case 3:
        nextroute = "/scope?userid=${resultcontroller.user_id.value}";
        var url = getCurrentUrl();
        int lastIndex = url.lastIndexOf('/');
        String modifiedUrl = url.substring(0, lastIndex);
        String qr_url = modifiedUrl + nextroute;

        print(qr_url);
        Get.dialog(ShowQRdialog(qr_url, nextroute));
        return;
      case 4:
        if (resultcontroller.survey_id.value == "") {
          Get.dialog(NoDatadialog());
          return;
        } else {
          await fetchSurveyResult(resultcontroller.survey_id.value);
          nextroute = "/result";
        }
        break;
      default:
        return;
    }
    Get.toNamed(nextroute);
  }

  String getCurrentUrl() {
    return html.window.location.href;
  }

  @override
  Widget build(BuildContext context) {
    var userid = Get.parameters['userid'];
    if (resultcontroller.user_id.value == "") {
      resultcontroller.user_id.value = userid!;
    }

    return Scaffold(
      body:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(height: 50),
              Text(
                resultcontroller.user_id.value != ""
                    ? '${resultcontroller.name.value}님을 환영합니다.'
                    : "BASUP 피부 문진을 클릭해서\n새로운 고객을 등록해주세요",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  shadows: [],
                ),
              ),
              Container(height: 100),
              ElevatedButton(
                onPressed: () => _buttonPressed(1),
                child: Text(
                  'BASUP 피부 문진',
                  style: index_button,
                ),
                style: ButtonStyle(
                  // Setting the background color
                  backgroundColor: MaterialStateProperty.all(Color(0xFF49A85E)),
                  // Setting the foreground color (text color)
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // Setting padding
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)),
                  // Setting the shape
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFF49A85E)),
                    ),
                  ),
                ),
              ),
              Container(height: 40),
              ElevatedButton(
                onPressed: () => _buttonPressed(2),
                child: Text(
                  'BASUP 피부 측정기 입력',
                  style: index_button,
                ),
                style: ButtonStyle(
                  // Setting the background color
                  backgroundColor: MaterialStateProperty.all(Color(0xFF49A85E)),
                  // Setting the foreground color (text color)
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // Setting padding
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)),
                  // Setting the shape
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFF49A85E)),
                    ),
                  ),
                ),
              ),
              Container(height: 40),
              ElevatedButton(
                onPressed: () => _buttonPressed(3),
                child: Text(
                  'BASUP 피부 현미경 입력',
                  style: index_button,
                ),
                style: ButtonStyle(
                  // Setting the background color
                  backgroundColor: MaterialStateProperty.all(Color(0xFF49A85E)),
                  // Setting the foreground color (text color)
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // Setting padding
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)),
                  // Setting the shape
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFF49A85E)),
                    ),
                  ),
                ),
              ),
              Container(height: 40),
              ElevatedButton(
                onPressed: () => _buttonPressed(4),
                child: Text(
                  'BASUP 피부 결과 확인',
                  style: index_button,
                ),
                style: ButtonStyle(
                  // Setting the background color
                  backgroundColor: MaterialStateProperty.all(Color(0xFF49A85E)),
                  // Setting the foreground color (text color)
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // Setting padding
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)),
                  // Setting the shape
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFF49A85E)),
                    ),
                  ),
                ),
              ),
              Container(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await SessionManager.logout();
                  // Optionally, navigate back to the login screen
                  Get.toNamed("/");
                },
                child: Text(
                  '로그아웃',
                  style: index_button,
                ),
                style: ButtonStyle(
                  // Setting the background color
                  backgroundColor: MaterialStateProperty.all(Color(0xFF49A85E)),
                  // Setting the foreground color (text color)
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // Setting padding
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)),
                  // Setting the shape
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFF49A85E)),
                    ),
                  ),
                ),
              )
            ],
          ),

      ),
    );
  }
}
