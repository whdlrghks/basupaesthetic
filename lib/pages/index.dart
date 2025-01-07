import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sessionmanager.dart';
import 'package:basup_ver2/design/analyzeloading.dart';
import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/textstyle.dart';
import 'package:basup_ver2/pages/customerslistpage.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:basup_ver2/pages/skinmachine.dart';
import 'package:basup_ver2/pages/skinscope.dart';
import 'package:basup_ver2/pages/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:html' as html;

import 'package:shared_preferences/shared_preferences.dart';

import '../data/customer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  var resultcontroller = Get.find<ResultController>(tag: "result");


  @override
  void initState() {
    super.initState();
    resultcontroller.machine_check.value = false;
    resultcontroller.microscope_check.value = false;
    checkRecentData(resultcontroller.user_id.value);

  }

  refreshSurvey(name, aestheticId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('aestheticId', isEqualTo: aestheticId)
        .where('name', isEqualTo: name)
        .get();
    var surveyEachItemList = []; // SurveyItem 리스트 초기화

    for (var doc in querySnapshot.docs) {
      var data = doc.data(); // 각 문서의 데이터를 가져옴

      // 필요한 데이터를 이용하여 SurveyItem 객체 생성
      SurveyEachItem item = SurveyEachItem(
          date: data['date'], // 'date' 필드
          surveyId: data['survey_id'] // 'survey_id' 필드
          );

      // 생성된 SurveyItem 객체를 리스트에 추가
      surveyEachItemList.add(item);
    }
    surveyEachItemList.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    resultcontroller.surveylist = surveyEachItemList; // 최종적으로 리스트를
    // resultController의 surveyList에 할당
    if (surveyEachItemList.isNotEmpty) {
      resultcontroller.survey_date.value = surveyEachItemList.first.date;
      resultcontroller.survey_id.value = surveyEachItemList.first.surveyId;
    }
  }

  Future<void> checkRecentData(String userId) async {
    // Firestore 인스턴스
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 현재 한국 시간 계산
    final DateTime nowKST =
        DateTime.now().toUtc().add(const Duration(hours: 9));
    final DateTime oneHourAgoKST = nowKST.subtract(const Duration(hours: 1));

    // 조건에 맞는 데이터를 검색
    try {
      // skin_microscope_images 검색
      final QuerySnapshot microscopeSnapshot = await firestore
          .collection('skin_microscope_images')
          .where('user_id', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: oneHourAgoKST)
          .where('timestamp', isLessThanOrEqualTo: nowKST)
          .get();

      if (microscopeSnapshot.docs.isNotEmpty) {
        resultcontroller.microscope_check.value = true; // 조건에 맞는 데이터가 있음
        print("resultcontroller.microscope_check.value : " +
            resultcontroller.microscope_check.value.toString());
      }

      // skin_measurements 검색
      final QuerySnapshot measurementsSnapshot = await firestore
          .collection('skin_measurements')
          .where('user_id', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: oneHourAgoKST)
          .where('timestamp', isLessThanOrEqualTo: nowKST)
          .get();

      if (measurementsSnapshot.docs.isNotEmpty) {
        resultcontroller.machine_check.value = true; // 조건에 맞는 데이터가 있음
        print("resultcontroller.machine_check.value : " +
            resultcontroller.machine_check.value.toString());
      }
    } catch (e) {
      print('Error while checking data: $e');
      resultcontroller.microscope_check.value = false;
      resultcontroller.machine_check.value = false;
    }
  }

  Future<void> _buttonPressed(int buttonNumber) async {
    var nextroute = "";

    switch (buttonNumber) {
      case 1:
        nextroute =
            resultcontroller.user_id.value != "" ? "/shortform" : "/survey";
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
          Get.to(AnalyzeLoading());
          await refreshSurvey(
              resultcontroller.name.value, resultcontroller.aestheticId.value);
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

  // Function to retrieve the login ID from SharedPreferences
  Future<String?> getLoginId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('loginId'); // This will return null if no loginId is set
  }

  backKey() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
      child: new InkWell(
        child: Image(
          image: AssetImage('assets/backkey.png'),
          width: 20,
          height: 20,
          fit: BoxFit.fill,
        ),
        onTap: () async {
          String? shopId = await getLoginId();
          if (shopId != null) {
            // shopId가 null이 아니면, 해당 ID를 사용해서 CustomersListPage로 네비게이트
            Get.offAll(CustomersListPage(aestheticId: shopId));
          } else {
            // shopId가 null인 경우, 로그인 페이지로 이동하거나 에러 메시지를 표시
            print("Login ID not found, redirecting to login page.");
            Get.toNamed("/login"); // 로그인 페이지 경로는 앱 설정에 따라 달라질 수 있습니다.
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userid = Get.parameters['userid'];
    if (resultcontroller.user_id.value == "") {
      resultcontroller.user_id.value = userid!;
    }
    print(resultcontroller.user_id.value);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 100), // 왼쪽에서 100dp 떨어진 위치에
                child: Container(
                  child: backKey(), // 여기에 backKey() 위젯 호출
                ),
              ),
            ),
            Container(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Row의 가로축 가운데 정렬
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  resultcontroller.user_id.value != ""
                      ? 'welcome_user'
                          .trParams({'name': resultcontroller.name.value})
                      : 'welcome_guest'.tr,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    shadows: [],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    // 페이지 새로고침
                    setState(() {
                      checkRecentData(resultcontroller.user_id.value);
                    });
                  },
                ),
              ],
            ),
            Container(height: 100),
            ElevatedButton(
              onPressed: () => _buttonPressed(1),
              child: Text(
                'skin_questionnaire'.tr,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Row의 가로축 가운데 정렬
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _buttonPressed(2),
                  child: Text(
                    'skin_measurement_input'.tr,
                    style: index_button,
                  ),
                  style: ButtonStyle(
                    // Setting the background color
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF49A85E)),
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
                Obx(
                  () => resultcontroller.machine_check.value
                      ? Icon(
                          Icons.check_circle, // 체크 표시 아이콘
                          color: Colors.green, // 아이콘 색상
                          size: 40, // 아이콘 크기
                        )
                      : Container(),
                ),
              ],
            ),
            Container(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Row의 가로축 가운데 정렬
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _buttonPressed(3),
                  child: Text(
                    'skin_microscope_input'.tr,
                    style: index_button,
                  ),
                  style: ButtonStyle(
                    // Setting the background color
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF49A85E)),
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
                Obx(
                  () => resultcontroller.microscope_check.value
                      ? Icon(
                          Icons.check_circle, // 체크 표시 아이콘
                          color: Colors.green, // 아이콘 색상
                          size: 40, // 아이콘 크기
                        )
                      : Container(),
                ),
              ],
            ),
            Container(height: 40),
            ElevatedButton(
              onPressed: () => _buttonPressed(4),
              child: Text(
                'skin_results_check'.tr,
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
                'logout'.tr,
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
