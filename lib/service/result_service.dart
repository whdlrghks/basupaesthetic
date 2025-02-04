// survey_service.dart

import 'dart:async';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/service/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// 필요에 따라 http, math, etc. 임포트
// import 'package:http/http.dart' as http;

import '../controller/resultcontroller.dart';
import '../pages/dialog.dart'; // 예시: NetworkErrorDialog 등이 있다면

/// 이 파일에서는 refreshSurvey 내부의 다양한 단계별 로직 + 헬퍼 메서드를 담당

class ResultService {
  final ResultController resultController;

  // 필요한 의존성(예: DB, HTTP 클라이언트) 등을 주입받을 수도 있음
  ResultService({required this.resultController});

  /// Main Entry: refreshSurvey
  /// userName, aestheticId로 Firestore에서 surveyId를 찾고,
  /// 없으면 종료 / 있으면 스킨/마이크로스코프 데이터 비교 후 처리
  Future<void> refreshSurvey(String userName, String aestheticId) async {
    // 1) users collection => survey_id 가져오는 기존 로직
    final latestSurveyMap = await getLatestSurveyFromUsers(
      resultController,
      userName,
      aestheticId,
    );

    if (latestSurveyMap == null) {
      print("No survey record found in users collection");
      return;
    }

    final surveyId = latestSurveyMap['survey_id'] ?? "";
    if (surveyId.isEmpty) {
      print("No survey_id found in users collection");
      return;
    }

    // onlySurvey == true면, 마이크로스코프나 머신데이터 없이 설문 결과만 처리
    final onlySurvey = latestSurveyMap['onlysurvey'] == true;
    if (onlySurvey) {
      await fetchOnlySurveyResult(surveyId);
      return;
    }

    // (A) 설문 + 스킨데이터 + 마이크로스코프 모두 체크
    final skinDataList = await getSkinDataList(surveyId);
    final microscopeList = await getMicroscopeList(surveyId);

    if (skinDataList.isNotEmpty) {
      final latestSkinDataDoc = skinDataList[0];
      final skinDataTime = parseDateTime(latestSkinDataDoc['date']);

      if (microscopeList.isNotEmpty) {
        final latestMicroDoc = microscopeList[0];
        final microTime = parseDateTime(latestMicroDoc['date']);

        // (C-1) 마이크로스코프가 더 최신
        if (microTime.isAfter(skinDataTime)) {
          print("** microscope is newer => Step 5 **");
          await handleMicroscopeIsNewer(
            surveyId: surveyId,
            oldSkinDoc: latestSkinDataDoc,
            latestMicroscopeDoc: latestMicroDoc,
          );
        } else {
          // (C-2) 스킨데이터가 더 최신 => Step 6
          print("** skinData is newer => Step 6 **");
          await handleSkinDataIsNewer(latestSkinDataDoc);
        }
      } else {
        // 마이크로스코프가 없으면 스킨데이터가 최신
        await handleSkinDataIsNewer(latestSkinDataDoc);
      }
    }
    else {
      // 스킨데이터가 없음 -> 마이크로스코프만 있는지 확인
      if (microscopeList.isNotEmpty) {
        print("** Only microscope data => Step 5**");
        final latestMicroDoc = microscopeList[0];
        // 기존코드: fetchSetSurveyResult(surveyId) 등 필요 시 호출
        await fetchSetSurveyResult(surveyId);

        await handleMicroscopeIsNewerNoSkinData(
          surveyId: surveyId,
          latestMicroscopeDoc: latestMicroDoc,
        );
      } else {
        // 둘 다 없음 -> 아무것도 할 것 없음
        print("No skinData & no microscope => Nothing to do");
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPER METHODS (AI 폴링, 혼합 계산, Firestore 저장, Web 결과 가져오기)
  // ─────────────────────────────────────────────────────────────────────────

  DateTime parseDateTime(dynamic field) {
    if (field is Timestamp) {
      return field.toDate();
    } else if (field is String) {
      return DateTime.parse(field);
    } else {
      throw Exception("Unsupported date format: $field");
    }
  }

  Future<void> handleMicroscopeIsNewer({
    required String surveyId,
    required Map<String, dynamic> oldSkinDoc,
    required Map<String, dynamic> latestMicroscopeDoc,
  }) async {
    // (1) 기존 측정값
    final oilOld = oldSkinDoc['oil'];
    final pigOld = oldSkinDoc['pig'];
    final sensOld = oldSkinDoc['sens'];
    final waterOld = oldSkinDoc['water'];
    final wrinkleOld = oldSkinDoc['wrinkle'];

    // (2) microscope images
    final headLed = latestMicroscopeDoc['headLed'];
    final leftLed = latestMicroscopeDoc['leftLed'];
    final rightLed = latestMicroscopeDoc['rightLed'];
    final headUv = latestMicroscopeDoc['headUv'];
    final leftUv = latestMicroscopeDoc['leftUv'];
    final rightUv = latestMicroscopeDoc['rightUv'];

    // (3) AI request + poll
    final requestJobId = await fetchCalculateAI(
      survey_id: surveyId,
      uvList: [headUv, leftUv, rightUv],
      ledList: [headLed, leftLed, rightLed],
    );

    final newlyCalculated = await pollAiJobResult(requestJobId["job_id"]);
    if (newlyCalculated == null) {
      print("AI polling timed out => No DONE");
      // 네트워크 에러 다이얼로그
      Get.dialog(NetworkErrorDialog());
      return;
    }

    // (4) 혼합 계산
    final finalOil = oilOld * 0.6 + newlyCalculated['oil'] * 0.4;
    final finalPig = pigOld * 0.6 + newlyCalculated['pig'] * 0.4;
    final finalSens = getFinalSens(sensOld, newlyCalculated['sens']);
    final finalWater = waterOld * 0.6 + newlyCalculated['water'] * 0.4;
    final finalWrinkle = wrinkleOld * 0.6 + newlyCalculated['wrinkle'] * 0.4;

    // (5) resultController에 저장
    resultController.setData(
      finalSens,
      finalWrinkle.toInt(),
      finalWater.toInt(),
      finalOil.toInt(),
      finalPig.toInt(),
    );

    // (6) skintype 계산 & Firestore 저장
    final newSkinType = computeSkinType(
      sens: finalSens,
      pig: finalPig.toInt(),
      wrinkle: finalWrinkle.toInt(),
      oil: finalOil.toInt(),
      water: finalWater.toInt(),
    );

    await saveNewSkinDataDoc(
      surveyId: surveyId,
      oil: finalOil.toInt(),
      pig: finalPig.toInt(),
      sens: finalSens,
      water: finalWater.toInt(),
      wrinkle: finalWrinkle.toInt(),
      skintype: newSkinType,
    );

    // (7) 최종 웹 결과 fetch
    await handleFetchWebResult(surveyId);
  }

  Future<void> handleMicroscopeIsNewerNoSkinData({
    required String surveyId,
    required Map<String, dynamic> latestMicroscopeDoc,
  }) async {
    // (1) old(구) 측정은 Controller에서
    final oilOld = resultController.oilper;
    final pigOld = resultController.pigper;
    final sensOld = resultController.sensper;
    final waterOld = resultController.waterper;
    final wrinkleOld = resultController.tightper;

    // (2) microscope images
    final headLed = latestMicroscopeDoc['headLed'];
    final leftLed = latestMicroscopeDoc['leftLed'];
    final rightLed = latestMicroscopeDoc['rightLed'];
    final headUv = latestMicroscopeDoc['headUv'];
    final leftUv = latestMicroscopeDoc['leftUv'];
    final rightUv = latestMicroscopeDoc['rightUv'];

    // (3) AI request + poll
    final requestJobId = await fetchCalculateAI(
      survey_id: surveyId,
      uvList: [headUv, leftUv, rightUv],
      ledList: [headLed, leftLed, rightLed],
    );
    final newlyCalculated = await pollAiJobResult(requestJobId["job_id"]);
    if (newlyCalculated == null) {
      print("AI polling timed out => No DONE");
      return;
    }

    // (4) 혼합 계산
    final finalOil = oilOld * 0.6 + newlyCalculated['oil'] * 0.4;
    final finalPig = pigOld * 0.6 + newlyCalculated['pig'] * 0.4;
    final finalSens = getFinalSens(sensOld, newlyCalculated['sens']);
    final finalWater = waterOld * 0.6 + newlyCalculated['water'] * 0.4;
    final finalWrinkle = wrinkleOld * 0.6 + newlyCalculated['wrinkle'] * 0.4;

    // (5) resultController에 반영
    resultController.setData(
      finalSens,
      finalWrinkle.toInt(),
      finalWater.toInt(),
      finalOil.toInt(),
      finalPig.toInt(),
    );

    // (6) skintype 계산 & Firestore 저장
    final newSkinType = computeSkinType(
      sens: finalSens,
      pig: finalPig.toInt(),
      wrinkle: finalWrinkle.toInt(),
      oil: finalOil.toInt(),
      water: finalWater.toInt(),
    );
    await saveNewSkinDataDoc(
      surveyId: surveyId,
      oil: finalOil.toInt(),
      pig: finalPig.toInt(),
      sens: finalSens,
      water: finalWater.toInt(),
      wrinkle: finalWrinkle.toInt(),
      skintype: newSkinType,
    );

    // (7) 웹 결과 fetch
    await handleFetchWebResult(surveyId);
  }

  Future<void> handleSkinDataIsNewer(Map<String, dynamic> latestSkinDataDoc) async {
    final oilOld = latestSkinDataDoc['oil'];
    final pigOld = latestSkinDataDoc['pig'];
    final sensOld = latestSkinDataDoc['sens'];
    final waterOld = latestSkinDataDoc['water'];
    final wrinkleOld = latestSkinDataDoc['wrinkle'];
    final finalSkintype = latestSkinDataDoc['skintype'];

    // Controller 반영
    resultController.setData(
      sensOld,
      wrinkleOld,
      waterOld,
      oilOld,
      pigOld,
    );
    resultController.type.value = finalSkintype;

    // 바로 웹 결과 호출
    print("[DEBUG]`before  fetchWebSkinTypeResult");
    await fetchWebSkinTypeResult(finalSkintype);
    print("[DEBUG]`before  fetchWebSkinResult");
    await fetchWebSkinResult(finalSkintype);
  }

  /// Firestore에 새 데이터 저장 후, 다시 조회 → skintype으로 웹 결과까지 호출
  Future<void> handleFetchWebResult(String surveyId) async {
    final newDocs = await getSkinDataList(surveyId);
    if (newDocs.isEmpty) {
      print("No new skinData found for $surveyId");
      return;
    }
    final latestDoc = newDocs[0];
    final finalSkintype = latestDoc['skintype'];
    resultController.type.value = finalSkintype;

    await createUserDocument(resultController: resultController, onlysurvey: false);
    await fetchWebSkinTypeResult(finalSkintype);
    await fetchWebSkinResult(finalSkintype);
  }

  /// AI Job Lookup (30초간격 x 10회 = 최대 5분)
  Future<Map<String, dynamic>?> pollAiJobResult(String jobId) async {
    const int maxChecks = 10;

    await Future.delayed(const Duration(seconds: 20));
    for (int i = 0; i < maxChecks; i++) {
      final newlyCalculated = await fetchCalculateAILookup(job_id: jobId);
      if (newlyCalculated["status"] == "DONE") {
        print("AI job DONE => $newlyCalculated");
        return newlyCalculated;
      } else {
        print("AI IN_PROGRESS => retry after 20 seconds (i=$i)");
        await Future.delayed(const Duration(seconds: 20));
      }
    }
    return null;
  }
}

// 아래는 예시: getFinalSens, computeSkinType 등도 여기 두거나 별도 utils로 분리
int getFinalSens(int oldSens, double newSens) {
  double combined = oldSens * 0.6 + newSens * 0.4;
  if (combined >= 53) {
    return combined.toInt();
  } else {
    // combined < 53 → oldSens 혹은 newSens 중 53 이상이면 그 값, 둘 다 아니면 max
    if (oldSens >= 53) return oldSens;
    if (newSens >= 53) return newSens.toInt();
    return (oldSens > newSens) ? oldSens : newSens.toInt();
  }
}

String computeSkinType({
  required int sens,
  required int pig,
  required int wrinkle,
  required int oil,
  required int water,
}) {
  final sensType = sens > 50 ? 'R' : 'S';
  final pigType = pig >= 54 ? 'N' : 'P';
  final wrinkleType = wrinkle >= 54 ? 'T' : 'W';

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

  return sensType + pigType + wrinkleType + oilType + waterType;
}

// ──────────────────────────────────────────────────────────────────────────
// ※ getLatestSurveyFromUsers, getSkinDataList, getMicroscopeList,
//   fetchOnlySurveyResult, fetchCalculateAI, fetchCalculateAILookup,
//   fetchSetSurveyResult, fetchWebSkinTypeResult, fetchWebSkinResult,
//   createUserDocument, saveNewSkinDataDoc
// 등은 기존 코드대로 여기 있거나,
// 다른 서비스/파일로 나눌 수 있습니다.
// ──────────────────────────────────────────────────────────────────────────