import 'package:basup_ver2/design/value.dart';
import 'package:get/get.dart';

class SizeController extends GetxController{

  var present_width = 0.0.obs;
  var present_height = 0.0.obs;

  width(width){
    present_width.value = width;
  }

  height(height){
    present_height.value= height;
  }


}