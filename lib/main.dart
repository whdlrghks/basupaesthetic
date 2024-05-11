import 'package:basup_ver2/controller/localecontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:basup_ver2/design/apptranslations.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:basup_ver2/pages/authguard.dart';
import 'package:basup_ver2/pages/customerslistpage.dart';
import 'package:basup_ver2/pages/index.dart';
import 'package:basup_ver2/pages/login.dart';
import 'package:basup_ver2/pages/skinmachine.dart';
import 'package:basup_ver2/pages/skinresult.dart';
import 'package:basup_ver2/pages/skinscope.dart';
import 'package:basup_ver2/pages/surveyselectform.dart';
import 'package:basup_ver2/pages/surveyshortform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/userinfo.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var localeController = Get.put(LocaleController());
  // 시스템 로케일을 기반으로 초기 로케일 설정
  var systemLocale = WidgetsBinding.instance.window.locale;
  if (systemLocale != null) {
    localeController.changeLocale(systemLocale.languageCode, systemLocale.countryCode ?? 'US');
  } else {
    localeController.changeLocale('ko', 'KR');  // 기본값으로 'ko', 'KR' 설정
  }
  var surveyController = Get.put(SurveyController(), tag: "survey");
  var sizeController = Get.put(SizeController(), tag: "size");
  var resultController = Get.put(ResultController(), tag: "result");

  Get.put(LocaleController());
  var type = "initial";
  surveyController.readyforSheet(type);

  resultController.initmachine();
  resultController.initscope();
  resultController.inituser();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BASUP 피부 진단',
      translations: AppTranslations(),
      locale: Locale('ko', 'KR'), // 기본 로케일 설정
      fallbackLocale: Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
        // initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () =>  LoginScreen()),
          GetPage(name: '/index', page: () => AuthGuard(child: Index())),
          GetPage(name: '/survey', page: () =>  UserInfo()),
          GetPage(name: '/machine', page: () => AuthGuard(child:  SkinMachine
            ())),
          GetPage(name: '/scope', page: () => SkinScope()),
          GetPage(name: '/result', page: () => AuthGuard(child: SkinResult())),
          GetPage(name: '/shortform', page : ()=> AuthGuard(child: ShortForm
            ())),
          // Add other routes as needed
        ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    setDevice_Width(MediaQuery.of(context).size.width);
    return Scaffold(
      body: LoginScreen(),
    );
  }
}
