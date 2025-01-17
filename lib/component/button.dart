import 'dart:async';

import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/textstyle.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

backKey({bool fromResult =false }){

  return Container(
    padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
    child: new InkWell(
      child: Image(
        image: AssetImage('assets/backkey.png'),
        width: 20,
        height: 20,
        fit: BoxFit.fill,
      ),
      onTap: (){
        fromResult ? Get.offAllNamed('/index') : Get.back();
      },
    ),
  );
}

EnrollPicture(title, controller) {
  return Row(mainAxisAlignment: MainAxisAlignment.center,
      // width: present_width,
      children: [
        Container(
          height: 90,
          width: 350,
          padding: EdgeInsets.fromLTRB(0, 33, 0, 1),
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith(
                (states) {
                  return 0;
                },
              ),
              side: MaterialStateProperty.resolveWith(
                (states) {
                  return const BorderSide(
                    width: 1.0,
                    color: Color(0xffd1d1d1),
                  );
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return Colors.white;
              }),
              shape: MaterialStateProperty.resolveWith(
                (states) {
                  return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8));
                },
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FlutterLogo(size: 18),
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xffadadad),
                    fontSize: 14,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            onPressed: () async {},
          ),
        ),
      ]);
}

UnselectedAnswer(
    surveycontroller, idx, currentItem, pressed, onSubmit, answercheck) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(
      width: 300,
      height: 85,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 14),
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            } else {
              return button_disabled;
            }
          }),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return BorderSide(width: 1, color: button_disabled);
            } else {
              return BorderSide(width: 1, color: button_disabled);
            }
          }),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.green;
            } else {
              return Colors.white;
            }
          }),
          elevation: MaterialStateProperty.resolveWith(
            (states) {
              return 0;
            },
          ),
          shape: MaterialStateProperty.resolveWith(
            (states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              );
            },
          ),
        ),
        child: Text(
          currentItem.answerList[idx - 1],
        ),
        onPressed: () async {
          currentItem.setUserAnswer(idx);
          if (surveycontroller.questionsize.value >
              surveycontroller.current_idx+1 ) {
            surveycontroller.current_idx = surveycontroller.current_idx + 1;
            pressed();
          } else {
            onSubmit(idx);
          }
        },
      ),
    ),
  ]);
}

SelectedAnswer(surveycontroller, idx, currentItem, pressed, answercheck) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(
      width: 300,
      height: 85,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 14),
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            return Colors.white;
          }),
          side: MaterialStateProperty.resolveWith((states) {
            return BorderSide(width: 1, color: button_disabled);
          }),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return Colors.green;
          }),
          elevation: MaterialStateProperty.resolveWith(
            (states) {
              return 0;
            },
          ),
          shape: MaterialStateProperty.resolveWith(
            (states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              );
            },
          ),
        ),
        child: Text(
          currentItem.answerList[idx - 1],
          style: TextStyle(
            fontFamily: "Pretendard",
          ),
        ),
        onPressed: () async {
          currentItem.setUserAnswer(idx);
          if (surveycontroller.questionsize.value >
              surveycontroller.current_idx+1 ) {
            surveycontroller.current_idx = surveycontroller.current_idx + 1;
            pressed();
          } else {
          }
        },
      ),
    ),
  ]);
}

NextButton(title,  surveycontroller, onPressedButton) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Obx(
        () => Container(
          height: 90,
          width: 350,
          padding: EdgeInsets.fromLTRB(0, 33, 0, 1),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (surveycontroller.shortform.value) {
                  return button_abled;
                } else {
                  return button_disabled;
                }
              }),
              shape: MaterialStateProperty.resolveWith(
                (states) {
                  return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9));
                },
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed:
                surveycontroller.shortform.value ? onPressedButton : null,
          ),
        ),
      ),
    ],
  );
}


Widget scopeButton({
  required String abletitle,
  required String disabletitle,
  required RxBool flag,
  required RxList<html.File> fileList,
  // 여러 장 촬영 함수
  required void Function(RxList<html.File> fileList, RxBool flag)
  onPressedButton,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
                () => Container(
              height: 90,
              width: 350,
              padding: EdgeInsets.fromLTRB(0, 33, 0, 1),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (!flag.value) {
                      return button_abled;
                    } else {
                      return button_disabled;
                    }
                  }),
                  shape: MaterialStateProperty.resolveWith((states) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9));
                  }),
                ),
                child: Text(
                  flag.value ? disabletitle : abletitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  // 콜백을 통해 파일 리스트에 이미지 추가
                  onPressedButton(fileList, flag);
                },
              ),
            ),
          ),
        ],
      ),
      // 촬영된 파일을 썸네일로 표시/삭제
      _buildThumbnails(fileList, flag),
    ],
  );
}

/// 여러 장 찍힌 파일을 썸네일로 보여주고 삭제할 수 있는 위젯
Widget _buildThumbnails( RxList<html.File> files, flag// <-- callback to parent
) {
  if (files.isEmpty) {
    return SizedBox.shrink();
  }
  return Obx(() => Padding(
    padding: const EdgeInsets.only(top: 8),
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
                // 썸네일 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    dataUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                // 삭제 버튼(X)
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Instead of setState here, call [onRemove(index)] so parent can remove item & rebuild
                      files.removeAt(index);
                      if(files.isEmpty){
                        flag.value = false;
                      }
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
  ),);
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

SubmitScopeButton(title,  controller, onPressedButton) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Obx(
            () => Container(
          height: 90,
          width: 350,
          padding: EdgeInsets.fromLTRB(0, 33, 0, 1),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (controller.left_led_flag.value && controller.right_led_flag
                    .value && controller.head_led_flag.value && controller.left_uv_flag.value && controller.right_uv_flag
                    .value && controller.head_uv_flag.value) {
                  return button_abled;
                } else {
                  return button_disabled;
                }
              }),
              shape: MaterialStateProperty.resolveWith(
                    (states) {
                  return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9));
                },
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: controller.left_led_flag.value && controller.right_led_flag
                .value && controller.head_led_flag.value && controller.left_uv_flag.value && controller.right_uv_flag
                .value && controller.head_uv_flag.value ? onPressedButton : null,
          ),
        ),
      ),
    ],
  );
}

FirstNextButton(title,  controller, onPressedButton) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Obx(
            () => Container(
          height: 90,
          width: 350,
          padding: EdgeInsets.fromLTRB(0, 33, 0, 1),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (controller.name_check.value && controller.gendercheck
                    .value && controller.selectedDatecheck.value) {
                  return button_abled;
                } else {
                  return button_disabled;
                }
              }),
              shape: MaterialStateProperty.resolveWith(
                    (states) {
                  return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9));
                },
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: controller.name_check.value && controller.gendercheck
                .value && controller.selectedDatecheck.value ? onPressedButton : null,
          ),
        ),
      ),
    ],
  );
}

BackPressButton(title, controller, surveycontroller, onPressed) {
  return Center(
    child: CupertinoButton(
        child: Text(
          title,
          style: TextStyle(
            color: Color(0xffd1d1d1),
            fontSize: 18,
            fontFamily: "Pretendard",
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: onPressed),
  );
}

SubmitButton(title, controller, surveycontroller, onPressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 14),
        width: 300,
        child: CupertinoButton(
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                  style: TextStyle(
                    color: button_abled,
                    fontSize: 18,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500,
                  ),
                  text: title),
            ),
            onPressed: onPressed),
      ),
    ],
  );
}

RetryButton(onPressedButton) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
    child: ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith((states) {
          return const Size(115, 44);
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return retry_Button_Color;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return retry_Button_Color;
        }),
        shadowColor: MaterialStateProperty.resolveWith((states) {
          return retry_Button_Color;
        }),
        shape: MaterialStateProperty.resolveWith(
          (states) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9));
          },
        ),
      ),
      child: Text(
        '구매하기',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF49A85E),
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: onPressedButton,
    ),
  );
}

SetSkintypeButton(onPressedButton) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
    child: ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith((states) {
          return const Size(165, 44);
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        shadowColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        shape: MaterialStateProperty.resolveWith(
          (states) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9));
          },
        ),
      ),
      child: Text(
        '앱으로 확인하기',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: onPressedButton,
    ),
  );
}

MoreInfoButton(onPressedButton) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 18),
    child: ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith((states) {
          return const Size(302, 44);
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        shadowColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        shape: MaterialStateProperty.resolveWith(
          (states) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9));
          },
        ),
      ),
      child: Text(
        '베이스업이 궁금하다면?',
        style: skinmoreinfo_button,
      ),
      onPressed: onPressedButton,
    ),
  );
}

buyButton(onPressedButton) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 18),
    child: ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith((states) {
          return const Size(302, 44);
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        shadowColor: MaterialStateProperty.resolveWith((states) {
          return survey_subtitle;
        }),
        shape: MaterialStateProperty.resolveWith(
              (states) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9));
          },
        ),
      ),
      child: Text(
        '체험권 구매하러가기',
        style: skinmoreinfo_button,
      ),
      onPressed: onPressedButton,
    ),
  );
}


MachineSubmitButton(title,  controller, onPressedButton) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Obx(
            () => Container(
          height: 90,
          width: 350,
          padding: EdgeInsets.fromLTRB(0, 33, 0, 1),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (controller.water_machine_flag.value && controller.oil_machine_flag
                    .value && controller.wrinkle_machine_flag.value && controller.pore_machine_flag.value && controller.corneous_machine_flag
                    .value && controller.blemishes_machine_flag.value  && controller.sebum_machine_flag.value) {
                  return button_abled;
                } else {
                  return button_disabled;
                }
              }),
              shape: MaterialStateProperty.resolveWith(
                    (states) {
                  return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9));
                },
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: controller.water_machine_flag.value && controller.oil_machine_flag
                .value && controller.wrinkle_machine_flag.value && controller.pore_machine_flag.value && controller.corneous_machine_flag
                .value && controller.blemishes_machine_flag.value  && controller.sebum_machine_flag.value ? onPressedButton : null,
          ),
        ),
      ),
    ],
  );
}