

import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/data/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// In your firebase.dart file (create this file if you don't have it):
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'dart:js' as js;

@JS()
external bool get firebaseInitialized;

@JS()
@anonymous
class FirebaseApp {
  external static dynamic get app; // Add this line
}

@JS()
@anonymous
class AuthWeb {
  external dynamic currentUser;
  external dynamic onAuthStateChanged(Function(dynamic) observer);
  external dynamic signInAnonymously();
// ... other auth methods as needed
}

@JS()
@anonymous
class UserCredentialWeb {
  external dynamic user;
}

@JS()
@anonymous
class UserWeb {
  external dynamic uid;
// ... other user properties as needed
}
void logGlobalFirebaseVars() {
  print("Global firebase: ${js.context['firebase']}");
  print("Global firebaseInitialized: ${js.context['firebaseInitialized']}");
  print("Global firebaseauth: ${js.context['firebaseauth']}");
  print("Global signInAnonymouslyJS: ${js.context['signInAnonymouslyJS']}");
}

Future<void> initializeFirebaseInDart() async {
  while (!firebaseInitialized) {
    await Future.delayed(Duration(milliseconds: 100));
    print("Waiting for Firebase initialization...");
  }
  print("Firebase initialized!");
}

Future<dynamic> signInAnonymously() async {
  await initializeFirebaseInDart();
  // js.context['firebaseauth'] 대신, 전역에 정의된 signInAnonymouslyJS 함수를 호출합니다.
  try {
    final result = await promiseToFuture(js.context.callMethod('signInAnonymouslyJS'));
    return result;
  } catch (e) {
    print("Error signing in anonymously: $e");
    return null;
  }
}
Future<UserCredential?> signInAnonymouslyApp() async {
  try {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInAnonymously();
    return userCredential;
  } catch (e) {
    print("익명 로그인 에러: $e");
    return null;
  }
}


Future<Map<String, dynamic>?> getLatestSurveyFromUsers(ResultController
resultcontroller,
    String name, String
aestheticId) async {
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
  // SurveyEachItem 객체 리스트 생성
  List<SurveyEachItem> surveyItems = [];

  for (var doc in querySnapshot.docs) {
    final data = doc.data();

    // Firestore 필드명 가정: "date", "survey_id", "onlysurvey"
    final dateString = data['date'] ?? "";
    final surveyId = data['survey_id'] ?? "";
    final onlySurvey = data['onlysurvey'] ?? true;

    if (dateString.isNotEmpty && surveyId.isNotEmpty) {
      surveyItems.add(SurveyEachItem.fromMap(data));
    }
  }

  // date 필드를 DateTime으로 변환한 뒤 내림차순 정렬
  surveyItems.sort((a, b) {

    final dateA = _parseDate(a.date);
    final dateB = _parseDate(b.date);
    return dateB.compareTo(dateA); // 내림차순: 가장 최근이 맨 앞
  });

  if (surveyItems.isEmpty) {
    // date, survey_id가 하나도 없는 경우
    return null;
  }


  resultcontroller.surveylist = surveyItems;
  // 가장 최근 item (index 0)
  final latestItem = surveyItems.first;
  final latestSurveyDate = latestItem.date;
  final latestSurveyId = latestItem.surveyId;
  final onlysurvey = latestItem.onlysurvey;
  print("latestItem");
  print("latestSurveyDate : " + latestSurveyDate.toString());
  print("latestSurveyId : " + latestSurveyId.toString());
  print("onlysurvey : ");
  print(onlysurvey);

  // 필요한 형태로 반환
  return {
    'date': latestSurveyDate,
    'survey_id': latestSurveyId,
    'onlysurvey' : onlysurvey
  };
}


/// date 문자열을 DateTime으로 변환하는 헬퍼 함수
DateTime _parseDate(String dateString) {
  try {
    // Firestore 문서 필드가 문자열 "yyyy-MM-dd HH:mm:ss.SSS" 형태라면
    return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(dateString);
  } catch (e) {
    // 만약 형식이 다르다면 기본 파싱 시도
    return DateTime.parse(dateString);
  }
}
Future<void> saveNewSkinDataDoc({
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
    'water': water,
    'wrinkle': wrinkle,
    'skintype': skintype,
    'date': date
  });
}


Future<List<Map<String, dynamic>>> getSkinDataList(String surveyId) async {
  final query = await FirebaseFirestore.instance
      .collection('survey_id_skin_data')
      .where('survey_id', isEqualTo: surveyId)
      .get();
  // Firestore에서 가져온 문서들을 Map 형식으로 변환
  final docs = query.docs.map((doc) => doc.data()).toList();
  print("skindata docs");
  print(docs);

  // date 필드가 "yyyy-MM-dd HH:mm:ss" 식으로 저장돼 있다고 가정
  docs.sort((a, b) {
    final dateA = DateTime.parse(a['date']);
    final dateB = DateTime.parse(b['date']);
    return dateB.compareTo(dateA); // 내림차순: 가장 최근이 맨 앞
  });

  docs.forEach((element) { });

  return docs;
}



Future<List<Map<String, dynamic>>> getBeforeSkinDataList(String surveyId,
    String date)
async {
  final query = await FirebaseFirestore.instance
      .collection('survey_id_skin_data')
      .where('survey_id', isEqualTo: surveyId)
      .get();
  // Firestore에서 가져온 문서들을 Map 형식으로 변환
  final docs = query.docs.map((doc) => doc.data()).toList();
  print("skindata docs");
  print(docs);

  // 전달받은 date 문자열을 DateTime으로 변환 (예: "2025-02-12 14:56:11.772")
  final cutoff = DateTime.parse(date);

  // cutoff 이전의 date를 가진 문서들만 필터링
  final filteredDocs = docs.where((doc) {
    final docDate = DateTime.parse(doc['date']);
    return docDate.isBefore(cutoff);
  }).toList();

  // 내림차순 정렬: 가장 최근의 문서가 맨 앞에 오도록
  filteredDocs.sort((a, b) {
    final dateA = DateTime.parse(a['date']);
    final dateB = DateTime.parse(b['date']);
    return dateB.compareTo(dateA);
  });

  return filteredDocs;
}


Future<List<Map<String, dynamic>>> getMicroscopeList(String surveyId) async {
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


Future<void> checkRecentData(ResultController
resultcontroller, String userId) async {
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
