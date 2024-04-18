
import 'package:basup_ver2/design/textstyle.dart';
import 'package:basup_ver2/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

showScopedialog(userid) {
  FocusNode referNameFocusNode = FocusNode();

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 18, 24, 5),
      // width: 275.w,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("피부 현미경 촬영", style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("확인을 누르시면 현미경 촬영으로 넘어갑니다.",
                    style: TextStyle(
                        color: const Color(0x80151920),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Pretendard",
                        fontStyle: FontStyle.normal,
                        fontSize: 14),
                    textAlign: TextAlign.center)),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 42,
                width: 97.9,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xffD3D8E1), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(0, 0, 8.6, 10),
                child: new InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "다음에 진행",
                      style: removeuserreject,
                    ),
                  ),
                  onTap: () {
                    Get.offAll(Index());
                  },
                ),
              ),
              Container(
                height: 42,
                width: 120.5,
                margin: EdgeInsets.fromLTRB(8.6, 0, 0, 10),
                decoration: ShapeDecoration(
                  color: Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: InkWell(
                  onTap: () {
                    print("userid :"+ userid);
                    Get.toNamed("/scope?userid="+userid);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("현미경 진행", style: removeuserconfirm),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}


showResultdialog(userid) {
  FocusNode referNameFocusNode = FocusNode();

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 18, 24, 5),
      // width: 275.w,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("피부 데이터 완료", style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("결과보기를 누르시면 결과가 보여집니다.",
                    style: TextStyle(
                        color: const Color(0x80151920),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Pretendard",
                        fontStyle: FontStyle.normal,
                        fontSize: 14),
                    textAlign: TextAlign.center)),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 42,
                width: 97.9,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xffD3D8E1), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(0, 10, 8.6, 10),
                child: new InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "다음에 확인",
                      style: removeuserreject,
                    ),
                  ),
                  onTap: () {
                    Get.offAll(Index());
                  },
                ),
              ),
              Container(
                height: 42,
                width: 120.5,
                margin: EdgeInsets.fromLTRB(8.6, 10, 0, 10),
                decoration: ShapeDecoration(
                  color: Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: InkWell(
                  onTap: () {
                    print("userid :"+ userid);
                    Get.toNamed("/result");
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("결과보기", style: removeuserconfirm),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}



NoDatadialog() {
  FocusNode referNameFocusNode = FocusNode();

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 18, 24, 5),
      // width: 275.w,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("피부 데이터", style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("피부 데이터가 없습니다 피부 문진을 진행해주세요.",
                    style: TextStyle(
                        color: const Color(0x80151920),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Pretendard",
                        fontStyle: FontStyle.normal,
                        fontSize: 14),
                    textAlign: TextAlign.center)),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 42,
                width: 97.9,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xffD3D8E1), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(0, 0, 8.6, 10),
                child: new InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "다음에 진행",
                      style: removeuserreject,
                    ),
                  ),
                  onTap: () {
                    Get.offAll(Index());
                  },
                ),
              ),
              Container(
                height: 42,
                width: 120.5,
                margin: EdgeInsets.fromLTRB(8.6, 0, 0, 10),
                decoration: ShapeDecoration(
                  color: Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/survey");
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("문진 진행", style: removeuserconfirm),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}



faillogindialog() {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 18, 24, 5),
      // width: 275.w,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("로그인 실패", style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("아이디와 비밀번호가 다릅니다\n다시 입력해주세요..",
                    style: TextStyle(
                        color: const Color(0x80151920),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Pretendard",
                        fontStyle: FontStyle.normal,
                        fontSize: 14),
                    textAlign: TextAlign.center)),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 42,
                width: 160.9,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xffD3D8E1), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(0, 10, 8.6, 10),
                child: new InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "다음에 확인",
                      style: removeuserreject,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}




ShowQRdialog(qr_url, routeurl) {
  FocusNode referNameFocusNode = FocusNode();

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 18, 24, 5),
      width: 400,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("현미경 입력", style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("피부 현미경 데이터를 아래의 QR코드를 사용하여\n스마트폰 카메라로 접속해주세요.",
                    style: TextStyle(
                        color: const Color(0x80151920),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Pretendard",
                        fontStyle: FontStyle.normal,
                        fontSize: 14),
                    textAlign: TextAlign.center)),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Center(
              child: QrImage(
                data: qr_url,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 42,
                width: 97.9,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xffD3D8E1), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(0, 0, 8.6, 10),
                child: new InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "다음에 진행",
                      style: removeuserreject,
                    ),
                  ),
                  onTap: () {
                    Get.offAll(Index());
                  },
                ),
              ),
              Container(
                height: 42,
                width: 120.5,
                margin: EdgeInsets.fromLTRB(8.6, 0, 0, 10),
                decoration: ShapeDecoration(
                  color: Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(routeurl);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("홈페이지에서 진행", style: removeuserconfirm),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}



