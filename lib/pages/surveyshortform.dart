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

    // 만약 첫 빌드 이후 한 번만 사이즈를 가져와서 저장하고 싶다면:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      controller.width(size.width.toInt());
      controller.height(size.height.toInt());
    });
  }


  @override
  Widget build(BuildContext context) {

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
        Subtitle("skin_diagnosis_title".tr, controller),
        QuestionTitle(currentItem.getQuestionTitle() ,
            controller),
        QuestionDescrption(
            "detailed_prescription_collect_info".tr, controller),
        BlankDescAnser(controller),
        ShortFormAnswer(surveycontroller.current_idx == 0? "enter_cosmetic_in"
            "fo".tr : "enter_skin_concerns".tr ,
            controller,
            surveycontroller, textcontroller),
        // EnrollPicture("사진 등록", controller),
        BlankAnswerSubmit(controller),
        NextButton("next".tr, surveycontroller, onPressedButton)
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
