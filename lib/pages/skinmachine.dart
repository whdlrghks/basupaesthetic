import 'package:basup_ver2/component/blankgap.dart';
import 'package:basup_ver2/component/button.dart';
import 'package:basup_ver2/component/container.dart';
import 'package:basup_ver2/component/surveytitle.dart';
import 'package:basup_ver2/controller/httpscontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/sizecontroller.dart';
import 'package:basup_ver2/pages/dialog.dart';
import 'package:basup_ver2/pages/surveyshortform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SkinMachine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SkinMachineState();
  }
}

class _SkinMachineState extends State<SkinMachine> {
  var controller = Get.find<SizeController>(tag: "size");
  var resultcontroller = Get.find<ResultController>(tag: "result");


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    resultcontroller.initmachine();

    // fetchSurveyResultNo();
  }

  inputformMachine(int factornum){
    var factorname = "";
    var factor;
    var factor_flag;

    TextEditingController _textcontroller = TextEditingController();

    switch (factornum) {
      case 1:
        factorname = "moisture".tr;
        factor = resultcontroller.water_machine;
        factor_flag = resultcontroller.water_machine_flag;
        break;
      case 2:
        factorname = "oil".tr;
        factor = resultcontroller.oil_machine;
        factor_flag = resultcontroller.oil_machine_flag;
        break;
      case 3:
        factorname = "wrinkle".tr;
        factor = resultcontroller.wrinkle_machine;
        factor_flag = resultcontroller.wrinkle_machine_flag;
        break;
      case 4:
        factorname = "pore".tr;
        factor = resultcontroller.pore_machine;
        factor_flag = resultcontroller.pore_machine_flag;
        break;
      case 5:
        factorname = "corneous".tr;
        factor = resultcontroller.corneous_machine;
        factor_flag = resultcontroller.corneous_machine_flag;
        break;
      case 6:
        factorname = "blemishes".tr;
        factor = resultcontroller.blemishes_machine;
        factor_flag = resultcontroller.blemishes_machine_flag;
        break;
      case 7:
        factorname = "sebum".tr;
        factor = resultcontroller.sebum_machine;
        factor_flag = resultcontroller.sebum_machine_flag;
        break;
      default:
        return;
    }

    return machineFactorField(factorname, factor, factor_flag, _textcontroller);
  }

  @override
  Widget build(BuildContext context) {
    controller.width(MediaQuery.of(context).size.width.toInt());
    controller.height(MediaQuery.of(context).size.height.toInt());
    TextEditingController _textcontroller = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          BlankTopProGressMulti(controller),
          BlankTopGap(controller),
          Subtitle('skin_measure_machine'.tr, controller),
          QuestionTitle('enter_skin_values'.tr, controller),
          machineUserIdField(_textcontroller, resultcontroller ),
          inputformMachine(1),
          inputformMachine(2),
          inputformMachine(3),
          inputformMachine(4),
          inputformMachine(5),
          inputformMachine(6),
          inputformMachine(7),
          MachineSubmitButton("submit".tr, resultcontroller, onPressedButton)
        ],
      )),
    );
  }

  onPressedButton() async {
    //db에 등록
    await createSkinMeasurements(resultcontroller);
    Get.dialog(showScopedialog(resultcontroller.user_id.value));
    // return Get.toNamed("/scope?userid=");
  }
}
