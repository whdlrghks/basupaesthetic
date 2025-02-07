import 'package:basup_ver2/component/languagepickerwidget.dart';
import 'package:basup_ver2/controller/authcontroller.dart';
import 'package:basup_ver2/controller/localecontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sessionmanager.dart';
import 'package:basup_ver2/pages/customerslistpage.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// (불필요한 import 제거: 예) index.dart 등 현재 안 쓰는 파일)

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController       = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GetX Controller
  final resultController = Get.find<ResultController>(tag: "result");

  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// 이미 로그인 상태인지 확인
  void _checkLoginStatus() async {
    bool isLoggedIn = await SessionManager.getLoginStatus();
    if (isLoggedIn) {
      // 이미 로그인: aestheticId 불러와서 바로 CustomersListPage 이동
      String? id = await SessionManager.getLoginaestheticId();
      if (id != null && id.isNotEmpty) {
        Future.microtask(() =>
            Get.offAll(CustomersListPage(aestheticId: id))
        );
      }
      // else: 예외 처리 (로그인 정보가 없는데 isLoggedIn이 true인 경우)
    }
  }

  /// 로그인 버튼 클릭 시 호출
  Future<void> _login() async {
    final String shopId   = _idController.text.trim();
    final String password = _passwordController.text.trim();

    if (shopId.isEmpty || password.isEmpty) {
      Get.dialog(faillogindialog());
      return;
    }

    try {
      // Firestore 쿼리
      final querySnapshot = await fs.FirebaseFirestore.instance
          .collection('aesthetic')
          .where('id', isEqualTo: shopId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // 매칭되는 shopId 없음
        Get.dialog(faillogindialog());
        return;
      }

      // 문서가 존재하면 첫 번째 문서를 사용
      final doc    = querySnapshot.docs.first;
      final data   = doc.data() as Map<String, dynamic>;
      final dbPw   = data['pw'];   // Firestore에 저장된 비밀번호 (평문)

      if (dbPw == password) {
        // 비밀번호 일치 → 로그인 성공
        _applyLocaleSetting();
        await SessionManager.setLoginStatus(true, shopId);

        resultController.aestheticId.value = shopId;

        // SharedPreferences에 loginId 저장 (필요 시)
        await _saveLoginId(shopId);
        authController.checkLoginStatus();
        // 메인 페이지 혹은 리스트 페이지로 이동
        Get.offAll(CustomersListPage(aestheticId: shopId));
      } else {
        // 비밀번호 불일치
        Get.dialog(faillogindialog());
      }
    } catch (e) {
      // Firestore 조회 중 예외 발생
      print("Login error: $e");
      Get.dialog(faillogindialog());
    }
  }

  /// 언어 설정 (LocaleController)
  void _applyLocaleSetting() {
    final localeController = Get.find<LocaleController>();
    final currentLocale = localeController.locale.value;

    // 예: ko_KR, en_US 말고 다른 locale면 무조건 en_US로 처리
    if (currentLocale == const Locale('ko', 'KR')) {
      localeController.changeLocale('ko', 'KR');
    } else if (currentLocale == const Locale('en', 'US')) {
      localeController.changeLocale('en', 'US');
    } else {
      localeController.changeLocale('en', 'US');
    }
  }

  /// 로그인 ID 저장 (SharedPreferences)
  Future<void> _saveLoginId(String loginId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginId', loginId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 언어 스위치 위젯
            Row(
              children: [
                const Expanded(flex: 9, child: SizedBox.shrink()),
                Expanded(
                  child: SizedBox(
                    width: 100,
                    child: LanguagePickerWidget(),
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox.shrink()),
              ],
            ),

            // 타이틀
            Text(
              'BASUP \nfor Aesthetic',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(5.0, 5.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            Text(
              'contact_basup'.tr,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 80),

            // ID 입력
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'user_id'.tr,
                    contentPadding: const EdgeInsets.all(15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // PW 입력
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'password'.tr,
                    contentPadding: const EdgeInsets.all(15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 로그인 버튼
            Container(
              width: 440,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _login,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'login'.tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}