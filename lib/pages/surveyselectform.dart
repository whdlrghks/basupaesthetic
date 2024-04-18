import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:basup_ver2/data/surveyitem.dart';
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
    // TODO: implement createState
    return _SelectFormState();
  }
}

class _SelectFormState extends State<SelectForm> {
  var surveycontroller = Get.find<SurveyController>(tag: "survey");
  var controller = Get.find<SizeController>(tag: "size");
  var current_idx = -1;

  var answercheck = [false, false, false, false, false];

  var nextflag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current_idx = surveycontroller.current_idx;
    answercheck = [false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.width(MediaQuery.of(context).size.width.toInt());
      controller.height(MediaQuery.of(context).size.height.toInt());
    });
    SurveyItem currentItem =
        surveycontroller.getSurveyItemList()[surveycontroller.current_idx];
    if (currentItem.hasUserAnswer()) {
      answercheck[currentItem.getUserAnswer()] = true;
    }

    // TODO: implement build
    return  Scaffold(
        body:  Column(
      children: [
        BlankTopProGressMulti(controller),
        BlankTopGap(controller),
        Obx(
          () => SubMultititle(
              getQuestionType(surveycontroller.current_idx, currentItem),
              controller,
              surveycontroller),
        ),
        Container(height: 35,),
        MultiQuestionTitle(currentItem.getQuestionTitle(), controller),
        answercheck[1]
            ? SelectedAnswer(surveycontroller, 1, currentItem,
          onPressedAnswer, answercheck)
            : UnselectedAnswer(
                surveycontroller, 1, currentItem, onPressedAnswer, onSubmit,answercheck),
        answercheck[2]
            ? SelectedAnswer(surveycontroller, 2, currentItem,
          onPressedAnswer, answercheck)
            : UnselectedAnswer(
                surveycontroller, 2, currentItem, onPressedAnswer, onSubmit, answercheck),
        answercheck[3]
            ? SelectedAnswer(surveycontroller, 3, currentItem,
          onPressedAnswer, answercheck)
            : UnselectedAnswer(
                surveycontroller, 3, currentItem, onPressedAnswer, onSubmit, answercheck),
        answercheck[4]
            ? SelectedAnswer(surveycontroller, 4, currentItem,
          onPressedAnswer, answercheck)
            : UnselectedAnswer(
                surveycontroller, 4, currentItem, onPressedAnswer, onSubmit, answercheck),
        BlankBackSubmit(controller),
        Container(
          child: Obx(
            () =>  ((surveycontroller.current_idx+1).toString() ==
                (surveycontroller.questionsize).toString())
                // && currentItem.hasUserAnswer()
                ? SubmitButton(
                    "제출", controller, surveycontroller,  onSurveySubmit)
                : BackPressButton(
                    "이전 질문으로 가기", controller, surveycontroller, onBackPressed),
          ),
        )
      ],
    ),);
  }

  onSurveySubmit() async {

    await surveycontroller.allocateSurveyResult();
    Get.to(SubmitLoading(), transition: Transition.rightToLeftWithFade);
    await fetchSurveySubmit();
    GetPage(name: '/shortform', page : ()=> AuthGuard(child: ShortForm
      ()));
    // Get.offAll(Index(), transition: Transition.rightToLeftWithFade);
  }

  onPressedAnswer() {
    setState(() {
      current_idx = surveycontroller.current_idx;
      answercheck = [false, false, false, false, false];
    });
  }

  onBackPressed() {
    surveycontroller.current_idx = surveycontroller.current_idx - 1;
    SurveyItem currentItem =
        surveycontroller.getSurveyItemList()[surveycontroller.current_idx];
    currentItem.answerType == 0
        ? setState(() {
            current_idx = surveycontroller.current_idx;
            answercheck = [false, false, false, false, false];
          })
        : Get.to(ShortForm());
  }

  onSubmit(answercheck, idx){
    setState(() {
      for(int i= 1 ; i < 5 ; i++){
        if(idx.toString() == i.toString()){
          answercheck[i] = true;
        }
        else{
          answercheck[i] = false;
        }
      }
    });
  }

  getQuestionType(int idx, currentItem) {
    var type_idx = currentItem.getQuestionType().toString();
    var type_result = "";
    switch (type_idx) {
      case "1":
        type_result = "피부 상태 진단";
        break;
      case "2":
        type_result = "수분량 진단";
        break;
      case "3":
        type_result = "유분량 진단";
        break;
      case "4":
        type_result = "주름 / 탄력 진단";
        break;
      case "5":
        type_result = "색소 침착 확인";
        break;
      case "6":
        type_result = "민감성 확인";
        break;
      default:
    }
    return type_result;
  }
}
