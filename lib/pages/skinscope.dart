import 'dart:async';

import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/container.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/pages/surveyshortform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'dart:js' as js;



class SkinScope extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SkinScopeState();
  }
}

class _SkinScopeState extends State<SkinScope> {
  var controller = Get.find<SizeController>(tag: "size");
  var resultcontroller = Get.find<ResultController>(tag: "result");

  html.File? leftLedFile, rightLedFile, headLedFile, leftUvFile, rightUvFile, headUvFile;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    resultcontroller.initscope();

  }
  // Function to open the camera and set the file
  void openCamera(void Function(html.File) setFile, _flag) {
    var input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..setAttribute('capture', 'environment');
    input.click();
    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files.first;
        setFile(file); // Use the callback to set the file
        _flag.value = true;
      }
    });
  }

  // Function to handle taking pictures
  // void takePicture() {
  //   html.FileUploadInputElement input = html.FileUploadInputElement()
  //     ..accept = 'image/*'
  //     ..capture = true;
  //   input.click();
  //
  //   input.onChange.listen((event) {
  //     final file = input.files!.first;
  //     final reader = html.FileReader();
  //     reader.readAsDataUrl(file);
  //     reader.onLoadEnd.listen((event) {
  //       setState(() {
  //         imageUrl = reader.result as String?;
  //       });
  //     });
  //   });
  // }

  // Function to detect if the user is on a mobile device
  bool isMobileDevice() {
    var userAgent = html.window.navigator.userAgent.toString().toLowerCase();
    return userAgent.contains("iphone") || userAgent.contains("android");
  }



  @override
  Widget build(BuildContext context) {
    controller.width(MediaQuery.of(context).size.width.toInt());
    controller.height(MediaQuery.of(context).size.height.toInt());

    var userid = Get.parameters['userid'];
    resultcontroller.user_id.value= userid!;
    print(userid);

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          BlankTopProGressMulti(controller),
          BlankTopGap(controller),
          Subtitle("skin_microscope".tr, controller),
          QuestionTitle("open_camera".tr,
              controller),
          scopeButton("capture_left_led".tr, "recapture_left_led".tr,
              resultcontroller
              .left_led_flag,resultcontroller.left_led,
              openCamera, (file) => setState(() => leftLedFile = file)),
          scopeButton("capture_right_led".tr, "recapture_right_led".tr,
              resultcontroller
              .right_led_flag, resultcontroller.right_led,
              openCamera, (file) => setState(() => rightLedFile = file)),
          scopeButton("capture_head_led".tr, "recapture_head_led".tr,
              resultcontroller
              .head_led_flag,resultcontroller.head_led,
              openCamera, (file) => setState(() => headLedFile = file)),
          scopeButton("capture_left_uv".tr, "recapture_left_uv".tr,
              resultcontroller
              .left_uv_flag,resultcontroller.left_uv,
              openCamera, (file) => setState(() => leftUvFile = file)),
          scopeButton("capture_right_uv".tr, "recapture_right_uv".tr,
              resultcontroller
              .right_uv_flag,resultcontroller.right_uv,
              openCamera, (file) => setState(() => rightUvFile = file)),
          scopeButton("capture_head_uv".tr, "recapture_head_uv".tr,
              resultcontroller
              .head_uv_flag,resultcontroller.head_uv,
              openCamera, (file) => setState(() => headUvFile = file)),
          SubmitScopeButton("submit".tr, resultcontroller, onPressedButton)
        ],
      )),
    );
  }
  Future<String> uploadFileAndRetrieveURL(html.File file, String uploadPath,
  ) {
    var completer = Completer<String>();

    js.context.callMethod('uploadFileToStorage', [
      uploadPath,
      file,
         js.allowInterop( (result,error) {
        if (result != null) {
          completer.complete(result);
        } else {
          completer.completeError("Failed to upload file and retrieve URL "
              "${error}");
        }
      }),
    ]);

    return completer.future;
  }

  onPressedButton() async {

    _showLoadingDialog(context); // Show the loading dialog
    var user_id = resultcontroller.user_id.value;
    var now = DateTime.now().millisecondsSinceEpoch;

    // Keep track of which uploads correspond to which properties in resultcontroller
    List<String> uploadTypes = [];
    List<Future<String>> uploadTasks = [];

    void addUploadTask(html.File? file, String type, String basePath) {
      if (file != null) {
        String uploadPath = "images/$user_id/$basePath/${user_id}_$now.jpg";
        uploadTasks.add(uploadFileAndRetrieveURL(file, uploadPath));
        uploadTypes.add(type);
      }
    }

    addUploadTask(leftLedFile, 'left_led', 'leftLed');
    addUploadTask(rightLedFile, 'right_led', 'rightLed');
    addUploadTask(headLedFile, 'head_led', 'headLed');
    addUploadTask(leftUvFile, 'left_uv', 'leftUv');
    addUploadTask(rightUvFile, 'right_uv', 'rightUv');
    addUploadTask(headUvFile, 'head_uv', 'headUv');
    print("a");
    try {
      print("try");
      List<String> urls = await Future.wait(uploadTasks);
      for (int i = 0; i < urls.length; i++) {
        String type = uploadTypes[i];
        String url = urls[i];
        print("url : ${url}");

        // Using reflection or a conditional approach to assign URLs to their corresponding variable in resultcontroller
        switch (type) {
          case 'left_led':
            resultcontroller.left_led = url;
            break;
          case 'right_led':
            resultcontroller.right_led = url;
            break;
          case 'head_led':
            resultcontroller.head_led = url;
            break;
          case 'left_uv':
            resultcontroller.left_uv = url;
            break;
          case 'right_uv':
            resultcontroller.right_uv = url;
            break;
          case 'head_uv':
            resultcontroller.head_uv = url;
            break;
        }
      }
      print("finish");

      resultcontroller.scope_id = user_id+"_"+now.toString();

      print("resultcontroller.scope_id");
      await createSkinScope(resultcontroller);
      // At this point, all URLs have been assigned to their respective variables in resultcontroller.
      // Proceed with any additional logic, now that all uploads are complete and URLs are saved.
    } catch (e) {
      print("An error occurred during file uploads: $e");
      Get.dialog(Test("An error occurred during file uploads: $e"));
      // Handle any errors that occurred during the uploads
    }finally {
      Get.back(); // Dismiss the loading dialog

      return Get.dialog(showResultdialog(user_id));
    }

  }
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from being dismissed
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('uploading_data'.tr),
            ],
          ),
        ),
      );
    },
  );
}


Test(index) {
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
      child:
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("test"+index, ),
            ),
          ),
      ),
  );
}
