import 'dart:math';

import 'package:basup_ver2/controller/localecontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:basup_ver2/data/cosmeticdata.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:basup_ver2/pages/skinresult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'resultcontroller.dart';

String getLanguageParamFromLocale(Locale? locale) {
  if (locale == null) return 'English'; // 기본값

  switch (locale.languageCode) {
    case 'ko':
      return 'KOR';
    case 'en':
      return 'ENG';
    case 'ja':
      return 'JPN';
    case 'zh':
      return 'CHN';
    case 'id':
      return 'IND';
    // 추가 언어가 필요하면 여기에 추가
    default:
      return 'KOR'; // 기본값
  }
}

Future<String> fetchGetSurvey(type) async {
  print("fetchGetSurvey ");
  String baseUrl = dev_hidden_tap ? Dev_URL : URL; // URL 설정
  final LocaleController localeController = Get.find();
  // await localeController.loadLocale();
  Locale? currentLocale = localeController.locale.value;
  String languageParam = getLanguageParamFromLocale(currentLocale);

  String temp = '$baseUrl/survey';
  var url = Uri.parse(temp);

  // 쿼리 파라미터에 언어 설정 추가
  var _query = <String, String>{
    'type': type,
    'version': "0.1",
    'language': languageParam, // 언어 파라미터 추가
  };

  url = url.replace(queryParameters: _query);

  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'x-skin-lab': (access_Dev_Token),
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];
  print(decodeData);

  if (result_status == CODE_OK) {
    return decodeData;
  } else {
    return "FAIL";
  }
}

Future<void> fetchPost_Cosmetic(type) async {
  // var userController = Get.find<UserController>(tag: "user");
  //
  // String temp = (dev_hidden_tap ? Dev_URL : URL) + '/cosmetic/components';
  //
  // var url = Uri.parse(temp);
  //
  // var fullName = userController.skin_type.value;
  //TD
  // var essenceName = fullName.substring(0, 4);
  // var ampouleName = fullName.substring(3, 5);
  // var serumName = fullName.substring(5);
  //
  // var version = userController.cosmetic_version.value;
  //
  // var headers = <String, String>{
  //   'x-skin-lab': (dev_hidden_tap ? access_Dev_Token : access_Token),
  // };
  //
  // var _query = <String, String>{
  //   'types': 'essence,serum,ampoule',
  //   'names': essenceName + "," + serumName + "," + ampouleName,
  //   'version': version,
  // };
  // url = url.replace(queryParameters: _query);
  // //{url}}/cosmetic/components?types=essence,serum,ampoule&names=RNTD,D1,De1&version=0.1
  // print(url);
  // var request = http.MultipartRequest('GET', url);
  //
  // request.headers.addAll(headers);
  // http.StreamedResponse response = await request.send();
  //
  // final respStr = await response.stream.bytesToString();
  // print(respStr);
  //
  // final parsed = json.decode(respStr).cast<String, dynamic>();
  // print(parsed);
  // var result = parsed["result"];
  // if (parsed["resCode"] == CODE_OK) {
  //   if (userController.cos_ingredients.length == 0) {
  //     userController.cos_ingredients.clear();
  //     var _temp_ingredientList = [];
  //     var _ingre_check = [];
  //     userController.cosmetic_version.value = result["version"];
  //     var cosSize = result["cosmeticComponentList"].length;
  //     for (int i = 0; i < cosSize; i++) {
  //       var cosmeticIngredientList =
  //       result["cosmeticComponentList"][i]["cosmeticIngredientList"];
  //       for (var item in cosmeticIngredientList) {
  //         CosmeticData data = new CosmeticData();
  //         if (!_ingre_check.contains(item["name"])) {
  //           _ingre_check.add(item["name"]);
  //           data.setCosmeticData(item["name"], item["description"]);
  //           _temp_ingredientList.add(data);
  //         }
  //       }
  //     }
  //     print(_temp_ingredientList);
  //     userController.cos_ingredients.value = _temp_ingredientList;
  //     var randomset = [];
  //     while (true) {
  //       // 랜덤으로 번호를 생성해준다.
  //       var rnd = Random().nextInt(userController.cos_ingredients.length);
  //
  //       // 만약 리스트에 생성된 번호가 없다면
  //       if (!randomset.contains(rnd)) {
  //         // 리스트에 추가해준다.
  //         randomset.add(rnd);
  //       }
  //
  //       // 리스트의 길이가 6이면 while문을 종료한다.
  //       if (randomset.length == 6) break;
  //     }
  //
  //     for (var idx in randomset) {
  //       userController.ingredient
  //           .add(userController.cos_ingredients[idx].getcosName());
  //       userController.detail
  //           .add(userController.cos_ingredients[idx].getcosDescription());
  //     }
  //   }
  //   if(type){
  //     Get.to(Cosresult(), transition: Transition.cupertino);
  //   }
  //   else{
  //
  //     Get.to(PersonalCos(),
  //       transition: Transition.rightToLeftWithFade,);
  //   }
  // } else {
  //   Get.dialog(failGetCosmetic());
  // }
}

Future<String> fetchSurveySubmit() async {
  String url = (dev_hidden_tap ? Dev_URL : URL) + '/survey/answer';
  var surveyController = Get.find<SurveyController>(tag: "survey");
  var resultController = Get.find<ResultController>(tag: "result");

  var type = "initial";
  var birthday = resultController.selectedyear.toString() +
      "-" +
      resultController.selectedmonth.toString() +
      "-" +
      resultController.selecteddate.toString();

  var answer = <String, String>{
    'sens': surveyController.user_sens.value,
    'pig': surveyController.user_pig.value,
    'wrinkle': surveyController.user_wrinkle.value,
    'oil': surveyController.user_oil.value,
    'moist': surveyController.user_moist.value,
    'prevCosmetic': surveyController.prevCosmetic.value,
    'comment': surveyController.comment.value,
  };
  var body = jsonEncode(<String, dynamic>{
    "version": surveyController.version.value,
    "type": type,
    "name": resultController.name.value,
    "answer": answer,
    "sex": resultController.gender.value == Gender.M ? "M" : "W",
    "birthDay": birthday,
  });

  print(body);

  http.Response response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: body,
  );
  // String filePath = "assets/dummy.json";
  // String text = await rootBundle.loadString(filePath);

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();
  print("fetchSurveySubmit " + parsed["resCode"]);
  print("fetchSurveySubmit " + decodeData);
  print("fetchSurveySubmit " + parsed["result"]["surveyCode"]);
  if (parsed["resCode"] == CODE_OK) {
    print("test okay");
    resultController.survey_id.value = parsed["result"]["surveyCode"];
    await createUserDocument(
        resultController: resultController, onlysurvey: true);
    // Get.toNamed("/index?userid="+resultController.user_id.value);
    return CODE_OK;
  } else {
    print("Fail to login");
    //인증 실패
    //다시 로그인해야함.
    return "FAIL";
  }
}

fetchOnlySurveyResult(surveyCode) async {
  print("fetchOnlySurveyResult ");

  var resultController = Get.find<ResultController>(tag: "result");
  //
  // String temp = (dev_hidden_tap ? Dev_URL : URL) + '/survey/result';
  // var url = Uri.parse(temp);
  // //var surveyCode = j6lfDzst;
  // var _query = <String, String>{
  //   'surveyCode': surveyCode,
  // };
  //
  // url = url.replace(queryParameters: _query);

  String baseUrl = dev_hidden_tap ? Dev_URL : URL; // URL 설정
  final LocaleController localeController = Get.find();
  await localeController.loadLocale();
  Locale? currentLocale = localeController.locale.value;
  String languageParam = getLanguageParamFromLocale(currentLocale);
  String temp = '$baseUrl/survey/result';
  var url = Uri.parse(temp);

  // 쿼리 파라미터에 언어 설정 추가
  var _query = <String, String>{
    'surveyCode': surveyCode,
    'language': languageParam, // 언어 파라미터 추가
  };

  url = url.replace(queryParameters: _query);

  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'x-skin-lab': (dev_hidden_tap ? access_Dev_Token : access_Token),
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];
  var result = parsed["result"];
  print(parsed);

  if (result_status == CODE_OK) {
    resultController.survey_id.value = surveyCode;
    // 점수
    resultController.type.value = parsed["result"]["skinType"];
    resultController.setData(
        parsed["result"]["scores"]["sens"].toInt(),
        parsed["result"]["scores"]["wrinkle"].toInt(),
        parsed["result"]["scores"]["moist"].toInt(),
        parsed["result"]["scores"]["oil"].toInt(),
        parsed["result"]["scores"]["pig"].toInt());
    // 화장품 성분
    if (resultController.ingredient.length == 0) {
      resultController.ingredient.clear();
      resultController.detail.clear();
      var _temp_ingredientList = [];
      var _ingre_check = [];
      var cosSize = result["cosmeticComponentList"].length;
      for (int i = 0; i < cosSize; i++) {
        var cosmeticIngredientList =
            result["cosmeticComponentList"][i]["cosmeticIngredientList"];
        for (var item in cosmeticIngredientList) {
          CosmeticData data = new CosmeticData();
          if (!_ingre_check.contains(item["name"])) {
            _ingre_check.add(item["name"]);
            data.setCosmeticData(item["name"], item["description"]);
            _temp_ingredientList.add(data);
          }
        }
      }
      print(_temp_ingredientList);
      resultController.cos_ingredients.value = _temp_ingredientList;
      var randomset = [];
      while (true) {
        // 랜덤으로 번호를 생성해준다.
        var rnd = Random().nextInt(resultController.cos_ingredients.length);

        // 만약 리스트에 생성된 번호가 없다면
        if (!randomset.contains(rnd)) {
          // 리스트에 추가해준다.
          randomset.add(rnd);
        }

        // 리스트의 길이가 6이면 while문을 종료한다.
        if (randomset.length == resultController.cos_ingredients.length) break;
      }

      for (var idx in randomset) {
        resultController.ingredient
            .add(resultController.cos_ingredients[idx].getcosName());
        resultController.detail
            .add(resultController.cos_ingredients[idx].getcosDescription());
      }
    }

    // 피부 분석
    if (parsed["result"]["comments"] != null) {
      resultController.skinResultContent.clear();
      resultController.skinResultContent.add(parsed["result"]["comments"][0]);
      resultController.skinResultContent.add(parsed["result"]["comments"][1]);
      resultController.skinResultContent.add(parsed["result"]["comments"][2]);
      print(resultController.skinResultContent);
    }

    // 스킨 루틴
    if (parsed["result"]["guides"] != null) {
      resultController.routinecontent.clear();
      resultController.routinekeyword.clear();

      for (var g in parsed["result"]["guides"]) {
        resultController.routinecontent.add(g['guide']);
        resultController.routinekeyword.add(g['keyword']);
      }
    }
    // _saveNewSkinDataDoc(surveyId: surveyCode, oil : resultController.oilper,
    //     pig:resultController.pigper, sens: resultController.sensper, water :
    //     resultController.waterper, wrinkle: resultController.tightper,
    //     skintype: resultController.type.value);
    await fetchWebSkinResult(resultController.type.value);

    return CODE_OK;
  } else {
    return "FAIL";
  }
}

Future<void> _saveNewSkinDataDoc({
  required String surveyId,
  required int oil,
  required int pig,
  required int sens,
  required int water,
  required int wrinkle,
  required String skintype,
}) async {
  var date = DateTime.now().toString();
  await FirebaseFirestore.instance.collection('survey_id_skin_data').add({
    'survey_id': surveyId,
    'oil': oil,
    'pig': pig,
    'sens': sens,
    'sens': sens,
    'wrinkle': wrinkle,
    'skintype': skintype,
    'date': date
  });
}

fetchSurveyResult(surveyCode) async {

  print("[DEBUG]`fetchSurveyResult");

  var resultController = Get.find<ResultController>(tag: "result");
  //
  // String temp = (dev_hidden_tap ? Dev_URL : URL) + '/survey/result';
  // var url = Uri.parse(temp);
  // //var surveyCode = j6lfDzst;
  // var _query = <String, String>{
  //   'surveyCode': surveyCode,
  // };
  //
  // url = url.replace(queryParameters: _query);

  String baseUrl = dev_hidden_tap ? Dev_URL : URL; // URL 설정
  final LocaleController localeController = Get.find();
  await localeController.loadLocale();
  Locale? currentLocale = localeController.locale.value;
  String languageParam = getLanguageParamFromLocale(currentLocale);
  String temp = '$baseUrl/survey/result';
  var url = Uri.parse(temp);

  // 쿼리 파라미터에 언어 설정 추가
  var _query = <String, String>{
    'surveyCode': surveyCode,
    'language': languageParam, // 언어 파라미터 추가
  };

  url = url.replace(queryParameters: _query);

  print("[DEBUG]`fetchSurveyResult url : ${url}");
  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'x-skin-lab': (dev_hidden_tap ? access_Dev_Token : access_Token),
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];
  var result = parsed["result"];
  print(parsed);
  print("[DEBUG]`fetchSurveyResult parsed : ${parsed}");

  if (result_status == CODE_OK) {
    resultController.survey_id.value = surveyCode;
    // 점수
    resultController.type.value = parsed["result"]["skinType"];
    resultController.setData(
        parsed["result"]["scores"]["sens"].toInt(),
        parsed["result"]["scores"]["wrinkle"].toInt(),
        parsed["result"]["scores"]["moist"].toInt(),
        parsed["result"]["scores"]["oil"].toInt(),
        parsed["result"]["scores"]["pig"].toInt());
    // 화장품 성분
    if (resultController.ingredient.length == 0) {
      resultController.ingredient.clear();
      resultController.detail.clear();
      var _temp_ingredientList = [];
      var _ingre_check = [];
      var cosSize = result["cosmeticComponentList"].length;
      for (int i = 0; i < cosSize; i++) {
        var cosmeticIngredientList =
            result["cosmeticComponentList"][i]["cosmeticIngredientList"];
        for (var item in cosmeticIngredientList) {
          CosmeticData data = new CosmeticData();
          if (!_ingre_check.contains(item["name"])) {
            _ingre_check.add(item["name"]);
            data.setCosmeticData(item["name"], item["description"]);
            _temp_ingredientList.add(data);
          }
        }
      }
      print(_temp_ingredientList);
      resultController.cos_ingredients.value = _temp_ingredientList;
      var randomset = [];
      while (true) {
        // 랜덤으로 번호를 생성해준다.
        var rnd = Random().nextInt(resultController.cos_ingredients.length);

        // 만약 리스트에 생성된 번호가 없다면
        if (!randomset.contains(rnd)) {
          // 리스트에 추가해준다.
          randomset.add(rnd);
        }

        // 리스트의 길이가 6이면 while문을 종료한다.
        if (randomset.length == resultController.cos_ingredients.length) break;
      }

      for (var idx in randomset) {
        resultController.ingredient
            .add(resultController.cos_ingredients[idx].getcosName());
        resultController.detail
            .add(resultController.cos_ingredients[idx].getcosDescription());
      }
    }

    // 피부 분석
    if (parsed["result"]["comments"] != null) {
      resultController.skinResultContent.clear();
      resultController.skinResultContent.add(parsed["result"]["comments"][0]);
      resultController.skinResultContent.add(parsed["result"]["comments"][1]);
      resultController.skinResultContent.add(parsed["result"]["comments"][2]);
    }

    // 스킨 루틴
    if (parsed["result"]["guides"] != null) {
      resultController.routinecontent.clear();
      resultController.routinekeyword.clear();

      for (var g in parsed["result"]["guides"]) {
        resultController.routinecontent.add(g['guide']);
        resultController.routinekeyword.add(g['keyword']);
      }
    }

    await fetchWebSkinResult(resultController.type.value);

    return CODE_OK;
  } else {
    return "FAIL";
  }
}

fetchSurveyResultNo() async {
  print("fetchSurveyResultNo ");

  var resultController = Get.find<ResultController>(tag: "result");

  String temp = (dev_hidden_tap ? Dev_URL : URL) + '/survey/result';
  var url = Uri.parse(temp);
  var surveyCode = "j6lfDzst";
  var _query = <String, String>{
    'surveyCode': surveyCode,
  };

  url = url.replace(queryParameters: _query);

  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'x-skin-lab': (dev_hidden_tap ? access_Dev_Token : access_Token),
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];
  var result = parsed["result"];
  print(parsed);

  if (result_status == CODE_OK) {
    resultController.survey_id.value = surveyCode;
    // 점수
    resultController.type.value = parsed["result"]["skinType"];
    resultController.setData(
        parsed["result"]["scores"]["sens"].toInt(),
        parsed["result"]["scores"]["wrinkle"].toInt(),
        parsed["result"]["scores"]["moist"].toInt(),
        parsed["result"]["scores"]["oil"].toInt(),
        parsed["result"]["scores"]["pig"].toInt());
    // 화장품 성분
    if (resultController.ingredient.length == 0) {
      resultController.ingredient.clear();
      resultController.detail.clear();
      var _temp_ingredientList = [];
      var _ingre_check = [];
      var cosSize = result["cosmeticComponentList"].length;
      for (int i = 0; i < cosSize; i++) {
        var cosmeticIngredientList =
            result["cosmeticComponentList"][i]["cosmeticIngredientList"];
        for (var item in cosmeticIngredientList) {
          CosmeticData data = new CosmeticData();
          if (!_ingre_check.contains(item["name"])) {
            _ingre_check.add(item["name"]);
            data.setCosmeticData(item["name"], item["description"]);
            _temp_ingredientList.add(data);
          }
        }
      }
      print(_temp_ingredientList);
      resultController.cos_ingredients.value = _temp_ingredientList;
      var randomset = [];
      while (true) {
        // 랜덤으로 번호를 생성해준다.
        var rnd = Random().nextInt(resultController.cos_ingredients.length);

        // 만약 리스트에 생성된 번호가 없다면
        if (!randomset.contains(rnd)) {
          // 리스트에 추가해준다.
          randomset.add(rnd);
        }

        // 리스트의 길이가 6이면 while문을 종료한다.
        if (randomset.length == 6) break;
      }

      for (var idx in randomset) {
        resultController.ingredient
            .add(resultController.cos_ingredients[idx].getcosName());
        resultController.detail
            .add(resultController.cos_ingredients[idx].getcosDescription());
      }
    }

    // 피부 분석
    if (parsed["result"]["comments"] != null) {
      resultController.skinResultContent.clear();
      resultController.skinResultContent.add(parsed["result"]["comments"][0]);
      resultController.skinResultContent.add(parsed["result"]["comments"][1]);
      resultController.skinResultContent.add(parsed["result"]["comments"][2]);
    }

    // 스킨 루틴
    if (parsed["result"]["guides"] != null) {
      resultController.routinecontent.clear();
      resultController.routinekeyword.clear();

      for (var g in parsed["result"]["guides"]) {
        resultController.routinecontent.add(g['guide']);
        resultController.routinekeyword.add(g['keyword']);
      }
    }

    await fetchWebSkinResult(resultController.type.value);
    Get.offAll(SkinResult(), transition: Transition.rightToLeftWithFade);
    return CODE_OK;
  } else {
    return "FAIL";
  }
}

Future<void> createUserDocument(
    {required ResultController resultController,
    required bool onlysurvey}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int randomNumber = math.Random().nextInt(1001); // Random number between 0
  // and 100
  String documentName = resultController.name.value + '$randomNumber';
  resultController.user_id.value = documentName;
  var name = resultController.name.value;
  var aestheticId = resultController.aestheticId.value;
  var age = resultController.age.value;
  var sex = resultController.gender.value == Gender.M ? "M" : "W";
  var survey_id = resultController.survey_id.value;
  var date = DateTime.now().toString();

  // Append random number to 'user_name'

  await firestore.collection('users').doc(documentName).set({
    'name': name,
    'aestheticId': aestheticId,
    'age': age,
    'sex': sex,
    'survey_id': survey_id,
    'date': date,
    'user_id': documentName,
    'onlysurvey': onlysurvey,
  });
  print('Document created with name: $documentName');
  return;
}

Future<void> createSkinMeasurements(resultController) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int randomNumber = math.Random().nextInt(10001); // Random number between 0
  String machineName = resultController.aestheticId.value + '$randomNumber';
  var user_id = resultController.user_id.value;
  var water_machine = resultController.water_machine.value;
  var oil_machine = resultController.oil_machine.value;
  var wrinkle_machine = resultController.wrinkle_machine.value;
  var pore_machine = resultController.pore_machine.value;
  var corneous_machine = resultController.corneous_machine.value;
  var blemishes_machine = resultController.blemishes_machine.value;
  var sebum_machine = resultController.sebum_machine.value;
  var date = DateTime.now().toString();

  // Append random number to 'user_name'

  await firestore.collection('skin_measurements').doc(machineName).set({
    'machineName': machineName,
    'user_id': user_id,
    'water_machine': water_machine,
    'oil_machine': oil_machine,
    'wrinkle_machine': wrinkle_machine,
    'pore_machine': pore_machine,
    'corneous_machine': corneous_machine,
    'blemishes_machine': blemishes_machine,
    'sebum_machine': sebum_machine,
    'date': date,
  });
  print('Document created with name: $machineName');
  return;
}

Future<void> createSkinScope(resultController) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user_id = resultController.user_id.value;
  var survey_id = resultController.survey_id.value;
  var scope_id = resultController.scope_id;
  List<String> leftLedList = resultController.left_led_list;
  List<String> rightLedList = resultController.right_led_list;
  List<String> headLedList = resultController.head_led_list;
  List<String> leftUvList = resultController.left_uv_list;
  List<String> rightUvList = resultController.right_uv_list;
  List<String> headUvList = resultController.head_uv_list;

  // 쉼표로 구분된 문자열을 만들기
  // 예: ['urlA', 'urlB', ...] -> "urlA,urlB"
  String leftLedListString = leftLedList.join(',');
  String rightLedListString = rightLedList.join(',');
  String headLedListString = headLedList.join(',');
  String leftUvListString = leftUvList.join(',');
  String rightUvListString = rightUvList.join(',');
  String headUvListString = headUvList.join(',');
  // var leftLed = resultController.left_led;
  // var rightLed = resultController.right_led;
  // var headLed = resultController.head_led;
  // var leftUv = resultController.left_uv;
  // var rightUv = resultController.right_uv;
  // var headUv = resultController.head_uv;
  var date = DateTime.now().toString();

  // Append random number to 'user_name'
  print(scope_id);

  await firestore.collection('skin_microscope_images').doc(scope_id).set({
    'user_id': user_id,
    'leftLed': leftLedListString,
    'rightLed': rightLedListString,
    'headLed': headLedListString,
    'leftUv': leftUvListString,
    'rightUv': rightUvListString,
    'headUv': headUvListString,
    'date': date,
    'survey_id': survey_id,
  });
  await createUserDocument(
      resultController: resultController, onlysurvey: false);
  print('Document created with name: $scope_id');
  return;
}

fetchWebSkinResult(skincode) async {
  // return;
  print("fetchWebSkinResult ");

  var resultController = Get.find<ResultController>(tag: "result");


  String baseUrl = web_skin_result; // URL 설정
  final LocaleController localeController = Get.find();
  await localeController.loadLocale();

  String languageParam;
  // LocaleController에서 현재 설정된 Locale에 따라 언어 문자열 결정
  if (localeController.locale.value == Locale('ko', 'KR')) {
    languageParam = 'Korean';
  } else if (localeController.locale.value == Locale('en', 'US')) {
    languageParam = 'English';
  } else {
    languageParam = 'Korean'; // 기본값 설정
  }

  var url = Uri.parse(baseUrl);

  // 쿼리 파라미터에 언어 설정 추가
  var _query = <String, String>{
    'skintype': skincode,
    'language': languageParam, // 언어 파라미터 추가
  };

  url = url.replace(queryParameters: _query);

  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];
  print(parsed);
  print(result_status);

  if (result_status == CODE_OK) {
    // 'comment'와 'ingre' 데이터 저장
    resultController.skinResultWebContent =
        List<String>.from(parsed["comment"]);
    resultController.skinResultWebIngre = List<List<String>>.from(
        parsed["ingre"].map((ingre) => List<String>.from(ingre)));

    print('Skin Result Web Content: ${resultController.skinResultWebContent}');
    print(
        'Skin Result Web Ingredients: ${resultController.skinResultWebIngre}');

    return CODE_OK;
  } else {
    return "FAIL";
  }
}

/// 예시: 람다에 old & new(uv_list, led_list) 값 전달
/// Lambda 응답에서 conf_result, label 등을 받아 Map 형태로 반환
Future<Map<String, dynamic>> fetchCalculateAI({
  required String survey_id,
  required List<String> uvList, // ["s3://...uv_1.jpg", ...]
  required List<String> ledList, // ["s3://...led_1.jpg", ...]
}) async {
  final lambdaUrl = web_calculate_url; // 실제 URL

  // 1) 요청 JSON
  final requestData = {
    "survey_id": survey_id,
    "uv_list": uvList,
    "led_list": ledList
  };
  print("requestData");

  try {
    // 2) POST
    print(requestData);
    final response = await http.post(
      Uri.parse(lambdaUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );
    print(response);

    if (response.statusCode == 202) {
      // 3) 람다 응답 파싱
      final outerJson = jsonDecode(response.body);
      print(outerJson);
      // if (outerJson["statusCode"] != 202) {
      //   throw Exception("Lambda error: ${outerJson['statusCode']}");
      // }

      var job_id = outerJson["job_id"];
      print(job_id);

      return {
        "job_id": job_id
        // "oil": newOil,
        // "pig": newPig,
        // "sens": newSens,
        // "water": newWater,
        // "wrinkle": newWrinkle,
        // "oil_label": oilLabel,
        // "pig_label": pigLabel,
        // "sens_label": sensLabel,
        // "water_label": waterLabel,
        // "wrinkle_label": wrinkleLabel,
      };
    } else {
      throw Exception("HTTP error: ${response.statusCode}");
    }
  } catch (e) {
    print("fetchCalculateAI error: $e");

    Get.dialog(NetworkErrorDialog());
    rethrow; // or return {}
  }
}

Future<Map<String, dynamic>> fetchCalculateAILookup(
    {required String job_id}) async {
  var lambdaUrl = web_calculate_lookup; // 실제 URL

  var url = Uri.parse(lambdaUrl);

  // 쿼리 파라미터에 언어 설정 추가
  var _query = <String, String>{
    "job_id": job_id,
  };

  url = url.replace(queryParameters: _query);

  try {
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // JSON 파싱
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      String status = (jsonData["status"] ?? "") as String;

      if(status == "DONE") {
        // 상위 필드들
        double createdAt = (jsonData["createdAt"] ?? 0).toDouble();
        double finishedAt = (jsonData["finishedAt"] ?? 0).toDouble();
        String jobId = (jsonData["job_id"] ?? "") as String;
        String surveyId = (jsonData["survey_id"] ?? "") as String;

        // result 객체
        final resultMap = jsonData["result"] as Map<String, dynamic>?;

        if (resultMap != null) {
          String waterLabel = resultMap["water_label"] ?? "";
          String oilLabel = resultMap["oil_label"] ?? "";
          double waterConf = (resultMap["water_conf_result"] ?? 0).toDouble();
          double sensConf = (resultMap["sens_conf_result"] ?? 0).toDouble();
          String wrinkleLabel = resultMap["wrinkle_label"] ?? "";
          double wrinkleConf = (resultMap["wrinkle_conf_result"] ?? 0)
              .toDouble();
          double pigConf = (resultMap["pig_conf_result"] ?? 0).toDouble();
          String pigLabel = resultMap["pig_label"] ?? "";
          String sensLabel = resultMap["sens_label"] ?? "";
          double oilConf = (resultMap["oil_conf_result"] ?? 0).toDouble();

          // 이제 이 변수들을 원하는 곳에 저장 or setState로 UI 갱신
          print("createdAt: $createdAt");
          print("finishedAt: $finishedAt");
          print("jobId: $jobId");
          print("surveyId: $surveyId");
          print("status: $status");

          print("===== Result Map =====");
          print("waterLabel: $waterLabel");
          print("oilLabel: $oilLabel");
          print("waterConf: $waterConf");
          print("sensConf: $sensConf");
          print("wrinkleLabel: $wrinkleLabel");
          print("wrinkleConf: $wrinkleConf");
          print("pigConf: $pigConf");
          print("pigLabel: $pigLabel");
          print("sensLabel: $sensLabel");
          print("oilConf: $oilConf");

          return {
            "status": status,
            "job_id": job_id,
            "oil": oilConf,
            "pig": pigConf,
            "sens": sensConf,
            "water": waterConf,
            "wrinkle": wrinkleConf,
            "oil_label": oilLabel,
            "pig_label": pigLabel,
            "sens_label": sensLabel,
            "water_label": waterLabel,
            "wrinkle_label": wrinkleLabel,
          };
        } else {
          // resultMap == null 인 경우
          print("No result field in JSON");
          // 빈 맵 반환 or throw
          return {};
        }
      }
      else if(status =="IN_PROGRESS"){
        return {
          "status" : status
        };
      }
      else{
        return {};
      }
    } else {
      print("fetchCalculateAILookup error: status=${response.statusCode}");
      // 에러이지만 빈 맵 반환
      return {};
    }
  } catch (e) {
    print("fetchCalculateAILookup error: $e");
    Get.dialog(NetworkErrorDialog());
    rethrow; // or return {}
  }
}

fetchSetSurveyResult(surveyCode) async {
  print("fetchSetSurveyResult ");

  var resultController = Get.find<ResultController>(tag: "result");
  //
  // String temp = (dev_hidden_tap ? Dev_URL : URL) + '/survey/result';
  // var url = Uri.parse(temp);
  // //var surveyCode = j6lfDzst;
  // var _query = <String, String>{
  //   'surveyCode': surveyCode,
  // };
  //
  // url = url.replace(queryParameters: _query);

  String baseUrl = dev_hidden_tap ? Dev_URL : URL; // URL 설정
  final LocaleController localeController = Get.find();
  await localeController.loadLocale();
  Locale? currentLocale = localeController.locale.value;
  String languageParam = getLanguageParamFromLocale(currentLocale);
  String temp = '$baseUrl/survey/result';
  var url = Uri.parse(temp);

  // 쿼리 파라미터에 언어 설정 추가
  var _query = <String, String>{
    'surveyCode': surveyCode,
    'language': languageParam, // 언어 파라미터 추가
  };

  url = url.replace(queryParameters: _query);

  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'x-skin-lab': (dev_hidden_tap ? access_Dev_Token : access_Token),
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];
  var result = parsed["result"];
  print(parsed);

  if (result_status == CODE_OK) {
    resultController.survey_id.value = surveyCode;
    // 점수
    resultController.type.value = parsed["result"]["skinType"];
    resultController.setData(
        parsed["result"]["scores"]["sens"].toInt(),
        parsed["result"]["scores"]["wrinkle"].toInt(),
        parsed["result"]["scores"]["moist"].toInt(),
        parsed["result"]["scores"]["oil"].toInt(),
        parsed["result"]["scores"]["pig"].toInt());
    // 화장품 성분
    if (resultController.ingredient.length == 0) {
      resultController.ingredient.clear();
      resultController.detail.clear();
      var _temp_ingredientList = [];
      var _ingre_check = [];
      var cosSize = result["cosmeticComponentList"].length;
      for (int i = 0; i < cosSize; i++) {
        var cosmeticIngredientList =
            result["cosmeticComponentList"][i]["cosmeticIngredientList"];
        for (var item in cosmeticIngredientList) {
          CosmeticData data = new CosmeticData();
          if (!_ingre_check.contains(item["name"])) {
            _ingre_check.add(item["name"]);
            data.setCosmeticData(item["name"], item["description"]);
            _temp_ingredientList.add(data);
          }
        }
      }
      print(_temp_ingredientList);
      resultController.cos_ingredients.value = _temp_ingredientList;
      var randomset = [];
      while (true) {
        // 랜덤으로 번호를 생성해준다.
        var rnd = Random().nextInt(resultController.cos_ingredients.length);

        // 만약 리스트에 생성된 번호가 없다면
        if (!randomset.contains(rnd)) {
          // 리스트에 추가해준다.
          randomset.add(rnd);
        }

        // 리스트의 길이가 6이면 while문을 종료한다.
        if (randomset.length == resultController.cos_ingredients.length) break;
      }

      for (var idx in randomset) {
        resultController.ingredient
            .add(resultController.cos_ingredients[idx].getcosName());
        resultController.detail
            .add(resultController.cos_ingredients[idx].getcosDescription());
      }
    }

    // 피부 분석
    if (parsed["result"]["comments"] != null) {
      resultController.skinResultContent.clear();
      resultController.skinResultContent.add(parsed["result"]["comments"][0]);
      resultController.skinResultContent.add(parsed["result"]["comments"][1]);
      resultController.skinResultContent.add(parsed["result"]["comments"][2]);
      print(resultController.skinResultContent);
    }

    // 스킨 루틴
    if (parsed["result"]["guides"] != null) {
      resultController.routinecontent.clear();
      resultController.routinekeyword.clear();

      for (var g in parsed["result"]["guides"]) {
        resultController.routinecontent.add(g['guide']);
        resultController.routinekeyword.add(g['keyword']);
      }
    }

    return CODE_OK;
  } else {
    return "FAIL";
  }
}



fetchWebSkinTypeResult(skintype) async {
  // return;

  print("[DEBUG]` fetchWebSkinTypeResult");
  print("fetchWebSkinTypeResult ");

  var resultController = Get.find<ResultController>(tag: "result");


  String baseUrl = web_survey_result; // URL 설정
  final LocaleController localeController = Get.find();
  await localeController.loadLocale();

  print("[DEBUG]` loadLocale");

  String languageParam;
  // LocaleController에서 현재 설정된 Locale에 따라 언어 문자열 결정
  if (localeController.locale.value == Locale('ko', 'KR')) {
    languageParam = 'KOR';
  } else if (localeController.locale.value == Locale('en', 'US')) {
    languageParam = 'ENG';
  } else {
    languageParam = 'KOR'; // 기본값 설정
  }

  var url = Uri.parse(baseUrl);

  // 쿼리 파라미터에 언어 설정 추가
  var _query = <String, String>{
    'skinType': skintype,
    'language': languageParam, // 언어 파라미터 추가
  };

  url = url.replace(queryParameters: _query);

  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];
  print("fetchWebSkinTypeResult : $parsed");
  print(result_status);

  if (result_status == CODE_OK) {

    // 화장품 성분
    if (resultController.ingredient.length == 0) {
      resultController.ingredient.clear();
      resultController.detail.clear();
      var _temp_ingredientList = [];
      var _ingre_check = [];
      var cosSize = parsed["result"]["cosmeticComponentList"].length;
      for (int i = 0; i < cosSize; i++) {
        var cosmeticIngredientList =
        parsed["result"]["cosmeticComponentList"][i]["cosmeticIngredientList"];
        for (var item in cosmeticIngredientList) {
          CosmeticData data = new CosmeticData();
          if (!_ingre_check.contains(item["name"])) {
            _ingre_check.add(item["name"]);
            data.setCosmeticData(item["name"], item["description"]);
            _temp_ingredientList.add(data);
          }
        }
      }
      print(_temp_ingredientList);
      resultController.cos_ingredients.value = _temp_ingredientList;
      var randomset = [];
      while (true) {
        // 랜덤으로 번호를 생성해준다.
        var rnd = Random().nextInt(resultController.cos_ingredients.length);

        // 만약 리스트에 생성된 번호가 없다면
        if (!randomset.contains(rnd)) {
          // 리스트에 추가해준다.
          randomset.add(rnd);
        }

        // 리스트의 길이가 6이면 while문을 종료한다.
        if (randomset.length == 6) break;
      }

      for (var idx in randomset) {
        resultController.ingredient
            .add(resultController.cos_ingredients[idx].getcosName());
        resultController.detail
            .add(resultController.cos_ingredients[idx].getcosDescription());
      }
    }

    // 피부 분석
    if (parsed["result"]["comments"] != null) {
      resultController.skinResultContent.clear();
      resultController.skinResultContent.add(parsed["result"]["comments"][0]);
      resultController.skinResultContent.add(parsed["result"]["comments"][1]);
      resultController.skinResultContent.add(parsed["result"]["comments"][2]);
    }

    // 스킨 루틴
    if (parsed["result"]["guides"] != null) {
      resultController.routinecontent.clear();
      resultController.routinekeyword.clear();

      for (var g in parsed["result"]["guides"]) {
        resultController.routinecontent.add(g['guide']);
        resultController.routinekeyword.add(g['keyword']);
      }
    }
    // // 'comment'와 'ingre' 데이터 저장
    // resultController.skinResultWebContent =
    // List<String>.from(parsed["comment"]);

    print('Skin Result Web Content: ${resultController.skinResultWebContent}');
    print('Skin Result Web Ingredients: ${resultController.skinResultWebIngre}');

    return CODE_OK;
  } else {
    return "FAIL";
  }
}