import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

tagContainer(tag, flag) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      height: 26,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: flag ? Color(0xFFE7F4EA) : Color(0xFFFBDFDF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(46),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "# " + tag,
            style: TextStyle(
              color: flag ? Color(0xFF49A85E) : Color(0xFFEF6363),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

nameField(resultcontroller, textcontroller) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child:
              // Column(children: [
              //   Expanded(
              //     child: SizedBox(
              //       child:
              TextField(
            keyboardType: TextInputType.name,
            minLines: 1,
            //Normal textInputField will be displayed
            maxLines: 1,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              isDense: true,
              alignLabelWithHint: true,
              enabledBorder: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusColor: Colors.black38,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                  fontFamily: "Pretendard",
                height: 1,
              ),
              floatingLabelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                height: 1,
              ),
              labelText: "name".tr,
            ),
            controller: textcontroller,
            onChanged: (text) {
              resultcontroller.name.value = text;
              if (text != "") {
                resultcontroller.name_check.value = true;
              } else {
                resultcontroller.name_check.value = false;
              }
            },style: TextStyle(

                fontFamily: "Pretendard",
              ),
            //       ),
            //     ),
            //   ),
            // ]),
          ),
        ),
      ],
    ),
  );
}

centerField(resultcontroller, textcontroller) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child:
          // Column(children: [
          //   Expanded(
          //     child: SizedBox(
          //       child:
          TextField(
            keyboardType: TextInputType.name,
            minLines: 1,
            //Normal textInputField will be displayed
            maxLines: 1,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              isDense: true,
              alignLabelWithHint: true,
              enabledBorder: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusColor: Colors.black38,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                fontFamily: "Pretendard",
                height: 1,
              ),
              floatingLabelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                height: 1,
              ),
              labelText: resultcontroller.aestheticId.value == ""? "센터ID" : resultcontroller.aestheticId.value,
            ),
            controller: textcontroller,
            onChanged: (text) {
              resultcontroller.aestheticId.value = text;
              if (text != "") {
                resultcontroller.aestheticId_check.value = true;
              } else {
                resultcontroller.aestheticId_check.value = false;
              }
            },style: TextStyle(

            fontFamily: "Pretendard",
          ),
            //       ),
            //     ),
            //   ),
            // ]),
          ),
        ),
      ],
    ),
  );
}

ageField(resultcontroller, textcontroller) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          height: 50,
          child: Column(children: [
            Expanded(
              child: SizedBox(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  //Normal textInputField will be displayed
                  maxLines: 10,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 19, 20, 19),
                    isDense: true,
                    alignLabelWithHint: true,
                    enabledBorder: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: Colors.black38, width: 1.0),
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    focusColor: Colors.black38,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(
                      color: Color(0xff979797),
                      fontSize: 14,
                      height: 1,
                    ),
                    labelText: "나이",
                  ),
                  controller: textcontroller,
                  onChanged: (text) {
                    resultcontroller.name.value = text;
                    if (text != "") {
                      resultcontroller.name_check.value = true;
                    } else {
                      resultcontroller.name_check.value = false;
                    }
                  },
                ),
              ),
            ),
          ]),
        ),
      ],
    ),
  );
}

Widget sexCheck(resultcontroller) {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Obx(() => resultcontroller.gender.value != Gender.M
          ? Container(
              width: 125,
              height: 45,
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
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(11),
                            bottomLeft: Radius.circular(11)),
                      );
                    },
                  ),
                ),
                child: Text("sex_m".tr),
                onPressed: () async {
                  resultcontroller.gender.value = Gender.M;
                  resultcontroller.gendercheck.value = true;
                },
              ),
            )
          : Container(
              width: 125,
              height: 45,
              child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return button_disabled;
                    } else {
                      return Colors.white;
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
                      return Colors.white;
                    } else {
                      return Colors.green;
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
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(11),
                            bottomLeft: Radius.circular(11)),
                      );
                    },
                  ),
                ),
                child: Text("sex_m".tr),
                onPressed: () async {
                  resultcontroller.gender.value = Gender.M;
                  resultcontroller.gendercheck.value = true;
                },
              ),
            )),
      Obx(
        () => resultcontroller.gender.value != Gender.W
            ? Container(
                width: 125,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.resolveWith((states) {
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
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
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
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(11),
                              bottomRight: Radius.circular(11)),
                        );
                      },
                    ),
                  ),
                  child: Text("sex_w".tr),
                  onPressed: () async {
                    resultcontroller.gender.value = Gender.W;
                    resultcontroller.gendercheck.value = true;
                  },
                ),
              )
            : Container(
                width: 125,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return button_disabled;
                      } else {
                        return Colors.white;
                      }
                    }),
                    side: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return BorderSide(width: 1, color: button_disabled);
                      } else {
                        return BorderSide(width: 1, color: button_disabled);
                      }
                    }),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.white;
                      } else {
                        return Colors.green;
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
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(11),
                              bottomRight: Radius.circular(11)),
                        );
                      },
                    ),
                  ),
                  child: Text("sex_w".tr),
                  onPressed: () async {
                    resultcontroller.gender.value = Gender.W;
                    resultcontroller.gendercheck.value = true;
                  },
                ),
              ),
      ),
    ]),
  );
}

machineFactorField(factorname, factor, factor_flag, textcontroller, ) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child : Text(
            factorname
          )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: 200,
          child:
          // Column(children: [
          //   Expanded(
          //     child: SizedBox(
          //       child:
          TextField(      keyboardType: TextInputType.number, // Show numeric keyboard
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow digits only
            ],
            minLines: 1,
            //Normal textInputField will be displayed
            maxLines: 1,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              isDense: true,
              alignLabelWithHint: true,
              enabledBorder: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusColor: Colors.black38,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                fontFamily: "Pretendard",
                height: 1,
              ),
              floatingLabelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                height: 1,
              ),
              labelText: factorname,
            ),
            controller: textcontroller,
            maxLength: 2,

            onChanged: (text) {
              factor.value = text;
              if (text != "") {
                factor_flag.value = true;
              } else {
                factor_flag.value = false;
              };
              print(factor.value + " , " + factor_flag.value.toString());
            },style: TextStyle(

            fontFamily: "Pretendard",
          ),
            //       ),
            //     ),
            //   ),
            // ]),
          ),
        ),
      ],
    ),
  );
}

machineUserIdField(textcontroller, resultcontroller ) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            child : Text(
                "USER ID"
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: 200,
          child:
          // Column(children: [
          //   Expanded(
          //     child: SizedBox(
          //       child:
          TextField(      keyboardType: TextInputType.name,// Allow digits only
            readOnly: true,
            minLines: 1,
            //Normal textInputField will be displayed
            maxLines: 1,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              isDense: true,
              alignLabelWithHint: true,
              enabledBorder: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.0),
              ),
              focusColor: Colors.black38,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                fontFamily: "Pretendard",
                height: 1,
              ),
              floatingLabelStyle: TextStyle(
                color: Color(0xff979797),
                fontSize: 12,
                height: 1,
              ),
              labelText: resultcontroller.user_id.value == "" ? "User Id" : resultcontroller.user_id.value,
            ),
            controller: textcontroller,
            onChanged: (text) {
              resultcontroller.user_id.value = text;
            },style: TextStyle(

              fontFamily: "Pretendard",
            ),
            //       ),
            //     ),
            //   ),
            // ]),
          ),
        ),
      ],
    ),
  );
}
