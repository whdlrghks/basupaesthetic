import 'package:basup_ver2/component/loadingdialog.dart';
import 'package:basup_ver2/controller/localecontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LocaleController localeController = Get.find();

    return Container(
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<Locale>(
            isExpanded: true,
            value: localeController.locale.value,
            icon: Icon(Icons.language),
            items: [
              Locale('ko', 'KR'),
              Locale('en', 'US'),
              Locale('id', 'ID'),
              // 추가 언어 설정
            ].map((locale) {
              return DropdownMenuItem(
                child: Container(
                  child: Text(
                    localeController.getLanguageName(locale),
                  ),
                ),
                value: locale,
              );
            }).toList(),
              focusColor : Colors.white,
            onChanged: (Locale? newLocale) {

              LoadingDialog.show();
              if (newLocale != null) {
                print(newLocale.languageCode.toString()+"_" + newLocale
                    .countryCode.toString());
                localeController.changeLocale(
                    newLocale.languageCode, newLocale.countryCode!);

                var surveyController =
                    Get.put(SurveyController(), tag: "survey");
                surveyController.readyforSheet('initial');
              }

              LoadingDialog.hide();
            },
          ),
        ),
      ),
    );
  }
}
