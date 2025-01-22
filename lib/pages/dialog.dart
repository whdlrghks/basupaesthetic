import 'package:basup_ver2/design/textstyle.dart';
import 'package:basup_ver2/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

showScopedialog(userid) {
  FocusNode referNameFocusNode = FocusNode();

  return Dialog(

    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.0),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('skin_microscope'.tr, style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('confirm_microscope'.tr,
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      'proceed_later'.tr,
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
                    print("userid :" + userid);
                    Get.toNamed("/scope?userid=" + userid);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child:
                        Text('proceed_microscope'.tr, style: removeuserconfirm),
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
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.0),
      ),
    ),
    child: Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 18, 24, 5),
      // width: 275.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('skin_data_complete'.tr, style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('view_results'.tr,
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 42,
                width: 200,
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
                      'check_later'.tr,
                      style: removeuserreject,
                    ),
                  ),
                  onTap: () {
                    Get.offAll(Index());
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

NoDatadialog() {
  FocusNode referNameFocusNode = FocusNode();

  return Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.0),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('no_skin_data'.tr, style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('no_skin_data_comment'.tr,
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      'proceed_later'.tr,
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
                    child: Text('proceed_questionnaire'.tr,
                        style: removeuserconfirm),
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

NetworkErrorDialog() {
  return Dialog(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.0),
      ),
    ),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 타이틀
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              // "network_error".tr 등 번역키 추가 가능
              child: Text("error_occurred".tr, style: removeusertitle),
            ),
          ),

          // 본문(메시지)
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "error_text".tr,
                style: const TextStyle(
                  color: Color(0x80151920),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // 버튼들
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // "확인" or "닫기" 버튼
                Container(
                  height: 42,
                  width: 120.5,
                  margin: const EdgeInsets.fromLTRB(8.6, 0, 0, 10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF34A853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Dialog 닫기만 진행 (사용자가 재시도 시에
                      // 호출부에서 다시 fetchCalculateAILookup 등 진행 가능)
                      Get.back();
                      Get.offAllNamed('/index');
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        // "확인" - 번역키 사용 시 변경 가능
                        'check_later'.tr,
                        style: removeuserconfirm,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

faillogindialog() {
  return Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.0),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('login_fail'.tr, style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('login_fail_comment'.tr,
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      'check_later'.tr,
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
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.0),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('microscope_input'.tr, style: removeusertitle),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('connect_via_qr'.tr,
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
              child: QrImageView(
                data: qr_url,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      'proceed_later'.tr,
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
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child:
                          Text('proceed_homepage'.tr, style:
                          removeuserconfirm,
                            textAlign: TextAlign.center,),
                    ),
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
