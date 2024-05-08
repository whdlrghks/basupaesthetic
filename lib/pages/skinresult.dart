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
import 'package:basup_ver2/pages/skinresultprintpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:html' as html;
import 'package:flutter_widget_to_image/flutter_widget_to_image.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SkinResult extends StatefulWidget {
  SkinResult({Key? key}) : super(key: key);

  @override
  _SkinResultState createState() => _SkinResultState();
}

class _SkinResultState extends State<SkinResult> {
  // Initial selected survey (you can set a default or leave it null)
  SurveyItem? selectedSurvey;

  var isLoading = false;

  var descript = [];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SizeController>(tag: "size");
    var resultcontroller = Get.find<ResultController>(tag: "result");

    descript = (resultcontroller.decodeSkinType(resultcontroller.type.value));
    return Scaffold(
        body: isLoading
            ? AnalyzeLoading() // 로딩 중 인디케이터 표시
            : Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ListView(children: [
                      BlankTopGap(controller),
                      title(resultcontroller),
                      BlankBetweenTitleContent(controller),

                      Row(
                        children: [
                          Expanded(
                            child: skintitle(resultcontroller, descript),
                          ),
                          Expanded(
                            child: resultData(controller, resultcontroller),
                          ),
                        ],
                      ),
                      resultContent(resultcontroller),
                      // careRoutine(controller, resultcontroller),
                      matchIngredient(resultcontroller),
                      // recommendProduct(resultcontroller),
                    ]),
                  ),
                ],
              ));
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
    List<DropdownMenuItem<SurveyItem>> dropdownItems =
        resultcontroller.surveylist.map<DropdownMenuItem<SurveyItem>>((survey) {
      DateTime dateTime = DateTime.parse(survey.date);
      String formattedDate =
          DateFormat.yMMMMd(Localizations.localeOf(context).toString())
              .add_jm()
              .format(dateTime);

      return DropdownMenuItem<SurveyItem>(
        value: survey,
        child: Text(
          formattedDate,
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
    DateTime dateTime = DateTime.parse(resultcontroller.survey_date.value);
    // Formats to Year-Month-Day
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 100, 0),
            child: backKey(),
          ),
          if (dropdownItems.isNotEmpty) ...[
            DropdownButton<SurveyItem>(
              value: selectedSurvey,
              hint: Text(
                DateFormat.yMMMMd(Localizations.localeOf(context).toString())
                        .add_jm()
                        .format(dateTime) +
                    " " +
                    'result_time'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
              items: dropdownItems,
              onChanged: (newValue) async {
                setState(() {
                  isLoading = true; // 로딩 시작
                });
                selectedSurvey = newValue;
                await fetchSurveyResult(selectedSurvey!.surveyId);
                setState(() {
                  isLoading = false; // 로딩 종료
                  print("setstate");
                });
              },
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
                  text: resultcontroller.survey_id.value,
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
                printDocument(resultcontroller, descript);
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
      skinDescription(descript)
    ],
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
  print(resultcontroller.skinResultWebContent);
  return Container(
    margin: EdgeInsets.fromLTRB(150, 50, 150, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        Container(
          height: 450,
          child: ListView.builder(
            itemCount: resultcontroller.skinResultWebContent.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  resultcontroller.skinResultWebContent[index],
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
          child: Text(
            resultcontroller.skinResultContent[0],
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
          child: Text(
            resultcontroller.skinResultContent[1],
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
          child: Text(
            resultcontroller.skinResultContent[2],
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
  );
}

Widget resultData(controller, resultcontroller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
    child: Column(
      children: [
        ResultTitle("skin_type".tr),
        resultSubtitle(resultcontroller),
        resultGraph(resultcontroller),
      ],
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
              flex: 4,
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
              flex: 4,
              child: Container(),
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
                padding: const EdgeInsets.only(top: 3.0),
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
        Row(children: [
          Expanded(
            child: matchIngredientComment(
                resultcontroller.ingredient[i], resultcontroller.detail[i]),
          ),
          Expanded(
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
    margin: EdgeInsets.fromLTRB(200, 0, 200, 0),
    child: Column(
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
