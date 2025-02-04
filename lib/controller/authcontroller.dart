import 'package:get/get.dart';
import 'package:basup_ver2/controller/sessionmanager.dart';

class AuthController extends GetxController {
  // 로그인 상태를 저장하는 Rx 변수 (초기값은 false)
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // 세션 매니저를 통해 로그인 상태를 확인하고 Rx 변수 업데이트
  void checkLoginStatus() async {
    bool status = await SessionManager.getLoginStatus();
    isLoggedIn.value = status;
  }
}