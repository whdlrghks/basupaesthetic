import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String isLoggedInKey = "isLoggedIn";
  static const String aestheticId = "aestheticId";

  static Future<void> setLoginStatus(bool isLoggedIn,shopId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, isLoggedIn);
    await prefs.setString(aestheticId, shopId);
  }

  static Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  static Future<String> getLoginaestheticId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(aestheticId)??"" ;
  }



  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Set isLoggedIn to false
    await prefs.setBool(isLoggedInKey, false);

    // Optionally, remove all data if you want to clear the SharedPreferences for this app:
    // await prefs.clear();

    // Or if you want to remove only specific data:
    // await prefs.remove('some_other_key');
  }
}
