import 'package:basup_ver2/controller/localecontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LocaleController localeController = Get.find();

    return DropdownButtonHideUnderline(
      child: Obx(
        () => DropdownButton<Locale>(
          value: localeController.locale.value,
          icon: Icon(Icons.language),
          items: [
            Locale('ko', 'KR'),
            Locale('en', 'US'),
            // 추가 언어 설정
          ].map((locale) {
            return DropdownMenuItem(
              child: Text(locale.toString()),
              value: locale,
            );
          }).toList(),
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localeController.changeLocale(
                  newLocale.languageCode, newLocale.countryCode!);

              var surveyController = Get.put(SurveyController(), tag: "survey");
              surveyController.readyforSheet('initial');
            }
          },
        ),
      ),
    );
  }
}
