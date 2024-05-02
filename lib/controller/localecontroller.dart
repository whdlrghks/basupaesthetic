import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  Rx<Locale?> locale = Rx<Locale?>(Locale('en', 'US')); // 초기 기본값 설정

  @override
  void onInit() {
    super.onInit();
    loadLocale();
  }

  void changeLocale(String langCode, String countryCode) async {
    var newLocale = Locale(langCode, countryCode);
    locale.value = newLocale;
    Get.updateLocale(newLocale); // GetX에 새 로케일 적용
    await _persistLocale(newLocale);
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    String? countryCode = prefs.getString('country_code');

    if (langCode != null && countryCode != null) {
      var newLocale = Locale(langCode, countryCode);
      locale.value = newLocale;
      Get.updateLocale(newLocale); // 저장된 로케일로 GetX 업데이트
    }
  }

  Future<void> _persistLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode!);
  }
}