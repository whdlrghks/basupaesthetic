import 'package:basup_ver2/design/value.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ResultController extends GetxController {

  var name = "주영".obs;
  var name_check = false.obs;
  var aestheticId = "".obs;
  var aestheticId_check = false.obs;

  var user_id ="".obs;

  var age = "".obs;
  var gender = Gender.None.obs;
  var gendercheck = false.obs;

  var surveylist = [];

  var selectedDateTime = DateTime.parse("1996-01-01").obs;
  var selectedDatecheck = false.obs;

  var selectedyear= "1990".obs;
  var selectedmonth = "1".obs;
  var selecteddate = "1".obs;

  var type = "RNTD1De1".obs;
  var tag = ["수분", "탄력", "수분부족"];
  var tag_flag = [true, true, false];

  var skinResultContent = [
    '부족한 유수분만 채워주면 피부톤도 고르고\n피부 노화 위험도 낮은 건강하고 이상적인 피부지만\n유수분이 부족해 잔주름이 쉽게 생길 수 있고\n건조하고 각질이 생길 수도 있는 피부예요!',
    '지속적인 관리를 통해 주름 예방과 해결을 돕고\n수분 보유력을 채워주는 성분으로\n유수분 밸런스를 맞추는 것을 추천해요'
  ];

  var skinResultWebContent =[];
  var skinResultWebIngre = [];

  var cos_ingredients = [].obs;
  var ingredient = [].obs;
  var detail = [].obs;

  var routinecontent =[].obs;
  var routinekeyword =[].obs;

  var survey_id = "".obs;
  var survey_date = "".obs;

  var sensper = 34;
  var tightper = 52;
  var waterper = 34;
  var oilper = 65;
  var pigper = 66;

  var graphName =['resistance'.tr, 'elasticity'.tr, 'pigmentation'.tr, 'moisture_retention'.tr,
  'oil_retention'.tr ];

  var machineid = "".obs;
  var water_machine = "0".obs;
  var oil_machine = "0".obs;
  var wrinkle_machine= "0".obs;
  var pore_machine= "0".obs;
  var corneous_machine= "0".obs;
  var blemishes_machine= "0".obs;
  var sebum_machine= "0".obs;
  var water_machine_flag = false.obs;
  var oil_machine_flag = false.obs;
  var wrinkle_machine_flag= false.obs;
  var pore_machine_flag= false.obs;
  var corneous_machine_flag= false.obs;
  var blemishes_machine_flag= false.obs;
  var sebum_machine_flag= false.obs;

  var scope_id = "";
  var left_led ="";
  var right_led ="";
  var head_led ="";
  var left_uv ="";
  var right_uv ="";
  var head_uv ="";
  var left_led_flag= false.obs;
  var right_led_flag= false.obs;
  var head_led_flag= false.obs;
  var left_uv_flag= false.obs;
  var right_uv_flag= false.obs;
  var head_uv_flag= false.obs;

  var a = 0.obs;
  var b = 0.obs;
  var c = 0.obs;
  var d = 0.obs;
  var e = 0.obs;
  var f = 0.obs;

  var machine_check = false.obs;
  var microscope_check = false.obs;

  inituser(){

     name.value = "주영";
     name_check.value = false;
     aestheticId.value = "";
     aestheticId_check.value = false;

     user_id.value ="";

     age.value = "";
     gender.value = Gender.None;
     gendercheck.value = false;

     selectedDateTime.value = DateTime.parse("1996-01-01");
     selectedDatecheck.value = false;

     surveylist = [];
  }

  initNewuser(){

    name.value = "주영";
    name_check.value = false;
    user_id.value ="";

    age.value = "";
    gender.value = Gender.None;
    gendercheck.value = false;

    selectedDateTime.value = DateTime.parse("1996-01-01");
    selectedDatecheck.value = false;

    surveylist = [];
  }

  initscope(){
    left_led = "";
    right_led = "";
    head_led = "";
    left_uv = "";
    right_uv = "";
    head_uv = "";
    left_led_flag.value= false;
    right_led_flag.value= false;
    head_led_flag.value= false;
    left_uv_flag.value= false;
    right_uv_flag.value= false;
    head_uv_flag.value= false;

  }

  initmachine(){
    machineid = "".obs;
    water_machine.value = "0";
    oil_machine.value = "0";
    wrinkle_machine.value = "0";
    pore_machine.value = "0";
    corneous_machine.value = "0";
     blemishes_machine.value = "0";
     sebum_machine.value = "0";
     water_machine_flag.value = false;
     oil_machine_flag.value = false;
     wrinkle_machine_flag.value = false;
     pore_machine_flag.value = false;
     corneous_machine_flag.value = false;
     blemishes_machine_flag.value = false;
     sebum_machine_flag.value = false;
  }

  setData(sens, tight, water,oil, pig){
    this.sensper = sens;
    this.tightper = tight;
    this.waterper = water;
    this.oilper = oil;
    this.pigper = pig;

    var temp = [];
    var temp_flag = [];
    if(sensper > 50 ){
      temp.add("skin_barrier".tr);
      temp_flag.add(true);
    }
    else{
      temp.add("sensitive_skin".tr);
      temp_flag.add(false);
    }

    if(waterper > 50 ){
      temp.add("sufficient_moisture".tr);
      temp_flag.add(true);
    }
    else{
      temp.add("lacking_moisture".tr);
      temp_flag.add(false);
    }

    if(tightper > 50 ){
      temp.add("elasticity".tr);
      temp_flag.add(true);
    }
    if(pigper > 50){
      temp.add("pigmentation_vulnerability".tr);
      temp_flag.add(true);
    }
    tag = List.from(temp);
    tag_flag = List.from(temp_flag);

  }

  getFlag(type){
    var comment ="";
    switch (type){
      case DataType.SENS:
        if (sensper < 50) comment ="insufficient".tr;
        else comment ="good".tr;
        return comment;
      case DataType.TIGHT:
        if (tightper < 50) comment ="insufficient".tr;
        else comment ="good".tr;
        return comment;
      case DataType.PIG:
        if (pigper < 50) comment ="severe".tr;
        else comment ="good".tr;
        return comment;
      case DataType.WATER:
        if (waterper < 50) comment ="insufficient".tr;
        else comment ="good".tr;
        return comment;
      case DataType.OIL:
        if (oilper < 50) comment ="insufficient".tr;
        else comment ="good".tr;
        return comment;
      default:
        return "";
    }
  }

  getColorFlag(type){
    var flag = false;
    switch (type){
      case DataType.SENS:
        if (sensper < 50) flag =false;
        else flag = true;
        return flag;
      case DataType.TIGHT:
        if (tightper < 50) flag =false;
        else flag = true;
        return flag;
      case DataType.PIG:
        if (pigper < 50) flag =false;
        else flag = true;
        return flag;
      case DataType.WATER:
        if (waterper < 50) flag =false;
        else flag = true;
        return flag;
      case DataType.OIL:
        if (oilper < 50) flag =false;
        else flag = true;
        return flag;
      default:
        return "";
    }
  }
  // ['resistance'.tr, 'elasticity'.tr, 'pigmentation'.tr, 'moisture_retention'.tr,
  // 'oil_retention'.tr ];
  getDataName(type){
    switch(type){
      case DataType.SENS:
        return 'resistance'.tr;
      case DataType.TIGHT:
        return 'elasticity'.tr;
      case DataType.PIG:
        return 'pigmentation'.tr;
      case DataType.WATER:
        return 'moisture_retention'.tr;
      case DataType.OIL:
        return  'oil_retention'.tr;
      default:
        return "";
    }
  }

  getPer(type, totalWidth){
    switch (type){
      case DataType.SENS:
        return sensper > 10 ? totalWidth*sensper/100
            .toInt() : totalWidth*0.1 ;
      case DataType.TIGHT:
        return tightper > 10 ? totalWidth*tightper/100
            .toInt() : totalWidth* 0.1;
      case DataType.PIG:
        return pigper > 10 ? totalWidth*pigper/100
            .toInt() : totalWidth*0.1;
      case DataType.WATER:
        return waterper > 10 ? totalWidth*waterper/100
            .toInt() : totalWidth*0.1;
      case DataType.OIL:
        return oilper > 10 ? totalWidth*oilper/100
            .toInt() : totalWidth*0.1;
      default:
        return 0;
    }
  }
  getPerValue(type, totalWidth){
    switch (type){
      case DataType.SENS:
        return  totalWidth*sensper/100
            .toInt()  ;
      case DataType.TIGHT:
        return totalWidth*tightper/100
            .toInt();
      case DataType.PIG:
        return totalWidth*pigper/100
            .toInt();
      case DataType.WATER:
        return totalWidth*waterper/100
            .toInt() ;
      case DataType.OIL:
        return totalWidth*oilper/100
            .toInt();
      default:
        return "";
    }
  }

  calAge(){

    DateTime dob = DateTime(int.parse(selectedyear.value),
        int.parse(selectedmonth.value),
        int.parse(selecteddate.value));
    DateTime now = DateTime.now();
    int _age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      _age--;
    }
    age.value = _age.toString();
  }
  Map<String, Map<String, String>> factorDefinitions = {
    'R': {'en': 'R - Resistive', 'ko': 'R - Resistive / 저항'},
    'S': {'en': 'S - Sensitive', 'ko': 'S - Sensitive / 민감'},
    'P': {'en': 'P - Pigment', 'ko': 'P - Pigment /색소'},
    'N': {'en': 'N - NonPigment', 'ko': 'N - NonPigment / 비색소'},
    'W': {'en': 'W - Wrinkled', 'ko': 'W - Wrinkled / 주름'},
    'T': {'en': 'T - Tighted', 'ko': 'T - Tighted / 탄력'},
    'D3': {'en': 'D3 - Very Dry', 'ko': 'D3 - Very Dry / 악건성'},
    'D2': {'en': 'D2 - Dry', 'ko': 'D2 - Dry / 건성'},
    'D1': {'en': 'D1 - Moderately dry', 'ko': 'D1 - Moderately dry / 중건성'},
    'O1': {'en': 'O1 - Slightly oily', 'ko': 'O1 - Slightly oily / 중지성'},
    'O2': {'en': 'O2 - Oily', 'ko': 'O2 - Oily / 지성'},
    'O3': {'en': 'O3 - Very oily', 'ko': 'O3 - Very oily / 악지성'},
    'De3': {'en': 'De3 - Very dehydrated skin, extreme lack of moisture', 'ko':
    'De3 - Very dehydrated / 탈수분성-매우수분부족'},
    'De2': {'en': 'De2 - Dehydrated skin, lacking moisture', 'ko': 'De2 - '
        'Dehydrated / 탈수분성-수분부족'},
    'De1': {'en': 'De1 - Slightly dehydrated skin', 'ko': 'De1 - Slightly '
        'dehydrated / 탈수분성-수분보통'},
    'Hy1': {'en': 'Hy1 - Adequately hydrated', 'ko': 'Hy1 - Adequately '
        'hydrated / 수분성-수분적당'},
    'Hy2': {'en': 'Hy2 - Well hydrated', 'ko': 'Hy2 - Hydrated / '
        '수분성-수분풍족'},
    'Hy3': {'en': 'Hy3 - Very well hydrated', 'ko': 'Hy3 - Very hydrated / '
        '수분성-수분매우풍족'},
  };

  List<String> decodeSkinType(String code) {
    String lang = Get.locale!.languageCode;
    if (code.length != 8) {
      return ["Invalid code"]; // Check for correct code length
    }

    // Split the code into individual factors
    List<String> factors = [
      code.substring(0, 1), // First factor: R/S
      code.substring(1, 2), // Second factor: P/N
      code.substring(2, 3), // Third factor: W/T
      code.substring(3, 5), // Fourth factor: D3/D2/D1/O1/O2/O3
      code.substring(5, 8)  // Fifth factor: De3/De2/De1/Hy1/Hy2/Hy3
    ];

    print(factors);

    List<String> descriptions = factors.map((f) {
      // Get the appropriate factor key for multi-character codes
      String key = f;
      if ('DODH'.contains(f)) { // For D, O, De, Hy types which are followed by numbers
        int index = factors.indexOf(f);
        key = code.substring(index, index + 3); // Include the number in the key
      }
      return factorDefinitions[key]?[lang] ?? "Unknown factor"; // Return localized description
    }).toList();

    return descriptions;
  }
}
