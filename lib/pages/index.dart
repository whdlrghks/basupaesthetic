import 'package:basup_ver2/component/loadingdialog.dart';
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

  // refreshSurvey(name, aestheticId) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('aestheticId', isEqualTo: aestheticId)
  //       .where('name', isEqualTo: name)
  //       .get();
  //   var surveyEachItemList = []; // SurveyItem 리스트 초기화
  //
  //   for (var doc in querySnapshot.docs) {
  //     var data = doc.data(); // 각 문서의 데이터를 가져옴
  //
  //     // 필요한 데이터를 이용하여 SurveyItem 객체 생성
  //     SurveyEachItem item = SurveyEachItem(
  //         date: data['date'], // 'date' 필드
  //         surveyId: data['survey_id'] // 'survey_id' 필드
  //         );
  //
  //     // 생성된 SurveyItem 객체를 리스트에 추가
  //     surveyEachItemList.add(item);
  //   }
  //   surveyEachItemList.sort(
  //       (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
  //
  //   resultcontroller.surveylist = surveyEachItemList; // 최종적으로 리스트를
  //   // resultController의 surveyList에 할당
  //   if (surveyEachItemList.isNotEmpty) {
  //     resultcontroller.survey_date.value = surveyEachItemList.first.date;
  //     resultcontroller.survey_id.value = surveyEachItemList.first.surveyId;
  //   }
  // }
  Future<Map<String, String>?> getLatestSurveyFromUsers(String name, String aestheticId) async {
    // Firestore 쿼리
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('aestheticId', isEqualTo: aestheticId)
        .where('name', isEqualTo: name)
        .get();

    // 만약 아무 문서도 못 찾으면 null
    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    // SurveyEachItem 구조를 가정 (date, survey_id)
    // 임시로 Map<String, String>로 저장
    List<Map<String, String>> surveyItems = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      // Firestore 필드명 가정: "date"와 "survey_id"
      // date는 "yyyy-MM-dd HH:mm:ss" 등으로 저장되었다고 가정
      final dateString = data['date'] ?? "";
      final surveyId = data['survey_id'] ?? "";

      if (dateString.isNotEmpty && surveyId.isNotEmpty) {
        surveyItems.add({
          'date': dateString,
          'survey_id': surveyId,
        });
      }
    }

    // date 필드를 DateTime으로 변환한 뒤 내림차순 정렬
    surveyItems.sort((a, b) {
      final dateA = DateTime.parse(a['date']!);
      final dateB = DateTime.parse(b['date']!);
      return dateB.compareTo(dateA); // 내림차순
    });

    if (surveyItems.isEmpty) {
      // date, survey_id가 하나도 없는 경우
      return null;
    }

    // 가장 최근 item (index 0)
    final latestItem = surveyItems.first;
    final latestSurveyDate = latestItem['date']!;
    final latestSurveyId = latestItem['survey_id']!;

    // 필요한 형태로 반환
    return {
      'date': latestSurveyDate,
      'survey_id': latestSurveyId,
    };
  }

  Future<List<Map<String, dynamic>>> _getSkinDataList(String surveyId) async {
    final query = await FirebaseFirestore.instance
        .collection('survey_id_skin_data')
        .where('survey_id', isEqualTo: surveyId)
        .get();
    // Firestore에서 가져온 문서들을 Map 형식으로 변환
    final docs = query.docs.map((doc) => doc.data()).toList();

    // date 필드가 "yyyy-MM-dd HH:mm:ss" 식으로 저장돼 있다고 가정
    docs.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA); // 내림차순: 가장 최근이 맨 앞
    });

    return docs;
  }

  Map<String, dynamic>? _getLatestDoc(List<Map<String, dynamic>> docs) {
    if (docs.isEmpty) return null;
    // docs[0] 이 가장 최신이라면:
    return docs.first;
  }

  Future<List<Map<String, dynamic>>> _getMicroscopeList(String surveyId) async {
    final query = await FirebaseFirestore.instance
        .collection('skin_microscope_images')
        .where('survey_id', isEqualTo: surveyId)
        .get();
    final docs = query.docs.map((doc) => doc.data()).toList();

    // date 필드가 "yyyy-MM-dd HH:mm:ss" 식으로 저장돼 있다고 가정
    docs.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA); // 내림차순: 가장 최근이 맨 앞
    });

    return docs;
  }

  Future<void> _saveNewSkinDataDoc({
    required String surveyId,
    required double oil,
    required double pig,
    required double sens,
    required double water,
    required double wrinkle,
    required String skintype,

  }) async {
    await FirebaseFirestore.instance.collection('survey_id_skin_data').add({
      'survey_id': surveyId,
      'oil': oil,
      'pig': pig,
      'sens': sens,
      'sens': sens,
      'wrinkle': wrinkle,
      'skintype': skintype,
      'date': DateTime.now()
    });
  }

  Future<void> refreshSurvey(String userName, String aestheticId) async {
    // 1) users collection => survey_id 가져오는 기존 로직

    var latestSurveyMap= await getLatestSurveyFromUsers(userName, aestheticId);
    String? surveyId = latestSurveyMap['survey_id'];
    if (surveyId == null || surveyId.isEmpty) {
      print("No survey_id found in users collection");
      return;
    }

    // 2) survey_id_skin_data에서 해당 surveyId의 문서들 조회
    final skinDataList = await _getSkinDataList(surveyId);
    final latestSkinDataDoc = skinDataList[0];

    // 3) skin_microscope_images에서 해당 surveyId의 문서들 조회
    final microscopeList = await _getMicroscopeList(surveyId);
    final latestMicroscopeDoc = microscopeList[0];

    // 4) 존재 여부 판단
    bool hasSkinData = latestSkinDataDoc != null;
    bool hasMicroscope = latestMicroscopeDoc != null;

    if(!hasSkinData && !hasMicroscope){
      fetchOnlySurveyResult(surveyId);
    }
    else if (hasSkinData && !hasMicroscope) {
      // (A) survey_id_skin_data 에만 존재
      print("Only in survey_id_skin_data => 기존 fetchSurveyResult");

      await fetchWebSkinResult(latestSkinDataDoc['skintype']);
      return;

    } else if (!hasSkinData && hasMicroscope) {
      // (B) skin_microscope_images 에만 존재
      print("Only in skin_microscope_images => 새로운 fetchSurveyResult(구분된 로직)");
      // 새로운 로직? ex) fetchSurveyResultForMicroscope(surveyId) or so
      // await fetchSurveyResultForMicroscope(surveyId);
      return;

    } else if (hasSkinData && hasMicroscope) {
      // (C) 둘 다 존재 => 최신 문서 비교
      DateTime skinDataTime = latestSkinDataDoc['date'];         // 가정
      DateTime microscopeTime = latestMicroscopeDoc['date'];     // 가정

      if (microscopeTime.isAfter(skinDataTime)) {
        // (C-1) skin_microscope_images가 더 최신 => 5번 진행
        print("microscope is newer => Step 5 logic");
        // 1) survey_id_skin_data에서 가장 최신 데이터 => ex) latestSkinDataDoc
        final oilOld = latestSkinDataDoc['oil'];
        final pigOld = latestSkinDataDoc['pig'];
        final sensOld = latestSkinDataDoc['sens'];
        final skintypeOld = latestSkinDataDoc['skintype'];
        final waterOld = latestSkinDataDoc['water'];
        final wrinkleOld = latestSkinDataDoc['wrinkle'];

        // 2) skin_microscope_images => latestMicroscopeDoc
        final headLed = latestMicroscopeDoc['headLed'];
        final headUv = latestMicroscopeDoc['headUv'];

        final leftLed = latestMicroscopeDoc['leftLed'];
        final leftUv = latestMicroscopeDoc['leftUv'];

        final rightLed = latestMicroscopeDoc['rightLed'];
        final rightUv = latestMicroscopeDoc['rightUv'];

        // 3) fetchCalculateAI -> return new (oil, pig, sens, skintype, water, wrinkle)
        final newlyCalculated = await fetchCalculateAI(
          oilOld, pigOld, sensOld, skintypeOld, waterOld, wrinkleOld,
          headLed, headUv, leftLed, leftUv, rightLed, rightUv
        );

        // newlyCalculated -> { 'oil': newOil, 'pig': newPig, ... }

        // 4) 6:4 비율로 섞어 최종값
        // 예시:
        final finalOil = (oilOld * 0.6) + (newlyCalculated['oil'] * 0.4);
        final finalPig = (pigOld * 0.6) + (newlyCalculated['pig'] * 0.4);
        final finalSens = (sensOld * 0.6) + (newlyCalculated['sens'] * 0.4);
        final finalWater = (waterOld * 0.6) + (newlyCalculated['water'] * 0.4);
        final finalWrinkle = (wrinkleOld * 0.6) + (newlyCalculated['wrinkle']
            * 0.4);
        // etc, pig, sens, ...
        // skintype 은 maybe integer? or string? => decide logic

        // 5) survey_id_skin_data에 새로운 문서로 저장
        // ex) timestamp = DateTime.now()

        var new_skintype=  computeSkinType(sens: finalSens, pig: finalPig,
            wrinkle: finalWrinkle, oil:finalOil, water: finalWater);
        await _saveNewSkinDataDoc(
            surveyId: surveyId,
            oil: finalOil,
            pig: finalPig,
          sens : finalSens,
          water : finalWater,
          wrinkle : finalWrinkle,
          skintype : new_skintype
        );

        // 6) -> step 6 : fetchWebSkinResult()
        final latestDocAgain = await _getSkinDataList(surveyId)[0];
        final finalSkintype = latestDocAgain['skintype'];
        await fetchWebSkinResult(finalSkintype);

      } else {
        // (C-2) survey_id_skin_data가 더 최신 => step 6 진행
        print("skinData is newer => Step 6 logic");
        // => 그냥 latestSkinDataDoc의 skintype 가져와서 fetchWebSkinResult
        final finalSkintype = latestSkinDataDoc['skintype'];
        await fetchWebSkinResult(finalSkintype);
      }

    } else {
      // (D) 둘 다 없다 => ?
      print("No survey_id_skin_data or skin_microscope_images found => fallback logic");
      return;
    }
  }

  String computeSkinType({
    required double sens,
    required double pig,
    required double wrinkle,
    required double oil,
    required double water,
  }) {
    // 1) Sens (S or R)
    //   sens > 50 => 'R', else 'S'
    final sensType = sens > 50 ? 'R' : 'S';

    // 2) Wrinkle (W or T)
    //   wrinkle >= 54 => 'T', else 'W'
    final wrinkleType = wrinkle >= 54 ? 'T' : 'W';

    // 3) Pig (P or N)
    //   pig >= 54 => 'N', else 'P'
    final pigType = pig >= 54 ? 'N' : 'P';

    // 4) Water => "De3","De2","De1","Hy1","Hy2","Hy3"
    //    <=25 : De3
    //    <=45 : De2
    //    <=59 : De1
    //    <=72 : Hy1
    //    <=85 : Hy2
    //    <=100 : Hy3
    //   (assuming water is in range 0..100)
    String waterType;
    if (water <= 25) {
      waterType = 'De3';
    } else if (water <= 45) {
      waterType = 'De2';
    } else if (water <= 59) {
      waterType = 'De1';
    } else if (water <= 72) {
      waterType = 'Hy1';
    } else if (water <= 85) {
      waterType = 'Hy2';
    } else {
      waterType = 'Hy3';
    }

    // 5) Oil => "D3","D2","D1","O1","O2","O3"
    //    <=25 : D3
    //    <=45 : D2
    //    <=59 : D1
    //    <=72 : O1
    //    <=85 : O2
    //    <=100 : O3
    String oilType;
    if (oil <= 25) {
      oilType = 'D3';
    } else if (oil <= 45) {
      oilType = 'D2';
    } else if (oil <= 59) {
      oilType = 'D1';
    } else if (oil <= 72) {
      oilType = 'O1';
    } else if (oil <= 85) {
      oilType = 'O2';
    } else {
      oilType = 'O3';
    }

    // 6) Combine into final skintype
    //    e.g. "R" + "P" + "T" + "O2" + "Hy1"
    //    (But note your text says "sens + pig + wrinkle + oil + water"
    //     so the order might be sens->pig->wrinkle->oil->water)
    final skintype = sensType + pigType + wrinkleType + oilType + waterType;

    return skintype;
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
        if (resultcontroller.survey_id.value == "") {
          LoadingDialog.show();
          await refreshSurvey(
              resultcontroller.name.value, resultcontroller.aestheticId.value);
          nextroute = "/scope?userid=${resultcontroller.user_id
              .value}&survey_id=${resultcontroller.survey_id.value}";
          LoadingDialog.hide();
        }
        else{
          nextroute = "/scope?userid=${resultcontroller.user_id
              .value}&survey_id=${resultcontroller.survey_id.value}";

        }

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
                      checkRecentData(resultcontroller.user_id.value);
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
