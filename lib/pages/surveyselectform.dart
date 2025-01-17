import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/loadingdialog.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:basup_ver2/data/surveyitem.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:basup_ver2/pages/authguard.dart';
import 'package:basup_ver2/pages/index.dart';
import 'package:basup_ver2/pages/skinresult.dart';
import 'package:basup_ver2/pages/submitloading.dart';
import 'package:basup_ver2/pages/surveyshortform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectFormState();
  }
}

class _SelectFormState extends State<SelectForm> {
  // 컨트롤러 이름을 카멜케이스로 정리
  final surveyController = Get.find<SurveyController>(tag: "survey");
  final sizeController = Get.find<SizeController>(tag: "size");

  // 기존 current_idx -> currentIndex
  int currentIndex = -1;

  // answerCheck를 RxList로 관리 (0~4 인덱스)
  RxList<bool> answerCheck = RxList<bool>.filled(5, false);

  @override
  void initState() {
    super.initState();
    // 초기값 세팅
    currentIndex = surveyController.current_idx;
    // 여기서도 필요하다면 재초기화 가능
    // answerCheck.value = [false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      sizeController.width(MediaQuery.of(context).size.width.toInt());
      sizeController.height(MediaQuery.of(context).size.height.toInt());
    });



    return Scaffold(
      body:  Obx(() {
        final currentIndex = surveyController.current_idx;
        final currentItem = surveyController.getSurveyItemList()[currentIndex];

        // 이미 답변이 있다면 해당 인덱스 true
        if (currentItem.hasUserAnswer()) {
          // getUserAnswer()가 예: 1 ~ 4 인덱스를 반환한다고 가정
          answerCheck[currentItem.getUserAnswer()] = true;
        }
        return Column(
          children: [
            BlankTopProGressMulti(sizeController),
            BlankTopGap(sizeController),

            // 질문 유형
            SubMultititle(
              getQuestionType(currentIndex, currentItem),
              sizeController,
              surveyController,
            ),
            SizedBox(height: 35),
            MultiQuestionTitle(currentItem.getQuestionTitle(), sizeController),

            // 반복 문항
            Column(
              children: List.generate(4, (index) {
                final answerIndex = index + 1;
                if (answerCheck[answerIndex]) {
                  return SelectedAnswer(
                    surveyController,
                    answerIndex,
                    currentItem,
                    onPressAnswerReset,
                    answerCheck,
                  );
                } else {
                  return UnselectedAnswer(
                    surveyController,
                    answerIndex,
                    currentItem,
                    onPressAnswerReset,
                    onSubmitAnswer,
                    answerCheck,
                  );
                }
              }),
            ),

            // 뒤로가기 or 제출 버튼
            BlankBackSubmit(sizeController),
            if ((surveyController.current_idx + 1).toString() ==
                (surveyController.questionsize).toString())
              SubmitButton("submit".tr, sizeController, surveyController, onSurveySubmit)
            else
              BackPressButton("previous_question".tr, sizeController, surveyController, onBackPressed),
          ],
        );
      }),
    );
  }

  // --- 설문 제출 로직 ---
  Future<void> onSurveySubmit() async {
    await surveyController.allocateSurveyResult();

    LoadingDialog.show();
    try {
      var result = await fetchSurveySubmit();
      print("finish onSurveySubmit");

      LoadingDialog.hide();
      if (result == CODE_OK) {
        var resultController = Get.find<ResultController>(tag: "result");
        // 파라미터로 전달 (Getx 4.x 방식)
        Get.toNamed("/index", parameters: {
          "userid": resultController.user_id.value
        });
      } else {
        // 에러 시 shortform 이동
        GetPage(
          name: '/shortform',
          page: () => AuthGuard(child: ShortForm()),
        );
      }
    } catch (e) {
      // 네트워크/기타 에러 처리
      print("onSurveySubmit Error: $e");
    } finally {
    }
  }

  // --- 기존 onPressedAnswer() 역할: 선택지 리셋 ---
  void onPressAnswerReset() {
    // 굳이 setState 없이 RxList 값을 바꿔도 Obx가 있으면 재빌드됩니다.
    currentIndex = surveyController.current_idx;
    for (int i = 0; i < answerCheck.length; i++) {
      answerCheck[i] = false;
    }
  }

  // --- 이전 질문으로 돌아가기 ---
  void onBackPressed() {
    // 현재 SurveyController에 있는 인덱스 감소
    surveyController.current_idx = surveyController.current_idx - 1;
    // 새로 바뀐 인덱스 기준으로 아이템 조회
    SurveyItem currentItem = surveyController
        .getSurveyItemList()[surveyController.current_idx];

    // answerType == 0 이면 현재 페이지에서 answerCheck 리셋
    // 아니면 ShortForm으로 이동
    if (currentItem.answerType == 0) {
      currentIndex = surveyController.current_idx;
      for (int i = 0; i < answerCheck.length; i++) {
        answerCheck[i] = false;
      }
    } else {
      Get.to(() => ShortForm());
    }
  }

  // --- 기존 onSubmit(answercheck, idx) → 선택지 클릭 시 호출 ---
  void onSubmitAnswer(int idx) {
    print("onSubmitAnswer");
    // idx만 true, 나머지는 false
    for (int i = 1; i < 5; i++) {
      answerCheck[i] = (i == idx);
    }
  }

  // --- 질문 유형 얻기 ---
  String getQuestionType(int idx, SurveyItem currentItem) {
    var typeIdx = currentItem.getQuestionType().toString();
    var typeResult = "";
    switch (typeIdx) {
      case "1":
        typeResult = "skin_diagnosis".tr;
        break;
      case "2":
        typeResult = "hydration_diagnosis".tr;
        break;
      case "3":
        typeResult = "sebum_diagnosis".tr;
        break;
      case "4":
        typeResult = "wrinkle_elasticity_diagnosis".tr;
        break;
      case "5":
        typeResult = "pigmentation_check".tr;
        break;
      case "6":
        typeResult = "sensitivity_check".tr;
        break;
      default:
    }
    return typeResult;
  }
}