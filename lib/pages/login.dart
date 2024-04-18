import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sessionmanager.dart';
import 'package:basup_ver2/pages/customerslistpage.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'as fs;
import 'package:basup_ver2/pages/index.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var resultcontroller = Get.find<ResultController>(tag: "result");

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = await SessionManager.getLoginStatus();
    if (isLoggedIn) {
      // Assuming Index() is your main page after login
      var id = await SessionManager.getLoginaestheticId();
      Future.microtask(() => Get.offAll(CustomersListPage(aestheticId: id,))); // Replace with correct navigation if necessary
    }
  }

  void _login() async {
    final String shopId = _idController.text.trim();
    final String password = _passwordController.text.trim();

    print("login");

    // Assuming you have a 'shops' collection and each shop has an 'id' and 'password'
    final querySnapshot = await fs.FirebaseFirestore.instance
        .collection('aesthetic')
        .where('id', isEqualTo: shopId)
    // .where('password', isEqualTo: hash(password)) // You should hash the password
        .get();

    // Check if at least one document was found
    if (querySnapshot.docs.isNotEmpty) {
      print("find");
      try {
        // Check if at least one document was found
        if (querySnapshot.docs.isNotEmpty) {
          // Assuming 'id' is unique and only one document should match,
          // we'll take the first document found
          var document = querySnapshot.docs.first;
          print(document);

          // Access the document's data
          Map<String, dynamic> documentData = document.data() as Map<
              String,
              dynamic>;

          // Now, you can access individual fields using the field names
          var pw = documentData['pw'];

          if (pw == password) {
            print("login complete");
            SessionManager.setLoginStatus(true, shopId).then((_) {
              resultcontroller.aestheticId.value = shopId;
              Get.offAll(CustomersListPage(aestheticId: shopId));
              // Get.toNamed("/index");
            }).catchError((error) {
              // Handle errors, for example:
              print("Login failed: $error");

              Get.dialog(faillogindialog());
            });
          }
        } else {
          // Handle the case where no documents match the shopId
          print("No matching document found for shopId: $shopId");
          Get.dialog(faillogindialog());
        }
      } catch (e) {
        // 예외가 발생했을 때 실행되는 코드
        print('An error occurred: $e');

        Get.dialog(faillogindialog());
      } finally {
        // 예외 발생 여부와 관계없이 실행되는 코드
        print('This block is always executed');
      }
    }
    else{
      setState(){
        Get.dialog(faillogindialog());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'BASUP \nfor Aesthetic',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
          ),

          Text(
            'BASUP에 연락하여 사전 회원가입을 하고 로그인해주세요',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 17,
              fontWeight: FontWeight.w300,
              shadows: [
              ],
            ),
          ),
          SizedBox(height: 80), // Adjust the spacing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: _idController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '아이디',
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Adjust the spacing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '비밀번호',
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          SizedBox(height: 40), // Adjust the spacing
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Button color
                onPrimary: Colors.white, // Text color
              ),
              onPressed:_login,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),



    );
  }
}
