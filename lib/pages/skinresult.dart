import 'dart:ui';

import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/container.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/data/customer.dart';
import 'package:basup_ver2/design/analyzeloading.dart';
import 'package:basup_ver2/design/textstyle.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:basup_ver2/pages/customerslistpage.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:basup_ver2/design/skeleton.dart';
import 'package:basup_ver2/pages/skeletonui.dart';
import 'package:basup_ver2/pages/skinresultprintpage.dart';
import 'package:basup_ver2/service/firebase.dart';
import 'package:basup_ver2/service/result_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SkinResult extends StatefulWidget {
  SkinResult({Key? key}) : super(key: key);

  @override
  _SkinResultState createState() => _SkinResultState();
}

class _SkinResultState extends State<SkinResult> {
  // Initial selected survey (you can set a default or leave it null)
  Rxn<SurveyEachItem> selectedSurvey = Rxn<SurveyEachItem>();

  var resultcontroller = Get.find<ResultController>(tag: "result");
  var isLoading = false.obs;

  var descript = [];

  late DateTime _dateTime;

  late List<DropdownMenuItem<SurveyEachItem>> dropdownItems;
  late ResultService _resultService; // 우리가 만든 서비스 클래스
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    resultcontroller.initloading();

    _resultService = ResultService(resultController: resultcontroller);
    if (resultcontroller.surveylist.isNotEmpty) {
      // 예시: 설문 목록이 이미 날짜 순으로 정렬되어 있다면 첫 번째 항목 선택
      selectedSurvey.value = resultcontroller.surveylist.first;
      print(":TESTSETSETSE");
      print(selectedSurvey.value?.microscopeImage.toString());
      _dateTime = DateTime.parse(selectedSurvey.value!.date);
      SkinSurveyResult newskindata = new SkinSurveyResult();
      Map<String, dynamic> resultData1 = {
        'cos_ingredients': resultcontroller.cos_ingredients.value,
        'ingredient': resultcontroller.ingredient.value,
        'detail': resultcontroller.detail.value,
        'routinecontent': resultcontroller.routinecontent.value,
        'routinekeyword': resultcontroller.routinekeyword.value,
        'skinResultContent': resultcontroller.skinResultContent,
        'skinResultWebContent': resultcontroller.skinResultWebContent,
        'skinResultWebIngre': resultcontroller.skinResultWebIngre,
        'sensper': resultcontroller.sensper,
        'tightper': resultcontroller.tightper,
        'waterper': resultcontroller.waterper,
        'oilper': resultcontroller.oilper,
        'pigper': resultcontroller.pigper,
        'type': resultcontroller.type.value,
        'tag': resultcontroller.tag,
        'tag_flag': resultcontroller.tag_flag,
      };
      newskindata.updateFromMap(resultData1);
      resultcontroller.addSurveyResult(selectedSurvey.value!, newskindata);
    } else {
      // 만약 설문 목록이 없으면 기본 날짜 값 설정 (또는 적절한 예외처리)
      _dateTime = DateTime.now();
    }

    dropdownItems = resultcontroller.surveylist
        .map<DropdownMenuItem<SurveyEachItem>>((survey) {
      print("~~~~~~~~~~~");
      print(survey.date);
      dynamic field = survey.date;
      late DateTime dateTime;

      if (field is Timestamp) {
        dateTime = field.toDate();
      } else if (field is String) {
        dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(field);
      } else {
        throw Exception("Unsupported date format: $field");
      } // 가정
      // DateTime dateTime = DateTime.parse();
      String formattedDate =
          DateFormat("yyyy-MM-dd h:mma").format(dateTime).toLowerCase();

      return DropdownMenuItem<SurveyEachItem>(
        value: survey,
        child: Text(
          formattedDate + " " + 'result_time'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ), // Use the formatted date here
      );
    }).toList();
  }

  Widget buildMicroscopeSlider(MicroscopeImage? microscopeImage) {
    if (microscopeImage == null) {
      return Container();
    }

    // [label: "이마 Led 사진", url: "https://..."]
    final entries = getMicroscopeEntries(microscopeImage);

    return CarouselSlider(
      items: entries.map((entry) {
        final url = entry['url']!;
        final label = entry['label']!;
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.fromLTRB(8, 10, 8, 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // 1) 이미지
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 2) 라벨 텍스트
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 450,
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: false,
        initialPage: 0,
      ),
    );
  }

  List<Map<String, String>> getMicroscopeEntries(MicroscopeImage micros) {
    return [
      {
        'label': '이마 Led 사진',  // 라벨
        'url': micros.headLed,
      },
      {
        'label': '왼쪽 뺨 Led 사진',
        'url': micros.leftLed,
      },
      {
        'label': '오른쪽 뺨 Led 사진',
        'url': micros.rightLed,
      },
      {
        'label': '이마 Uv 사진',
        'url': micros.headUv,
      },
      {
        'label': '왼쪽 뺨 Uv 사진',
        'url': micros.leftUv,
      },
      {
        'label': '오른쪽 뺨 Uv 사진',
        'url': micros.rightUv,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // user_id가 BASUPTEST인 경우, 로딩 인디케이터를 보여주며 CustomersListPage로 리다이렉트
    if (resultcontroller.user_id.value == "BASUPTEST") {
      Future.microtask(() {
        Get.offAll(
            CustomersListPage(aestheticId: resultcontroller.aestheticId.value));
      });
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    var controller = Get.find<SizeController>(tag: "size");

    descript = (resultcontroller.decodeSkinType(resultcontroller.type.value));
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed('/index');
        return false; // true를 반환하면 뒤로가기가 동작, false면 막음
      },
      child: Scaffold(
          body:
              // isLoading.value
              //     ? skeletonSkinResult() // 로딩 중이면 스켈레톤 UI를 보여줌
              //     :
              Stack(
        children: [
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(children: [
              BlankTopGap(controller),
              title(resultcontroller),
              BlankBetweenTitleContent(controller),
              Obx(() {
                final micros = selectedSurvey.value?.microscopeImage;
                return buildMicroscopeSlider(micros);
              }),
              LayoutBuilder(
                builder: (context, constraints) {
                  // 예: 너비가 600픽셀 미만이면 Column, 그 이상이면 Row로 표시
                  if (constraints.maxWidth < 800) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        skintitle(resultcontroller, descript),
                        SizedBox(height: 16),
                        resultData(controller, resultcontroller),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        skintitle(resultcontroller, descript),
                        SizedBox(width: 16),
                        resultData(controller, resultcontroller),
                      ],
                    );
                  }
                },
              ),
              resultContent(resultcontroller),
              // careRoutine(controller, resultcontroller),
              LayoutBuilder(builder: (context, constraints) {
                // 예: 너비가 600픽셀 미만이면 Column, 그 이상이면 Row로 표시
                if (constraints.maxWidth < 800) {
                  return Obx(
                    () => resultcontroller.match_loading.value
                        ? skeletonResultMatch()
                        : matchIngredientColumn(resultcontroller),
                  );
                } else {
                  return Obx(
                    () => resultcontroller.match_loading.value
                        ? skeletonResultMatch()
                        : matchIngredient(resultcontroller),
                  );
                }
              }),
              // matchIngredient(resultcontroller),
              // recommendProduct(resultcontroller),
            ]),
          ),
        ],
      )),
    );
  }

  void _printDocument(resultcontroller) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(children: []);
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Widget title(resultcontroller) {
    late var _skindatalist;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: backKey(fromResult: true),
          ),
          if (dropdownItems.isNotEmpty) ...[
            Obx(
              () => DropdownButton<SurveyEachItem>(
                value: selectedSurvey.value,
                // hint: Text(
                //   DateFormat("yyyy-MM-dd h:mma").format(_dateTime).toLowerCase() +
                //       " " +
                //       'result_time'.tr,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 14,
                //     fontFamily: 'Pretendard',
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                items: dropdownItems,
                focusColor: Colors.white,
                onChanged: (newValue) async {
                  print("[DEBUG]`onchanged start");
                  if (newValue == null) return;
                  if (!mounted) return; // 혹시 모를 경우 체크
                  selectedSurvey.value = newValue;
                  print(
                      "[DEBUG]`selectedSurvey.value : ${selectedSurvey.value}");

                  print(":TESTSETSETSE");
                  print(selectedSurvey.value?.microscopeImage.toString());
                  resultcontroller.initloading();
                  resultcontroller.startloading();

                  isLoading.value = true; // 로딩 시작

                  print("[DEBUG]`isLoading.value : ${isLoading.value}");

                  if (resultcontroller.surveyItemList
                          .containsKey(selectedSurvey.value) &&
                      resultcontroller
                          .surveyItemList[selectedSurvey.value]!.isNotEmpty) {
                    // 해당 key에 대한 값이 존재하면, 해당 결과를 resultcontroller의 필드들에 적용
                    resultcontroller
                        .applySurveyResultForKey(selectedSurvey.value!);
                  } else {
                    if (selectedSurvey.value!.onlysurvey) {
                      print("[DEBUG]`before fetchSurveyResult");
                      await fetchSurveyResult(selectedSurvey.value!.surveyId);
                      SkinSurveyResult newskindata = new SkinSurveyResult();
                      Map<String, dynamic> resultData1 = {
                        'cos_ingredients':
                            resultcontroller.cos_ingredients.value,
                        'ingredient': resultcontroller.ingredient.value,
                        'detail': resultcontroller.detail.value,
                        'routinecontent': resultcontroller.routinecontent.value,
                        'routinekeyword': resultcontroller.routinekeyword.value,
                        'skinResultContent': resultcontroller.skinResultContent,
                        'skinResultWebContent':
                            resultcontroller.skinResultWebContent,
                        'skinResultWebIngre':
                            resultcontroller.skinResultWebIngre,
                        'sensper': resultcontroller.sensper,
                        'tightper': resultcontroller.tightper,
                        'waterper': resultcontroller.waterper,
                        'oilper': resultcontroller.oilper,
                        'pigper': resultcontroller.pigper,
                        'type': resultcontroller.type.value,
                        'tag': resultcontroller.tag,
                        'tag_flag': resultcontroller.tag_flag,
                      };
                      newskindata.updateFromMap(resultData1);
                      resultcontroller.addSurveyResult(
                          selectedSurvey.value, newskindata);
                    } else {
                      print("[DEBUG]`before getSkinDataList");
                      print(selectedSurvey.value!.date);
                      _skindatalist = await getBeforeSkinDataList(
                          selectedSurvey.value!.surveyId,
                          selectedSurvey.value!.date);

                      print(
                          "[DEBUG]`before  _resultService.handleSkinDataIsNewer");
                      await _resultService
                          .handleSkinDataIsNewer(_skindatalist[0]);
                      SkinSurveyResult tempskindata = new SkinSurveyResult();
                      Map<String, dynamic> resultData2 = {
                        'cos_ingredients':
                            resultcontroller.cos_ingredients.value,
                        'ingredient': resultcontroller.ingredient.value,
                        'detail': resultcontroller.detail.value,
                        'routinecontent': resultcontroller.routinecontent.value,
                        'routinekeyword': resultcontroller.routinekeyword.value,
                        'skinResultContent': resultcontroller.skinResultContent,
                        'skinResultWebContent':
                            resultcontroller.skinResultWebContent,
                        'skinResultWebIngre':
                            resultcontroller.skinResultWebIngre,
                        'sensper': resultcontroller.sensper,
                        'tightper': resultcontroller.tightper,
                        'waterper': resultcontroller.waterper,
                        'oilper': resultcontroller.oilper,
                        'pigper': resultcontroller.pigper,
                        'type': resultcontroller.type.value,
                        'tag': resultcontroller.tag,
                        'tag_flag': resultcontroller.tag_flag,
                      };
                      tempskindata.updateFromMap(resultData2);

                      resultcontroller.addSurveyResult(
                          selectedSurvey.value, tempskindata);
                    }
                  }
                  isLoading.value = false; // 로딩 종료
                },
              ),
            ),
          ] else ...[
            Text(
              'no_results'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝에 위젯을 배치
        children: [
          SizedBox(width: 100), // 왼쪽 공간을 만듭니다.
          Expanded(
            child: Container(
              alignment: Alignment.center, // 컨테이너 내부 텍스트를 중앙 정렬
              child: Text.rich(
                TextSpan(
                  // text: selectedSurvey.value!.surveyId,
                  text: "",
                  style: TextStyle(
                    color: Color(0xFF49A85E),
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 100, 0),
            child: IconButton(
              icon: Icon(Icons.print),
              onPressed: () {
                if (isMobileDevice()) {
                  Get.dialog(MobileErrorDialog());
                } else {
                  printDocument(resultcontroller, descript);
                }
              },
              tooltip: 'Print Document',
            ),
          ),
        ],
      )
    ]);
  }
}

Widget skintitle_print(resultcontroller) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Text(
          resultcontroller.name.value + 'your_skin_type_is'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Container(
          width: 300,
          height: 33,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFF49A85E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: Center(
            child: Text(
              resultcontroller.type.value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        width: 450,
        height: 46,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tagContainer(resultcontroller.tag[0], resultcontroller.tag_flag[0]),
            tagContainer(resultcontroller.tag[1], resultcontroller.tag_flag[1]),
            if (resultcontroller.tag.length > 2)
              tagContainer(
                  resultcontroller.tag[2], resultcontroller.tag_flag[2]),
          ],
        ),
      ),
    ],
  );
}

Widget _buildImage(String assetName, [double width = 300]) {
  return Image.asset('assets/$assetName', width: width);
}

Widget skintitle(resultcontroller, descript) {
  return Obx(
    () => resultcontroller.title_loading.value
        ? skeletonResultTitle()
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: Text(
                  resultcontroller.name.value + 'your_skin_type_is'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Container(
                  width: 300,
                  height: 33,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xFF49A85E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      resultcontroller.type.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                width: 450,
                height: 46,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tagContainer(
                        resultcontroller.tag[0], resultcontroller.tag_flag[0]),
                    tagContainer(
                        resultcontroller.tag[1], resultcontroller.tag_flag[1]),
                    if (resultcontroller.tag.length > 2)
                      tagContainer(resultcontroller.tag[2],
                          resultcontroller.tag_flag[2]),
                  ],
                ),
              ),
              skinDescription(descript)
            ],
          ),
  );
}

Widget skinDescription(descript) {
  TextStyle wordTostyle = TextStyle(
    color: Color(0xFF49A85E),
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );
  print(descript);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    // Align children to the start of the Row
    children: descript
        .map((text) => Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                  children: _getSpans(text, text.split("-")[0], wordTostyle),
                ),
              ),
            ))
        .toList()
        .cast<
            Widget>(), // Convert the map result to a list for the children property
  );
}

Widget resultContent(resultcontroller) {
  return Obx(
    () => resultcontroller.opinion_loading.value
        ? skeletonResultOpinion()
        : Container(
            margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 980, // 부모가 450보다 크면 최대 450으로 제한
                  ),
                  child: Container(
                    // constraints: BoxConstraints(maxWidth: 840),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text(
                      "expert_opinion".tr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF7D7D7D),
                        fontSize: 18,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 980),
                  height: 600,
                  child: ListView.builder(
                    itemCount: resultcontroller.skinResultWebContent.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          resultcontroller.skinResultWebContent[index]
                              .replaceAll(r"\n", "\n"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색 설정
                    border: Border.all(
                      color: Colors.black12, // 테두리 색상 설정
                      width: 3, // 테두리 두께 설정
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  constraints: BoxConstraints(maxWidth: 980),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Text(
                    "skin_type_description".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 980),
                  child: Text(
                    resultcontroller.skinResultContent[0]
                        .replaceAll(r"\n", "\n"),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  constraints: BoxConstraints(maxWidth: 980),
                  child: Text(
                    resultcontroller.skinResultContent[1]
                        .replaceAll(r"\n", "\n"),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (resultcontroller.skinResultContent.length > 2)
                  Container(
                    constraints: BoxConstraints(maxWidth: 980),
                    child: Text(
                      resultcontroller.skinResultContent[2]
                          .replaceAll(r"\n", "\n"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF7D7D7D),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
  );
}

Widget resultData(controller, resultcontroller) {
  return Obx(
    () => resultcontroller.data_loading.value
        ? skeletonResultGraph()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            child: Column(
              children: [
                ResultTitle("skin_type".tr),
                resultSubtitle(resultcontroller),
                resultGraph(resultcontroller),
              ],
            ),
          ),
  );
}

resultSubtitle(resultcontroller) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
        child: Text(
          resultcontroller.name.value + 'skin_analysis_results'.tr,
          style: TextStyle(
            color: Color(0xFF979797),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '288_result'.tr,
                style: TextStyle(
                  color: Color(0xFF49A85E),
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: resultcontroller.name.value + 'anlayzed_result'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

resultGraph(controller) {
  return Column(
    children: [
      graphItem(controller, DataType.SENS),
      graphItem(controller, DataType.TIGHT),
      graphItem(controller, DataType.PIG),
      graphItem(controller, DataType.WATER),
      graphItem(controller, DataType.OIL),
    ],
  );
}

graphItem(controller, type) {
  return Column(
    children: [
      Container(
        width: 303,
        padding: const EdgeInsets.fromLTRB(3, 15, 3, 5),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    controller.getDataName(type),
                    style: percent_name,
                  ),
                ),
                Container(
                  // width: 80,
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: controller.getColorFlag(type)
                        ? Color(0xFFE7F4EA)
                        : Color(0xFFFBDFDF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(46),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        controller.getFlag(type),
                        style: TextStyle(
                          color: controller.getColorFlag(type)
                              ? Color(0xFF49A85E)
                              : Color(0xFFEF6363),
                          fontSize: 10,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            Expanded(
              flex: 2,
              child: Text(
                // '비저항성',
                "",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFFCECECE),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 303,
        height: 40,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 10,
              child: Container(
                width: 303,
                height: 20,
                decoration: ShapeDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 10,
              child: Container(
                width: controller.getPer(type, 303),
                height: 20,
                padding: const EdgeInsets.only(top: 0.0),
                decoration: ShapeDecoration(
                  color: Color(0xFF49A85E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  controller.getPerValue(type, 100).toString() + '%',
                  textAlign: TextAlign.center,
                  style: percent_graph,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

careRoutine(controller, resultcontroller) {
  return Container(
      child: Column(children: [
    Container(
      height: 25,
    ),
    ResultTitle("관리 방법"),
    careSubtitle('맞춤 관리 진단', "RNTD3De1타입", "RNTD3De1타입은 \n이렇게 관리하면 좋아요"),
    Container(
      height: 40,
    ),
    careRoutineRecommend(
        resultcontroller.routinekeyword[0], resultcontroller.routinecontent[0]),
    careRoutineRecommend(
        resultcontroller.routinekeyword[1], resultcontroller.routinecontent[1]),
    careRoutineRecommend(
        resultcontroller.routinekeyword[2], resultcontroller.routinecontent[2]),
    Container(
      height: 40,
    ),
  ]));
}

careSubtitle(title, keyword, content) {
  var wordTostyle = keyword;
  var spans = _getSpans(content, wordTostyle, careroutinesubtitle_title);
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
        child: Text(
          title,
          style: subtitle_title,
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(15, 3, 15, 10),
        child: Text.rich(
          TextSpan(style: careroutinesubtitle_content, children: spans),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
  List<TextSpan> spans = [];
  int spanBoundary = 0;

  do {
    // 전체 String 에서 키워드 검색
    final startIndex = text.indexOf(matchWord, spanBoundary);

    // 전체 String 에서 해당 키워드가 더 이상 없을때 마지막 KeyWord부터 끝까지의 TextSpan 추가
    if (startIndex == -1) {
      spans.add(TextSpan(text: text.substring(spanBoundary)));
      return spans;
    }

    // 전체 String 사이에서 발견한 키워드들 사이의 text에 대한 textSpan 추가
    if (startIndex > spanBoundary) {
      print(text.substring(spanBoundary, startIndex));
      spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
    }

    // 검색하고자 했던 키워드에 대한 textSpan 추가
    final endIndex = startIndex + matchWord.length;
    final spanText = text.substring(startIndex, endIndex);
    spans.add(TextSpan(text: spanText, style: style));

    // mark the boundary to start the next search from
    spanBoundary = endIndex;

    // continue until there are no more matches
  }
  //String 전체 검사
  while (spanBoundary < text.length);

  return spans;
}

careRoutineRecommend(keyword, content) {
  var wordTostyle = keyword;

  var spans = _getSpans(content, wordTostyle, careroutine_title);

  return Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Column(
      children: [
        Container(
          width: 302,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(style: careroutine_content, children: spans),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

matchIngredient(resultcontroller) {
  // Initialize an empty list of widgets that will contain all our dynamic widgets
  List<Widget> listWidgets = [];

  // Start with adding a top spacer and titles
  listWidgets.addAll([
    Container(height: 25),
    ResultTitle("matched_ingredients".tr),
    careSubtitle(
        "prescription_ingredients_title".tr,
        " ",
        "ingredients_benef"
                "it"
            .tr),
    Container(height: 25),
  ]);

  // Dynamically add matchIngredientComment widgets based on ingredient list
  for (int i = 0; i < 6; i++) {
    // Make sure not to exceed the detail list's bounds
    if (i + 1 < resultcontroller.detail.length) {
      listWidgets.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            // Expanded(
            child: matchIngredientComment(
                resultcontroller.ingredient[i], resultcontroller.detail[i]),
          ),
          // Expanded(
          Container(
            child: matchIngredientComment(resultcontroller.ingredient[i + 1],
                resultcontroller.detail[i + 1]),
          ),
        ]),
      );
      i = i + 1;
    } else if (i < resultcontroller.detail.length) {
      listWidgets.add(
        matchIngredientComment(
            resultcontroller.ingredient[i], resultcontroller.detail[i]),
      );
    }
  }

  // Add a bottom spacer
  listWidgets.add(Container(height: 25));

  // Return the whole structure wrapped in a Container and Column
  return Container(
    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: listWidgets,
    ),
  );
}

matchIngredientColumn(resultcontroller) {
  // Initialize an empty list of widgets that will contain all our dynamic widgets
  List<Widget> listWidgets = [];

  // Start with adding a top spacer and titles
  listWidgets.addAll([
    Container(height: 25),
    ResultTitle("matched_ingredients".tr),
    careSubtitle(
        "prescription_ingredients_title".tr,
        " ",
        "ingredients_benef"
                "it"
            .tr),
    Container(height: 25),
  ]);

  // Dynamically add matchIngredientComment widgets based on ingredient list
  for (int i = 0; i < 6; i++) {
    // Make sure not to exceed the detail list's bounds
    if (i + 1 < resultcontroller.detail.length) {
      listWidgets.add(
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            // Expanded(
            child: matchIngredientComment(
                resultcontroller.ingredient[i], resultcontroller.detail[i]),
          ),
          // Expanded(
          Container(
            child: matchIngredientComment(resultcontroller.ingredient[i + 1],
                resultcontroller.detail[i + 1]),
          ),
        ]),
      );
      i = i + 1;
    } else if (i < resultcontroller.detail.length) {
      listWidgets.add(
        matchIngredientComment(
            resultcontroller.ingredient[i], resultcontroller.detail[i]),
      );
    }
  }

  // Add a bottom spacer
  listWidgets.add(Container(height: 25));

  // Return the whole structure wrapped in a Container and Column
  return Container(
    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: listWidgets,
    ),
  );
}

matchIngredientComment(ingredient, content) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
    child: Column(
      children: [
        Container(
          width: 302,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                    style: ingredient_title, text: ingredient.split("/")[0]),
              ),
            ],
          ),
        ),
        Container(
            width: 302,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              content,
              style: ingredient_content,
            ))
      ],
    ),
  );
}

// recommendProduct(resultcontroller) {
//   return Container(
//       child: Column(children: [
//     Container(
//       height: 25,
//     ),
//     ResultTitle("재품 추천"),
//     careSubtitle(" ", "위 성분을 모두 담은", "위 성분을 모두 담은\n제품을 추천해드려요"),
//     Container(
//       height: 25,
//     ),
//     // packageImage(),
//     // packageDescription(),
//     Container(
//       height: 100,
//     ),
//   ]));
// }

// packageImage() {
//   return Container(
//     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//     child: _buildImage("totalitem.jpg"),
//   );
// }
//
// packageDescription() {
//   var wordTostyle = "맞춤 제작";
//   var spans = _getSpans("피부 타입 분석 결과를 바탕으로\n기성품이 아닌 맞춤 제작해드려요", wordTostyle,
//       skinrecommend_highlight);
//   return Container(
//       child: Column(
//     children: [
//       Container(
//         padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
//         child: Text.rich(
//           textAlign: TextAlign.center,
//           TextSpan(style: skinrecommend_content, children: spans),
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
//         child: Text.rich(
//           textAlign: TextAlign.center,
//           TextSpan(
//               style: skinrecommend_highlight,
//               text: "더 자세하고 많은 정보들을\n앱에서 확인할 수 있어요!"),
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
//         child: Text.rich(
//           textAlign: TextAlign.center,
//           TextSpan(
//               style: skinrecommend_highlight,
//               text: "베이스업 프로젝트를 구독하고\n4주 동안 특별 "
//                   "케어 받아보세요!"),
//         ),
//       ),
//     ],
//   ));
// }

String detectDeviceType() {
  var userAgent = html.window.navigator.userAgent.toString();

  if (userAgent.contains('Android')) {
    return 'Android';
  } else if (userAgent.contains('iPhone')) {
    return 'iOS';
  } else {
    return 'Unknown';
  }
}
