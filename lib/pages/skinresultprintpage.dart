import 'package:basup_ver2/controller/localecontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'dart:html' as html;
String sanitizeString(String input) {
  // 여기서 추가적으로 필요한 문자 변환을 정의할 수 있습니다.
  return input.replaceAll('‘', "'").replaceAll('’', "'");
}
Future<void> printDocument(ResultController resultcontroller, descript) async {
  final pdf = pw.Document();

  final LocaleController localeController = Get.find();
  try {
  // 폰트 파일 로드
  final fontData_Light = await rootBundle.load("assets/fonts/AnyConv"
      ".com__Pretendard-Light.ttf");
  // final fontData_Bold = await rootBundle.load("assets/fonts/AnyConv"
  //     ".com__Pretendard-Bold.ttf");
  // final fontData_Medium = await rootBundle.load("assets/fonts/AnyConv"
  //     ".com__Pretendard-Medium.ttf");
  final fontData_Regular = await rootBundle.load("assets/fonts/AnyConv"
      ".com__Pretendard-Regular.ttf");
  final Light =
  // localeController.locale.value ==
  //     Locale('ko', 'KR') ? await PdfGoogleFonts.:
  // await
  // PdfGoogleFonts
  //     .notoSansThin();

  pw.Font.ttf(fontData_Light.buffer.asByteData());
  final Bold = await PdfGoogleFonts.notoSansBold();
  // pw.Font.ttf(fontData_Bold.buffer.asByteData(0, fontData_Bold.lengthInBytes));
  // final Medium = pw.Font.ttf(fontData_Medium.buffer.asByteData(0, fontData_Medium.lengthInBytes));
  final Regular =
  // await PdfGoogleFonts.notoSansRegular();
  pw.Font.ttf(fontData_Regular.buffer.asByteData());

  final textWidgets = descript
      .map((text) {
        List<String> parts = text.split("-");
        parts[0] = parts[0].trim(); // Remove any leading/trailing whitespace

        return pw.Container(
          // padding: pw.EdgeInsets.all(8),
          margin: pw.EdgeInsets.fromLTRB(0, 3, 0, 3),
          child: pw.RichText(
            text: pw.TextSpan(
              style: pw.TextStyle(
                font: Bold, // 폰트를 기본 제공하는 bold로 지정
                color: PdfColors.black,
                fontSize: 7,
              ),
              children: [
                pw.TextSpan(
                  text: parts[0],
                  style: pw.TextStyle(
                    font: Regular, // 폰트를 기본 제공하는 regular로 지정
                    color: PdfColors.black,
                    fontSize: 7,
                  ),
                ),
                if (parts.length > 1)
                  pw.TextSpan(
                    text: "-" + parts.sublist(1).join("-"),
                    style: pw.TextStyle(
                      font: Regular,
                      color: PdfColors.black,
                      fontSize: 7,
                    ),
                  ),
              ],
            ),
          ),
        );
      })
      .toList()
      .cast<pw.Widget>();

  List<pw.Widget> ingredients = [
    pw.Container(
      margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: pw.Text(
        "Matched Ingredients",
        textAlign: pw.TextAlign.left,
        style: pw.TextStyle(
          font: Bold, // 'Bold'를 PdfFonts에서 제공하는 폰트로 변경
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      decoration: pw.BoxDecoration(
        // 테두리 설정: 아래쪽에만 테두리를 추가
        border: pw.Border(
          bottom: pw.BorderSide(
            width: 1, // 테두리 두께
            color: PdfColors.grey400, // 테두리 색상
          ),
        ),
      ),
    ),
    ...List<pw.Widget>.generate(
        (resultcontroller.ingredient.length / 2).floor(), (i) {
      return pw.Container(
        margin: pw.EdgeInsets.fromLTRB(0, 1, 0, 1),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          // 주요 축을 기준으로 좌우 공간 균등 배분
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(children: [
                pw.Container(
                  padding: pw.EdgeInsets.only(right: 5), // 우측에 패딩 추가
                  child: pw.Text(resultcontroller.ingredient[i],
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                        font: Regular, // 변경: 'Regular' 폰트로 'PdfFonts
                        // .helvetica' 사용
                        fontSize: 7,
                      )),
                ),
                pw.Container(
                    padding: pw.EdgeInsets.only(left: 5), // 좌측에 패딩 추가
                    child: pw.Text(
                      resultcontroller.detail[i],
                      textAlign: pw.TextAlign.left, // 오른쪽 정렬
                      style: pw.TextStyle(
                        font: Light, // 변경: 'Light' 폰트로 'PdfFonts.helvetica' 사용
                        fontSize: 7,
                      ),
                    )),
              ],
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(children: [
                pw.Container(
                  padding: pw.EdgeInsets.only(right: 5), // 우측에 패딩 추가
                  child: pw.Text(resultcontroller.ingredient[i + 1],
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                        font: Regular, // 변경: 'Regular' 폰트로 'PdfFonts
                        // .helvetica' 사용
                        fontSize: 7,
                      )),
                ),
                pw.Container(
                    padding: pw.EdgeInsets.only(left: 5), // 좌측에 패딩 추가
                    child: pw.Text(
                      resultcontroller.detail[i + 1],
                      textAlign: pw.TextAlign.left, // 오른쪽 정렬
                      style: pw.TextStyle(
                        font: Light, // 변경: 'Light' 폰트로 'PdfFonts.helvetica' 사용
                        fontSize: 7,
                      ),
                    )),
              ],

                crossAxisAlignment: pw.CrossAxisAlignment.stretch,),
            ),
          ],
        ),
      );
    }),
  ];

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(children: [
          //제목
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              child: pw.Row(children: [
                pw.Expanded(
                  child: pw.Container(
                    child: pw.Text("BASUP",
                        style: pw.TextStyle(
                            font: Bold,
                            fontStyle: pw.FontStyle.normal,
                            fontSize: 50)),
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(children: [
                    pw.Row(children: [
                      pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            child: pw.Text("NAME",
                                style: pw.TextStyle(
                                    font: Regular,
                                    fontStyle: pw.FontStyle.normal,
                                    fontSize: 10)),
                          )),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              resultcontroller.name.value,
                              style: pw.TextStyle(
                                  font: Light,
                                  fontStyle: pw.FontStyle.normal,
                                  fontSize: 10),
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 2, color: PdfColors.black), // 아랫줄 설정
                              ),
                            ),
                          )),
                    ]),
                    pw.Row(children: [
                      pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            child: pw.Text("AGE",
                                style: pw.TextStyle(
                                    font: Regular,
                                    fontStyle: pw.FontStyle.normal,
                                    fontSize: 10)),
                          )),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              resultcontroller.age.value,
                              style: pw.TextStyle(
                                  font: Light,
                                  fontStyle: pw.FontStyle.normal,
                                  fontSize: 10),
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 2, color: PdfColors.black), // 아랫줄 설정
                              ),
                            ),
                          )),
                    ]),
                    pw.Row(children: [
                      pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            child: pw.Text("GENDER",
                                style: pw.TextStyle(
                                    font: Regular,
                                    fontStyle: pw.FontStyle.normal,
                                    fontSize: 10)),
                          )),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              resultcontroller.gender.value == Gender.M
                                  ? "M"
                                  : "W",
                              style: pw.TextStyle(
                                  font: Light,
                                  fontStyle: pw.FontStyle.normal,
                                  fontSize: 10),
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                    width: 2, color: PdfColors.black), // 아랫줄 설정
                              ),
                            ),
                          )),
                    ]),
                  ]),
                ),
              ]),
            ),
          ),
          //내용
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              child: pw.Row(children: [
                pw.Container(
                  margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                  padding: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.fromLTRB(0, 5, 0, 2),
                        child: pw.Text(
                          resultcontroller.name.value + 'your_skin_type_is'.tr,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            font: Light,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.fromLTRB(0, 3, 0, 6),
                        child: pw.Container(
                          width: 250,
                          height: 15,
                          child: pw.Text(
                            resultcontroller.type.value,
                            style: pw.TextStyle(
                              fontSize: 18,
                              font: Regular,
                            ),
                          ),
                        ),
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: textWidgets,
                      )
                    ],
                  ),
                ),
                pw.Column(
                  children: [
                    graphItemPdf(resultcontroller, DataType.SENS, pdf,Regular),
                    graphItemPdf(resultcontroller, DataType.TIGHT, pdf,Regular),
                    graphItemPdf(resultcontroller, DataType.PIG, pdf,Regular),
                    graphItemPdf(resultcontroller, DataType.WATER, pdf,Regular),
                    graphItemPdf(resultcontroller, DataType.OIL, pdf,Regular),
                  ],
                )
              ]),
            ),
          ),
          pw.Expanded(
            flex: 5,
            child: pw.Container(
              margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 0), // Adjust margins
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: pw.Text(
                      "Expert Opinion", // Assuming localization is handled
                      // elsewhere
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                        font: Bold,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    decoration: pw.BoxDecoration(
                      // 테두리 설정: 아래쪽에만 테두리를 추가
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          width: 1, // 테두리 두께
                          color: PdfColors.grey400, // 테두리 색상
                        ),
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(0, 7, 0, 5),
                    child: pw.ListView(
                      children: List<pw.Widget>.generate(
                        resultcontroller.skinResultWebContent.length,
                        (index) => pw.Container(
                          alignment: pw.Alignment.centerLeft, // 좌측 정렬
                          padding: pw.EdgeInsets.symmetric(horizontal: 0),
                          child: pw.Text(
                            sanitizeString(resultcontroller
            .skinResultWebContent[index]),
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              font: Light,
                              fontSize: 7,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                          margin: pw.EdgeInsets.only(bottom: 0),
                        ),
                      ),
                    ),
                  ),
                  pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: pw.Text(
                      "Skin Type Summary", // Assuming localization is
                      // handled elsewhere
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                        font: Bold,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    decoration: pw.BoxDecoration(
                      // 테두리 설정: 아래쪽에만 테두리를 추가
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          width: 1, // 테두리 두께
                          color: PdfColors.grey400, // 테두리 색상
                        ),
                      ),
                    ),
                  ),
                  ...resultcontroller.skinResultContent
                      .map((content) => pw.Container(
                            child: pw.Text(
                              content,
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                font: Light,
                                fontSize: 7,
                                fontWeight: pw.FontWeight.normal,
                              ),
                            ),
                            margin: pw.EdgeInsets.only(bottom: 5),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
          pw.Expanded(
            flex: 7,
            child: pw.Container(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: ingredients)),
          ),
        ]);
      },
    ),
  );

  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, "_blank");
  html.Url.revokeObjectUrl(url);

  // Printing.layoutPdf(
  //   onLayout: (PdfPageFormat format) async => pdf.save(),
  // );
  } catch (e) {
    print("An error occurred while creating the PDF: $e");
    // 에러 처리 로직 추가...
  }
}

pw.Widget graphItemPdf(controller, type, pdf,font) {
  print("$type is start");
  return pw.Column(
    children: [
      pw.Container(
        width: 200,
        margin: pw.EdgeInsets.fromLTRB(0, 5, 0, 3),
        padding: pw.EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: pw.Row(
          children: [
            pw.Expanded(
              flex: 4,
              child: pw.Row(
                children: [
                  pw.Text(
                    controller.getDataName(type), // Placeholder for actual data
                    style: pw.TextStyle(
                      font: font, // Example font
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 4,
              child: pw.Container(),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                "",
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      pw.Container(
        width: 200,
        height: 10,
        child: pw.Stack(
          children: [
            pw.Positioned(
              left: 0,
              top: 0,
              child: pw.Container(
                width: 200,
                height: 10,
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
              ),
            ),
            pw.Positioned(
              left: 0,
              top: 0,
              child: pw.Container(
                width: controller.getPer(type, 200), // Placeholder for actual
                // data
                height: 10,
                decoration: pw.BoxDecoration(
                  color: PdfColors.green,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Text(
                  controller.getPerValue(type, 100).toString() + '%',
                  // Placeholder
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
