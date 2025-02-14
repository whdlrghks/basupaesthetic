import 'package:basup_ver2/design/value.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget BlankTopGap(controller){
  return Obx(
        () => Container(
      height: figma_hight > controller.present_height.value
          ? 0
          : 86,
    ),
  );
}

Widget BlankTopProGressMulti(controller){
  return Obx(
        () => Container(
      height: figma_hight > controller.present_height.value
          ? 43 / figma_hight * controller.present_height.value
          : 43,
    ),
  );
}


Widget BlankDescAnser(controller){
  return
    Obx(
          () => Container(
        height: figma_hight > controller.present_height.value
            ? 65 / figma_hight * controller.present_height.value
            : 65,
      ),
    );
}

Widget BlankAnswerSubmit(controller){
  return
    Obx(
          () => Container(
        height: figma_hight > controller.present_height.value
            ? 70 / figma_hight * controller.present_height.value
            : 70,
      ),
    );
}


Widget BlankBackSubmit(controller){
  return
    Obx(
          () => Container(
        height: figma_hight > controller.present_height.value
            ? 70 / figma_hight * controller.present_height.value
            : 70,
      ),
    );
}

Widget BlankBetweenTitleContent(controller){
  return Obx(
        () => Container(
      height: figma_hight > controller.present_height.value
          ? 60 / figma_hight * controller.present_height.value
          : 60,
    ),
  );
}