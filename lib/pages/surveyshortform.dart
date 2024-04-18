import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/shortanswer.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:basup_ver2/data/surveyitem.dart';
import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:basup_ver2/pages/surveyselectform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShortForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShortFormState();
  }
}

class _ShortFormState extends State<ShortForm> {
var surveycontroller = Get.find<SurveyController>(tag: "survey");
  var controller = Get.find<SizeController>(tag: "size");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    controller.width(MediaQuery.of(context).size.width.toInt());
    controller.height(MediaQuery.of(context).size.height.toInt());

    SurveyItem currentItem =
    surveycontroller.getSurveyItemList()[surveycontroller.current_idx];

    TextEditingController textcontroller = TextEditingController();

    textcontroller.addListener(() {
      currentItem.setUserAnswer(textcontroller.text);
      if (textcontroller.text != "") {
        surveycontroller.shortform.value = true;
      } else {
        surveycontroller.shortform.value = false;
      }
    });
    if (currentItem.getUserAnswer() != "") {
      textcontroller.value = TextEditingValue(
        text: currentItem.getUserAnswer().toString(),
      );
    }

    // TODO: implement build
    return Scaffold( body: SingleChildScrollView(
        child:  Column(
      children: [
        BlankTopProGressMulti(controller),
        BlankTopGap(controller),
        Subtitle("피부 상태 진단", controller),
        QuestionTitle(currentItem.getQuestionTitle() ,
            controller),
        QuestionDescrption(
            "자세한 처방을 목적으로 수집하며,\n그 외 어떠한 용도로도 사용하지 않아요!", controller),
        BlankDescAnser(controller),
        ShortFormAnswer(surveycontroller.current_idx == 0? "화장품 정보를 입력해주세요\n예)"+
        "닥터지 - 레드 블레미쉬 수딩 토너" : "피부 고민을 적어주세요\n예) 아침에 화장품을 발라도 점심만 되어도 땡겨요" ,
            controller,
            surveycontroller, textcontroller),
        // EnrollPicture("사진 등록", controller),
        BlankAnswerSubmit(controller),
        NextButton("다음", surveycontroller, onPressedButton)
      ],
    )),);
  }

  onPressedButton() {
    surveycontroller.current_idx = surveycontroller.current_idx + 1;
    SurveyItem nextItem =
    surveycontroller.getSurveyItemList()[surveycontroller.current_idx];
    if(nextItem.answerType == 0 ){
      Get.to(SelectForm());
    }
    else{
      setState(() {
        surveycontroller.shortform.value = false;
        print(surveycontroller.current_idx );
      });
    }
  }
}
