import 'dart:async';

import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/container.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:basup_ver2/pages/surveyshortform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:camera/camera.dart';



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

  // 여러 장 저장용: LED, UV 각각 Left/Right
  RxList<html.File> headLedFiles = <html.File>[].obs;
  RxList<html.File> headUvFiles = <html.File>[].obs;
  RxList<html.File> leftLedFiles = <html.File>[].obs;
  RxList<html.File> rightLedFiles = <html.File>[].obs;
  RxList<html.File> leftUvFiles = <html.File>[].obs;
  RxList<html.File> rightUvFiles = <html.File>[].obs;

  @override
  Future<void> initState() async {
    // TODO: implement initState
    super.initState();

    resultcontroller.initscope();

    final userid = Get.parameters['userid'] ?? '';
    resultcontroller.user_id.value = userid;

    final survey_id = Get.parameters['survey_id'] ?? '';
    resultcontroller.survey_id.value = survey_id;
    await _fetchSurveyData(survey_id);

  }
  // // Function to open the camera and set the file
  // void openCamera(void Function(html.File) setFile, _flag) {
  //   var input = html.FileUploadInputElement()
  //     ..accept = 'image/*'
  //     ..setAttribute('capture', 'environment');
  //   input.click();
  //   input.onChange.listen((event) {
  //     final files = input.files;
  //     if (files != null && files.isNotEmpty) {
  //       final file = files.first;
  //       setFile(file); // Use the callback to set the file
  //       _flag.value = true;
  //     }
  //   });
  // }

  /// (1) 공통: 열어서 여러 장 파일을 리스트에 추가
  void openCameraAndAppend(RxList<html.File> fileList, RxBool flag) {

    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..multiple = true
      ..setAttribute('file', 'environment');
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        // 한 번에 여러 개 선택 가능
        for (final file in files) {
          fileList.add(file);
        }
        // flag = true (이미 찍음)
        flag.value = fileList.isNotEmpty;
        setState(() {});
      }
    });
  }


  /// (2) 공통: “촬영” 버튼 + 썸네일 목록
  ///    captureLabel, recaptureLabel: i18n 문구
  ///    fileList: 저장할 목록
  ///    flag: RxBool(한 번이라도 찍었는지)
  Widget buildCaptureSection({
    required String captureLabel,
    required String recaptureLabel,
    required RxList<html.File> fileList,
    required RxBool flag,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 촬영/재촬영 버튼
        Obx(() {
          final label = flag.value ? recaptureLabel : captureLabel;
          return ElevatedButton(
            onPressed: () => openCameraAndAppend(fileList, flag),
            child: Text(label),
          );
        }),
        // 썸네일 목록
        buildThumbnails(fileList),
      ],
    );
  }

  /// (3) 파일 리스트 → 썸네일 표시
  Widget buildThumbnails(List<html.File> files) {
    if (files.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: files.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;
          return FutureBuilder<String>(
            future: _convertFileToDataUrl(file),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final dataUrl = snapshot.data!;
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      dataUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          files.removeAt(index);
                        });
                      },
                      child: Container(
                        color: Colors.black54,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }).toList(),
      ),
    );
  }

  /// html.File -> base64 dataUrl 변환
  Future<String> _convertFileToDataUrl(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<String>();
    reader.onLoadEnd.listen((_) {
      completer.complete(reader.result as String);
    });
    reader.readAsDataUrl(file);
    return completer.future;
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
  /// Firestore에서 survey_id에 해당하는 데이터를 조회하여
  /// aestheticId, age, name, sex, user_id 값을 resultcontroller에 저장하는 함수
  Future<void> _fetchSurveyData(String surveyId) async {
    try {
      // 'surveys' 컬렉션에서 survey_id가 일치하는 문서를 검색
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('surveys') // 실제 컬렉션 이름으로 변경 필요
          .where('survey_id', isEqualTo: surveyId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // 첫 번째 문서의 데이터를 Map<String, dynamic>로 가져옴
        final data = snapshot.docs.first.data() as Map<String, dynamic>;

        // Firestore에서 가져온 데이터를 resultcontroller에 저장
        resultcontroller.aestheticId.value = data['aestheticId'];
        resultcontroller.age.value = data['age'];
        resultcontroller.name.value = data['name'];
        // 만약 resultcontroller에 gender 대신 sex 변수가 있다면 그대로 저장하고,
        // 아니라면 Gender enum으로 변환하는 등 적절히 조정하세요.
        resultcontroller.gender.value = (data['sex'] == "M") ? Gender.M :
        Gender.W;
        resultcontroller.user_id.value = data['user_id'];
      } else {
        print("No survey data found for survey_id: $surveyId");
      }
    } catch (error) {
      print("Error fetching survey data: $error");
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 40),
              Subtitle("skin_microscope".tr, controller),
              QuestionTitle("open_camera".tr,controller),

              scopeButton(abletitle : "capture_head_led".tr,disabletitle: "re"
                  "capture_head_led"
                  .tr,
                flag: resultcontroller.head_led_flag,
                fileList: headLedFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },
              ),
              scopeButton(abletitle : "capture_left_led".tr,disabletitle: "recapture_left_led"
                  .tr,
                flag: resultcontroller.left_led_flag,
                fileList: leftLedFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },
              ),
              scopeButton(abletitle :"capture_right_led".tr, disabletitle:"recapture_right_led".tr,
                flag:  resultcontroller
                    .right_led_flag,
                fileList: rightLedFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },),
              // scopeButton("capture_head_led".tr, "recapture_head_led".tr,
              //     resultcontroller
              //     .head_led_flag,resultcontroller.head_led,
              //     openCamera, (file) => setState(() => headLedFile = file)),
              scopeButton(abletitle : "capture_head_uv".tr,disabletitle: "recapture_head_uv"
                  .tr,
                flag: resultcontroller.head_uv_flag,
                fileList: headUvFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },
              ),
              scopeButton(abletitle :"capture_left_uv".tr, disabletitle:"recapture_left_uv".tr,
                flag: resultcontroller
                    .left_uv_flag,
                fileList: leftUvFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },),
              scopeButton(abletitle :"capture_right_uv".tr,disabletitle: "recapture_right_uv".tr,
                flag: resultcontroller
                    .right_uv_flag,
                fileList: rightUvFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },),
              // scopeButton("capture_head_uv".tr, "recapture_head_uv".tr,
              //     resultcontroller
              //     .head_uv_flag,resultcontroller.head_uv,
              //     openCamera, (file) => setState(() => headUvFile = file)),
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
    var survey_id = resultcontroller.survey_id.value;
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

    // 2) [다중 업로드] RxList 항목들을 업로드 등록
    // 예: Left LED (다중)
    for (int i = 0; i < leftLedFiles.length; i++) {
      final file = leftLedFiles[i];
      // 구분을 위해 type을 'left_led_$i'로 지정
      addUploadTask(file, 'left_led_$i', 'leftLed');
    }

    // Right LED (다중)
    for (int i = 0; i < rightLedFiles.length; i++) {
      final file = rightLedFiles[i];
      addUploadTask(file, 'right_led_$i', 'rightLed');
    }

    // Head LED (다중)
    for (int i = 0; i < headLedFiles.length; i++) {
      final file = headLedFiles[i];
      addUploadTask(file, 'head_led_$i', 'headLed');
    }

    // Left UV (다중)
    for (int i = 0; i < leftUvFiles.length; i++) {
      final file = leftUvFiles[i];
      addUploadTask(file, 'left_uv_$i', 'leftUv');
    }

    // Right UV (다중)
    for (int i = 0; i < rightUvFiles.length; i++) {
      final file = rightUvFiles[i];
      addUploadTask(file, 'right_uv_$i', 'rightUv');
    }

    // Head UV (다중)
    for (int i = 0; i < headUvFiles.length; i++) {
      final file = headUvFiles[i];
      addUploadTask(file, 'head_uv_$i', 'headUv');
    }
    try {
      print("try");
      // 3) 모든 업로드 병렬 실행
      List<String> urls = await Future.wait(uploadTasks);
      // urls 길이 == uploadTasks 길이 == uploadTypes 길이

      // 예: 여러 장 URL을 임시 저장할 리스트들
      List<String> leftLedUrls = [];
      List<String> rightLedUrls = [];
      List<String> headLedUrls = [];
      List<String> leftUvUrls = [];
      List<String> rightUvUrls = [];
      List<String> headUvUrls = [];

      // 4) 업로드 완료 후, 각 URL을 타입별로 분류
      for (int i = 0; i < urls.length; i++) {
        final url = urls[i];
        final t = uploadTypes[i];
        print("업로드 완료: type=$t, url=$url");

        if (t.startsWith("left_led_")) {
          // leftLedFiles에 해당하는 다중 URL
          leftLedUrls.add(url);
        } else if (t.startsWith("right_led_")) {
          rightLedUrls.add(url);
        } else if (t.startsWith("head_led_")) {
          headLedUrls.add(url);
        } else if (t.startsWith("left_uv_")) {
          leftUvUrls.add(url);
        } else if (t.startsWith("right_uv_")) {
          rightUvUrls.add(url);
        } else if (t.startsWith("head_uv_")) {
          headUvUrls.add(url);
        }
        // 단일 파일 (기존)인 경우
        else if (t == 'single_left_led') {
          resultcontroller.left_led = url;
        } else if (t == 'single_right_led') {
          resultcontroller.right_led = url;
        }
      }
      print("finish");
      resultcontroller.left_led_list = leftLedUrls;
      resultcontroller.right_led_list = rightLedUrls;
      resultcontroller.head_led_list = headLedUrls;
      resultcontroller.left_uv_list = leftUvUrls;
      resultcontroller.right_uv_list = rightUvUrls;
      resultcontroller.head_uv_list = headUvUrls;

      resultcontroller.scope_id = user_id+"_"+survey_id+"_"+now.toString();

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
