import 'package:basup_ver2/controller/authcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  // 우선순위(priority)를 지정할 수 있습니다 (숫자가 낮을수록 먼저 실행)
  @override
  int? priority = 0;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    print("AuthMiddleware: 현재 isLoggedIn 값 = ${authController.isLoggedIn.value}, 현재 route = $route");
    if (!authController.isLoggedIn.value) {
      // 로그인하지 않은 경우 '/login' 페이지로 리다이렉트
      return const RouteSettings(name: '/login');
    }
    // 로그인 상태라면 리다이렉트하지 않음
    return null;
  }
}