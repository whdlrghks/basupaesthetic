import 'dart:async';
import 'dart:typed_data';

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
import 'package:firebase_storage/firebase_storage.dart';
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
  final RxDouble _uploadProgressRx = 0.0.obs;


  html.File? leftLedFile, rightLedFile, headLedFile, leftUvFile, rightUvFile,
      headUvFile;

  // 여러 장 저장용: LED, UV 각각 Left/Right
  RxList<html.File> headLedFiles = <html.File>[].obs;
  RxList<html.File> headUvFiles = <html.File>[].obs;
  RxList<html.File> leftLedFiles = <html.File>[].obs;
  RxList<html.File> rightLedFiles = <html.File>[].obs;
  RxList<html.File> leftUvFiles = <html.File>[].obs;
  RxList<html.File> rightUvFiles = <html.File>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initializeData();
  }

  void _initializeData() async {
    resultcontroller.initscope();

    final userid = Get.parameters['userid'] ?? '';
    resultcontroller.user_id.value = userid;

    final survey_id = Get.parameters['survey_id'] ?? '';
    resultcontroller.survey_id.value = survey_id;

    final name = Get.parameters['name'] ?? '';
    resultcontroller.name.value = name;

    _uploadProgressRx.value = 0.0;

    // 비동기 작업 실행
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
        children: files
            .asMap()
            .entries
            .map((entry) {
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
              QuestionTitle("open_camera".tr, controller),

              scopeButton(
                abletitle: "capture_head_led".tr,
                disabletitle: "re"
                    "capture_head_led"
                    .tr,
                flag: resultcontroller.head_led_flag,
                fileList: headLedFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },
              ),
              scopeButton(
                abletitle: "capture_left_led".tr,
                disabletitle: "recapture_left_led"
                    .tr,
                flag: resultcontroller.left_led_flag,
                fileList: leftLedFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },
              ),
              scopeButton(
                abletitle: "capture_right_led".tr,
                disabletitle: "recapture_right_led".tr,
                flag: resultcontroller
                    .right_led_flag,
                fileList: rightLedFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },),
              // scopeButton("capture_head_led".tr, "recapture_head_led".tr,
              //     resultcontroller
              //     .head_led_flag,resultcontroller.head_led,
              //     openCamera, (file) => setState(() => headLedFile = file)),
              scopeButton(
                abletitle: "capture_head_uv".tr,
                disabletitle: "recapture_head_uv"
                    .tr,
                flag: resultcontroller.head_uv_flag,
                fileList: headUvFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },
              ),
              scopeButton(
                abletitle: "capture_left_uv".tr,
                disabletitle: "recapture_left_uv".tr,
                flag: resultcontroller
                    .left_uv_flag,
                fileList: leftUvFiles,
                onPressedButton: (files, flag) {
                  openCameraAndAppend(files, flag);
                },),
              scopeButton(
                abletitle: "capture_right_uv".tr,
                disabletitle: "recapture_right_uv".tr,
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

  // Future<String> uploadFileAndRetrieveURL(html.File file, String uploadPath,
  //     {Function(double)? onProgress}) {
  //   var completer = Completer<String>();
  //
  //   // JS 메서드가 progress 인자를 제공한다고 가정
  //   js.context.callMethod('uploadFileToStorage', [
  //     uploadPath,
  //     file,
  //     js.allowInterop((result, error, progress) {
  //       if (progress != null && onProgress != null) {
  //         onProgress(progress); // 진행률 업데이트
  //       }
  //       if (result != null) {
  //         completer.complete(result);
  //       } else {
  //         completer.completeError("Failed to upload file: ${error}");
  //       }
  //     }),
  //   ]);
  //   return completer.future;
  // }


  /// Firebase Storage를 사용하여 파일 업로드하는 함수
  Future<String> uploadFileAndRetrieveURL(html.File file,
      String uploadPath, {
        Function(double)? onProgress,
      }) async {
    // html.File을 Uint8List로 변환
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();

    reader.onLoadEnd.listen((event) {
      if (reader.result != null) {
        completer.complete(reader.result as Uint8List);
      } else {
        completer.completeError("File reading error");
      }
    });
    reader.readAsArrayBuffer(file);
    Uint8List fileBytes = await completer.future;

    // Firebase Storage 참조 생성 및 업로드 시작
    Reference storageRef = FirebaseStorage.instance.ref().child(uploadPath);
    UploadTask uploadTask = storageRef.putData(fileBytes);

    // 진행률 업데이트
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      if (onProgress != null) {
        onProgress(progress);
      }
    });

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  onPressedButton() async {
    _showLoadingDialog(); // Show the loading dialog
    var user_id = resultcontroller.user_id.value;
    var survey_id = resultcontroller.survey_id.value;
    var now = DateTime
        .now()
        .millisecondsSinceEpoch;

    // Keep track of which uploads correspond to which properties in resultcontroller
    List<String> uploadTypes = [];
    List<Future<String>> uploadTasks = [];

    // 각 태스크의 진행률을 저장할 리스트
    List<double> taskProgress = [];

    // 로그: 각 파일 리스트의 길이 출력
    print("=== 업로드 시작 ===");
    print("leftLedFiles count: ${leftLedFiles.length}");
    print("rightLedFiles count: ${rightLedFiles.length}");
    print("headLedFiles count: ${headLedFiles.length}");
    print("leftUvFiles count: ${leftUvFiles.length}");
    print("rightUvFiles count: ${rightUvFiles.length}");
    print("headUvFiles count: ${headUvFiles.length}");

    // 업로드 태스크 추가 함수
    void addUploadTask(html.File? file, String type, String basePath, int idx) {
      if (file != null) {
        print("Adding task - type: $type, file: ${file.name}");
        String uploadPath = "images/$user_id/$basePath/${user_id}_${now}_${idx}.jpg";
        int currentIndex = taskProgress.length;
        taskProgress.add(0.0);
        uploadTasks.add(
            uploadFileAndRetrieveURL(
                file, uploadPath, onProgress: (progressValue) {
              taskProgress[currentIndex] = progressValue;
              double overallProgress = taskProgress.reduce((a, b) => a + b) /
                  taskProgress.length;
              _uploadProgressRx.value = overallProgress; // 여기서 reactive 변수 업데이트
            })
        );
        uploadTypes.add(type);
      }
    }

    // (1) Left LED (다중)
    for (int i = 0; i < leftLedFiles.length; i++) {
      final file = leftLedFiles[i];
      print("leftLedFiles[$i]: ${file.name}");
      addUploadTask(file, 'left_led_$i', 'leftLed', i);
    }

    // (2) Right LED (다중)
    for (int i = 0; i < rightLedFiles.length; i++) {
      final file = rightLedFiles[i];
      print("rightLedFiles[$i]: ${file.name}");
      addUploadTask(file, 'right_led_$i', 'rightLed', i);
    }

    // (3) Head LED (다중)
    for (int i = 0; i < headLedFiles.length; i++) {
      final file = headLedFiles[i];
      print("headLedFiles[$i]: ${file.name}");
      addUploadTask(file, 'head_led_$i', 'headLed', i);
    }

    // (4) Left UV (다중)
    for (int i = 0; i < leftUvFiles.length; i++) {
      final file = leftUvFiles[i];
      print("leftUvFiles[$i]: ${file.name}");
      addUploadTask(file, 'left_uv_$i', 'leftUv', i);
    }

    // (5) Right UV (다중)
    for (int i = 0; i < rightUvFiles.length; i++) {
      final file = rightUvFiles[i];
      print("rightUvFiles[$i]: ${file.name}");
      addUploadTask(file, 'right_uv_$i', 'rightUv', i);
    }

    // (6) Head UV (다중)
    for (int i = 0; i < headUvFiles.length; i++) {
      final file = headUvFiles[i];
      print("headUvFiles[$i]: ${file.name}");
      addUploadTask(file, 'head_uv_$i', 'headUv', i);
    }

    // 전체 업로드 태스크 개수 로그 출력
    print("Total upload tasks: ${uploadTasks.length}");

    try {
      print("업로드 시작: Future.wait() 호출");
      // 모든 업로드 병렬 실행
      List<String> urls = await Future.wait(uploadTasks);
      print("모든 업로드 완료. 업로드된 URL 개수: ${urls.length}");

      // 각 URL을 타입별로 분류
      List<String> leftLedUrls = [];
      List<String> rightLedUrls = [];
      List<String> headLedUrls = [];
      List<String> leftUvUrls = [];
      List<String> rightUvUrls = [];
      List<String> headUvUrls = [];

      for (int i = 0; i < urls.length; i++) {
        final url = urls[i];
        final t = uploadTypes[i];
        print("업로드 완료: type=$t, url=$url");

        if (t.startsWith("left_led_")) {
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
        } else if (t == 'single_left_led') {
          resultcontroller.left_led = url;
        } else if (t == 'single_right_led') {
          resultcontroller.right_led = url;
        }
      }

      // 결과값을 resultcontroller에 저장
      resultcontroller.left_led_list = leftLedUrls;
      resultcontroller.right_led_list = rightLedUrls;
      resultcontroller.head_led_list = headLedUrls;
      resultcontroller.left_uv_list = leftUvUrls;
      resultcontroller.right_uv_list = rightUvUrls;
      resultcontroller.head_uv_list = headUvUrls;

      resultcontroller.scope_id =
          user_id + "_" + survey_id + "_" + now.toString();
      print("생성된 scope_id: ${resultcontroller.scope_id}");

      _uploadProgressRx.value = 1.0;

      print("resultcontroller.scope_id");
      Get.back(); // Dismiss the loading dialog
      await createSkinScope(resultcontroller);
      // At this point, all URLs have been assigned to their respective variables in resultcontroller.
      // Proceed with any additional logic, now that all uploads are complete and URLs are saved.
    } catch (e) {
      print("An error occurred during file uploads: $e");
      Get.dialog(Test("An error occurred during file uploads: $e"));
      // Handle any errors that occurred during the uploads
    } finally {
      Get.back(); // Dismiss the loading dialog

      return Get.dialog(showResultdialog(user_id));
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Flexible(
                child: Obx(() =>
                    Text(
                      'uploading_data'.tr +
                          '  ${(_uploadProgressRx.value * 100).toStringAsFixed(
                              0)}%',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
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
