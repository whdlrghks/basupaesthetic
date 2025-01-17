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

  // Dropdown 리스트 (년도, 월, 일)
  final List<String> dropdownYearList = ["년"];
  final List<String> dropdownMonthList = ["월"];
  final List<String> dropdownDateList = ["일"];

  // 텍스트 필드 컨트롤러
  final TextEditingController textcontroller       = TextEditingController(); // 사용자 이름
  final TextEditingController textcontrollerCenter = TextEditingController(); // 센터 ID (readOnly)

  // [1] SharedPreferences에서 loginId(= aestheticId) 가져오기
  Future<String?> getLoginId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginId');
  }

  // [2] aestheticId가 비었다면, SharedPreferences에서 불러와 세팅
  Future<void> _initAestheticIdIfNeeded() async {
    if (resultcontroller.aestheticId.value.isEmpty) {
      final id = await getLoginId();
      if (id != null && id.isNotEmpty) {
        // 리액티브 변수 세팅
        resultcontroller.aestheticId.value = id;
        // UI 표시
        textcontrollerCenter.text = id;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 날짜 관련 리스트 초기화
    final now = DateTime.now();
    final strToday = DateFormat('yyyy-MM-dd').format(now).split("-");
    for (int i = 1950; i < int.parse(strToday[0]); i++) {
      dropdownYearList.add(i.toString());
    }
    for (int i = 1; i < 13; i++) {
      dropdownMonthList.add(i.toString());
    }
    for (int i = 1; i < 32; i++) {
      dropdownDateList.add(i.toString());
    }

    // 이름 필드 변화 감지 → resultcontroller에 반영
    textcontroller.addListener(() {
      resultcontroller.name.value = textcontroller.text;
      resultcontroller.name_check.value = textcontroller.text.isNotEmpty;
    });

    // (센터ID) aestheticId가 비었으면 SharedPreferences에서 가져옴
    _initAestheticIdIfNeeded();

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    controller.width(size.width.toInt());
    controller.height(size.height.toInt());

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          BlankTopProGressMulti(controller),
          BlankTopGap(controller),
          Subtitle("user_general_info".tr, controller),
          QuestionTitle("info_input".tr, controller),
          nameField(resultcontroller, textcontroller),
          centerField(resultcontroller,textcontrollerCenter),
          dateYearPicker(),
          sexCheck(resultcontroller),
          FirstNextButton("start_diagnostice".tr, resultcontroller,
              onPressedButton)
        ],
      )),
    );
  }

  /// 생년월일 입력 (연/월/일) 드롭다운
  Widget dateYearPicker() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      width: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 연도
          DropdownButton<String>(
            value: resultcontroller.selectedyear.value,
            onChanged: (String? newValue) {
              setState(() {
                resultcontroller.selectedyear.value = newValue!;
                _updateSelectedDateCheck();
              });
            },
            items: dropdownYearList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, textAlign: TextAlign.center),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(
              "year".tr,
              style: const TextStyle(fontFamily: "Pretendard", fontSize: 16),
            ),
          ),
          // 월
          DropdownButton<String>(
            value: resultcontroller.selectedmonth.value,
            onChanged: (String? newValue) {
              setState(() {
                resultcontroller.selectedmonth.value = newValue!;
                _updateSelectedDateCheck();
              });
            },
            items: dropdownMonthList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, textAlign: TextAlign.center),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(
              "month".tr,
              style: const TextStyle(fontFamily: "Pretendard", fontSize: 16),
            ),
          ),
          // 일
          DropdownButton<String>(
            value: resultcontroller.selecteddate.value,
            onChanged: (String? newValue) {
              setState(() {
                resultcontroller.selecteddate.value = newValue!;
                _updateSelectedDateCheck();
              });
            },
            items: dropdownDateList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, textAlign: TextAlign.center),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(
              "day".tr,
              style: const TextStyle(fontFamily: "Pretendard", fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// 날짜가 모두 선택되었는지 체크 -> selectedDatecheck.value = true
  void _updateSelectedDateCheck() {
    if (resultcontroller.selectedyear.value != "년" &&
        resultcontroller.selectedmonth.value != "월" &&
        resultcontroller.selecteddate.value != "일") {
      resultcontroller.selectedDatecheck.value = true;
    }
  }

  onPressedButton() {
    resultcontroller.calAge();
    return Get.to(ShortForm());
  }
}
