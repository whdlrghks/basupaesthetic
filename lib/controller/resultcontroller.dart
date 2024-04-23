import 'package:basup_ver2/design/value.dart';
import 'package:get/get.dart';

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

  var graphName =["저항성", "탄력성", "색소침착", "수분보유력", "유분보유력" ];

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
      temp.add("피부장벽");
      temp_flag.add(true);
    }
    else{
      temp.add("민감성피부");
      temp_flag.add(false);
    }

    if(waterper > 50 ){
      temp.add("수분 충분");
      temp_flag.add(true);
    }
    else{
      temp.add("수분 부족");
      temp_flag.add(false);
    }

    if(tightper > 50 ){
      temp.add("탄력");
      temp_flag.add(true);
    }
    if(pigper > 50){
      temp.add("색소 취약");
      temp_flag.add(true);
    }
    tag = List.from(temp);
    tag_flag = List.from(temp_flag);

  }

  getFlag(type){
    var comment ="";
    switch (type){
      case DataType.SENS:
        if (sensper < 50) comment ="부족";
        else comment ="좋음";
        return comment;
      case DataType.TIGHT:
        if (tightper < 50) comment ="부족";
        else comment ="좋음";
        return comment;
      case DataType.PIG:
        if (pigper < 50) comment ="심함";
        else comment ="좋음";
        return comment;
      case DataType.WATER:
        if (waterper < 50) comment ="부족";
        else comment ="좋음";
        return comment;
      case DataType.OIL:
        if (oilper < 50) comment ="부족";
        else comment ="좋음";
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

  getDataName(type){
    switch(type){
      case DataType.SENS:
        return graphName[0];
      case DataType.TIGHT:
        return graphName[1];
      case DataType.PIG:
        return graphName[2];
      case DataType.WATER:
        return graphName[3];
      case DataType.OIL:
        return graphName[4];
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
        return "";
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

}
