import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog {
  // 로딩 다이얼로그 표시
  static void show() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  "Loading...",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false, // 외부 터치로 닫히지 않도록 설정
      );
    }
  }

  // 로딩 다이얼로그 닫기
  static void hide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}