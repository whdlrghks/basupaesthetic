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
    loadLocale();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    String? countryCode = prefs.getString('country_code');

    if (langCode != null && countryCode != null) {
      var newLocale = Locale(langCode, countryCode);
      print("loadLocale");
      print(newLocale.languageCode.toString()+"_"+newLocale.countryCode
          .toString());

      // Dropdown 목록에 존재하는지 확인하는 로직 추가
      List<Locale> supportedLocales = [Locale('ko', 'KR'), Locale('en', 'US'), Locale('id', 'ID')];
      bool isSupported = supportedLocales.any((locale) =>
      locale.languageCode == newLocale.languageCode && locale.countryCode == newLocale.countryCode
      );

      if (isSupported) {
        locale.value = newLocale;
        Get.updateLocale(newLocale);
      } else {
        // 지원하지 않는 로케일이면 기본값으로 되돌림
        locale.value = Locale('en', 'US');
        Get.updateLocale(Locale('en', 'US'));
        await _persistLocale(Locale('en', 'US'));
      }
    }
  }

  Future<void> _persistLocale(Locale locale) async {

    print("_persistLocale");
    print(locale.languageCode.toString()+"_"+locale.countryCode
        .toString());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode!);
    print("_persistLocale _ loadLocale");

    loadLocale();
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'ru':
        return 'Русский';
      case 'ar':
        return 'العربية';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return 'Unknown Language';
    }
  }
}