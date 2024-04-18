import 'dart:convert';

import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/data/surveyitem.dart';
import 'package:get/get.dart';

class SurveyController extends GetxController{
  var singleton = false;
  var version = 0.1.obs;
  var current_idx = -1.obs;

  var SurveyItemList = [].obs;
  var questionsize = 2.obs;
  var Question_List = [].obs;
  var type_list = [].obs;
  var Questiontype_List = [].obs;
  var Answer_List = [[]].obs;
  var User_List = [];

  var prevCosmetic = "".obs;
  var comment = "".obs;

  var user_moist = "".obs;
  var user_oil = "".obs;
  var user_pig = "".obs;
  var user_wrinkle = "".obs;
  var user_sens = "".obs;

  var shortform = false.obs;

  readyforSheet(String type) async {
    if (singleton) return;
    singleton = true;

    current_idx = 0;
    questionsize.value = 3;


    // 질문지 json
    String jsonString = await fetchGetSurvey(type);

    if (jsonString == "FAIL") {
      return;
    }

    final jsonResponse = json.decode(jsonString);

    current_idx = 0;
    makeSurveyList(jsonResponse["result"]["questions"], type);
    return;
  }

  makeSurveyList(qList, type) async {
    try {
      SurveyItemList.clear();
      print("makeSurveyList");
      questionsize.value = qList.length;
      qList.forEach((element) {
        SurveyItem temp = new SurveyItem(
            element["questionType"],
            element["questionTitle"],
            element["answerType"],
            element["answerList"]);
        SurveyItemList.add(temp);
      });
      return;
    } catch (e) {
      print(e);
      singleton = false;
    }
  }
  getSurveyItemList() {
    return SurveyItemList;
  }


  Future<void> allocateSurveyResult() async {
    var _sens = "";
    var _pig = "";
    var _wrinkle = "";
    var _oil = "";
    var _moist = "";

    int temp;
    prevCosmetic.value = SurveyItemList[0].getUserAnswer();
    comment.value = SurveyItemList[1].getUserAnswer();
    for (int i = 2; i < questionsize.value; i++) {
//      print("SurveyItemList[i].getUserAnswer() : " + SurveyItemList[i].getUserAnswer().toString());
      temp = int.parse(SurveyItemList[i].getUserAnswer().toString()) + 1;
      if (SurveyItemList[i].getQuestionType().toString() == "2") {
        _moist = _moist + "," + (temp-1).toString();
      } else if (SurveyItemList[i].getQuestionType().toString() == "3") {
        _oil = _oil + "," + (temp-1).toString();
      } else if (SurveyItemList[i].getQuestionType().toString() == "4") {
        _wrinkle = _wrinkle + "," + (temp-1).toString();
      } else if (SurveyItemList[i].getQuestionType().toString() == "5") {
        _pig = _pig + "," + (temp-1).toString();
      } else if (SurveyItemList[i].getQuestionType().toString() == "6") {
        _sens = _sens + "," + (temp-1).toString();
      }
    }
    user_moist.value = _moist.substring(1);
    user_oil.value = _oil.substring(1);
    user_pig.value = _pig.substring(1);
    user_wrinkle.value = _wrinkle.substring(1);
    user_sens.value = _sens.substring(1);
  }
}