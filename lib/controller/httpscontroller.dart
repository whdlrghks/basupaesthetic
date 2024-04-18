import 'dart:math';

import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:basup_ver2/data/cosmeticdata.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:basup_ver2/pages/skinresult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'resultcontroller.dart';

Future<String> fetchGetSurvey(type) async {
  print("fetchGetSurvey ");
  String temp = (dev_hidden_tap ? Dev_URL : URL) + '/survey';
  var url = Uri.parse(temp);

  var _query = <String, String>{
//    'version': "0.2",
    'type': type.toString(),
    'version': "0.1",
  };

  url = url.replace(queryParameters: _query);

  print(url);

  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'x-skin-lab': ( access_Dev_Token ),
      'Accept': '*/*',
      'Access-Control-Allow-Headers': '*',
    },
  );

  final decodeData = utf8.decode(response.bodyBytes);
  final parsed = json.decode(decodeData).cast<String, dynamic>();

  var result_status = parsed["resCode"];

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
    resultController.survey_id.value = parsed["result"]["surveyCode"];
    await createUserDocument(resultController);
    Get.toNamed("/index?userid="+resultController.user_id.value);
    return CODE_OK;
  } else {
    print("Fail to login");
    //인증 실패
    //다시 로그인해야함.
    return "FAIL";
  }
}





fetchSurveyResult(surveyCode) async {
  print("fetchSurveyResult ");

  var resultController = Get.find<ResultController>(tag: "result");

  String temp = (dev_hidden_tap ? Dev_URL : URL) + '/survey/result';
  var url = Uri.parse(temp);
  //var surveyCode = j6lfDzst;
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
    if(parsed["result"]["comments"] != null){
      resultController.skinResultContent.clear();
      resultController.skinResultContent.add(parsed["result"]["comments"][0]);
      resultController.skinResultContent.add(parsed["result"]["comments"][1]);
      resultController.skinResultContent.add(parsed["result"]["comments"][2]);

    }

    // 스킨 루틴
    if(parsed["result"]["guides"] != null){
      resultController.routinecontent.clear();
      resultController.routinekeyword.clear();

      for (var g in parsed["result"]["guides"]){
        resultController.routinecontent.add(g['guide']);
        resultController.routinekeyword.add(g['keyword']);
      }

    }



    return CODE_OK;
  } else {
    return "FAIL";
  }
}

fetchSurveyResultNo() async {
  print("fetchSurveyResult ");

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
    if(parsed["result"]["comments"] != null){
      resultController.skinResultContent.clear();
      resultController.skinResultContent.add(parsed["result"]["comments"][0]);
      resultController.skinResultContent.add(parsed["result"]["comments"][1]);
      resultController.skinResultContent.add(parsed["result"]["comments"][2]);
    }

    // 스킨 루틴
    if(parsed["result"]["guides"] != null){
      resultController.routinecontent.clear();
      resultController.routinekeyword.clear();

      for (var g in parsed["result"]["guides"]){
        resultController.routinecontent.add(g['guide']);
        resultController.routinekeyword.add(g['keyword']);
      }

    }


    Get.offAll(SkinResult(), transition: Transition.rightToLeftWithFade);
    return CODE_OK;
  } else {
    return "FAIL";
  }
}

Future<void> createUserDocument(resultController) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int randomNumber = math.Random().nextInt(101); // Random number between 0 and 100
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
    'age' : age,
    'sex' : sex,
    'survey_id' : survey_id,
    'date' : date,
    'user_id' : documentName,
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
    'water_machine' : water_machine,
    'oil_machine' : oil_machine,
    'wrinkle_machine' : wrinkle_machine,
    'pore_machine': pore_machine,
    'corneous_machine' : corneous_machine,
    'blemishes_machine' : blemishes_machine,
    'sebum_machine' : sebum_machine,
    'date' : date,
  });
  print('Document created with name: $machineName');
  return;
}


Future<void> createSkinScope(resultController) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user_id = resultController.user_id.value;
  var scope_id = resultController.scope_id;

  var leftLed = resultController.left_led;
  var rightLed = resultController.right_led;
  var headLed = resultController.head_led;
  var leftUv = resultController.left_uv;
  var rightUv = resultController.right_uv;
  var headUv = resultController.head_uv;
  var date = DateTime.now().toString();

  // Append random number to 'user_name'
  print(scope_id);

  await firestore.collection('skin_microscope_images').doc(scope_id).set({
    'user_id': user_id,
    'leftLed' : leftLed,
    'rightLed' : rightLed,
    'headLed' : headLed,
    'leftUv': leftUv,
    'rightUv' : rightUv,
    'headUv' : headUv,
    'date' : date,
  });
  print('Document created with name: $scope_id');
  return;
}