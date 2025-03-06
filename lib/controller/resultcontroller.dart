import 'package:basup_ver2/data/customer.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:get/get.dart';
import 'dart:math';

class ResultController extends GetxController {
  var name = "BASUPTEST".obs;
  var name_check = false.obs;
  var aestheticId = "".obs;
  var aestheticId_check = false.obs;

  var user_id = "".obs;

  var age = "".obs;
  var gender = Gender.None.obs;
  var gendercheck = false.obs;

  var surveylist = [];

  var selectedDateTime = DateTime.parse("1996-01-01").obs;
  var selectedDatecheck = false.obs;

  var selectedyear = "1990".obs;
  var selectedmonth = "1".obs;
  var selecteddate = "1".obs;

  var type = "RNTD1De1".obs;
  var tag = ["수분", "탄력", "수분부족"];
  var tag_flag = [true, true, false];

  Map<SurveyEachItem, List<SkinSurveyResult>> surveyItemList = {};

  var skinResultContent = [
    '부족한 유수분만 채워주면 피부톤도 고르고\n피부 노화 위험도 낮은 건강하고 이상적인 피부지만\n유수분이 부족해 잔주름이 쉽게 생길 수 있고\n건조하고 각질이 생길 수도 있는 피부예요!',
    '지속적인 관리를 통해 주름 예방과 해결을 돕고\n수분 보유력을 채워주는 성분으로\n유수분 밸런스를 맞추는 것을 추천해요'
  ];

  var skinResultWebContent = [];
  var skinResultWebIngre = [];

  var cos_ingredients = [].obs;
  var ingredient = [].obs;
  var detail = [].obs;

  var routinecontent = [].obs;
  var routinekeyword = [].obs;

  var survey_id = "".obs;
  var survey_date = "".obs;

  var sensper = 34;
  var tightper = 52;
  var waterper = 34;
  var oilper = 65;
  var pigper = 66;

  var job_id = "".obs;

  var graphName = [
    'resistance'.tr,
    'elasticity'.tr,
    'pigmentation'.tr,
    'moisture_retention'.tr,
    'oil_retention'.tr
  ];

  var machineid = "".obs;
  var water_machine = "0".obs;
  var oil_machine = "0".obs;
  var wrinkle_machine = "0".obs;
  var pore_machine = "0".obs;
  var corneous_machine = "0".obs;
  var blemishes_machine = "0".obs;
  var sebum_machine = "0".obs;
  var water_machine_flag = false.obs;
  var oil_machine_flag = false.obs;
  var wrinkle_machine_flag = false.obs;
  var pore_machine_flag = false.obs;
  var corneous_machine_flag = false.obs;
  var blemishes_machine_flag = false.obs;
  var sebum_machine_flag = false.obs;

  var scope_id = "";
  var left_led = "";
  var right_led = "";
  var head_led = "";
  var left_uv = "";
  var right_uv = "";
  var head_uv = "";
  var left_led_flag = false.obs;
  var right_led_flag = false.obs;
  var head_led_flag = false.obs;
  var left_uv_flag = false.obs;
  var right_uv_flag = false.obs;
  var head_uv_flag = false.obs;

  var left_led_list = [];
  var right_led_list = [];
  var head_led_list = [];
  var left_uv_list = [];
  var right_uv_list = [];
  var head_uv_list = [];

  var a = 0.obs;
  var b = 0.obs;
  var c = 0.obs;
  var d = 0.obs;
  var e = 0.obs;
  var f = 0.obs;

  var machine_check = false.obs;
  var microscope_check = false.obs;

  var title_loading = false.obs;
  var data_loading = false.obs;
  var opinion_loading = false.obs;
  var match_loading = false.obs;


  /// 유분 절대치(oilper >= 55) & 비율상 HighOil
  final List<String> absoluteHigh_ratioHigh = [
    "유분이 전반적으로 높은 상황이므로, 피지 조절과 함께 수분 보충을 병행합니다.",
    "이중 세안 시 저자극 클렌저를 사용하고, 모공 관리 프로그램을 추가로 진행합니다.",
    "모공 케어용 진정 마스크를 주 1~2회 적용해 과잉 피지를 흡착합니다.",
    "에센스나 크림은 가벼운 질감 제품을 사용해 번들거림을 줄입니다.",
    "유분이 많은 부위와 그렇지 않은 부위를 구분 관리하여, 전체적인 유수분 밸런스를 맞춥니다.",
    "지성 전용 선크림을 사용해 번들거림을 최소화하고 자외선으로 인한 트러블을 예방합니다.",
    "과다한 각질을 제거하기 위해, 주기적으로 피지 조절 패드를 사용하는 것을 권장합니다.",
    "클레이팩이나 워시오프팩으로 T존 부위를 집중적으로 케어합니다.",
    "피부 열감이 올라가면 수분 미스트로 즉각적인 진정을 해줍니다.",
    "유분이 과도하게 많으나 수분이 상대적으로 부족할 수 있으므로, 가벼운 수분 공급도 소홀히 하지 않습니다.",
  ];

  /// 유분 절대치(oilper >= 55) & 비율상 LowOil
  final List<String> absoluteHigh_ratioLow = [
    "전체적인 유분 양은 많지만, 상대적으로 수분이 더 높으므로 수분/피지 둘 다 균형에 유의합니다.",
    "피부 온도 관리에 집중해, 토너팩이나 쿨링 마스크로 열감을 낮춰 피지 분비를 안정화합니다.",
    "모공을 막는 노폐물을 제거한 뒤, 가벼운 보습제로 마무리해 번들거림을 줄입니다.",
    "과도한 레이어링은 피하고, 필요한 단계만 최소화하여 트러블 발생을 줄입니다.",
    "T존과 U존을 나누어 관리하고, 번들거림이 큰 부위는 피지 집중 케어를 진행합니다.",
    "질감이 묽은 에센스나 앰플로 피부결을 정돈한 뒤, 산뜻한 타입 크림을 사용합니다.",
    "지성/복합성 전용 선크림을 선택해 일상 속 자외선 노출을 줄이고, 피지 산화도 방지합니다.",
    "주기적으로 피지 컨트롤 스크럽이나 각질 케어를 실시해 모공 막힘을 예방합니다.",
    "피부가 한쪽으로 치우치지 않도록, 수분 공급과 피지 조절을 균형 있게 진행합니다.",
  ];

  /// 유분 절대치(oilper < 55) & 비율상 HighOil (실제로는 수분이 훨씬 적은 상황)
  final List<String> absoluteLow_ratioHigh = [
    "유분이 실제로 적지만, 수분이 더 부족하여 상대적으로 유분 비율이 높아 보입니다. 수분 공급을 우선합니다.",
    "보습력이 높은 토너와 에센스를 레이어링해 피부를 충분히 촉촉하게 합니다.",
    "저자극 각질 케어를 병행해 보습 흡수를 방해하는 묵은 각질을 제거합니다.",
    "수면팩이나 크림 마스크로 밤사이 집중 보습하여, 유수분 장벽을 개선합니다.",
    "오일 함유량이 너무 높은 제품은 피하고, 수분 공급이 중점인 라인을 사용합니다.",
    "피부 열감이 높아질 경우, 미스트나 쿨링 기기를 활용해 진정시킵니다.",
    "유분이 많아 보인다고 지성 관리만 하면 악영향을 줄 수 있으니, 실제로는 건조함 해소에 집중합니다.",
    "수분크림 위에 소량의 오일을 얹어 유수분 밸런스를 맞추되, 과하지 않게 조절합니다.",
    "눈가, 입가 등 쉽게 건조해지는 부위에 아이크림 등으로 세심한 관리가 필요합니다.",
    "건성 전용 선크림을 사용해 하루 종일 수분 증발을 막고 자외선까지 차단합니다.",
  ];

  /// 유분 절대치(oilper < 55) & 비율상 LowOil (유분도 낮고 수분도 상대적으로 더 높아 보이는 상태)
  final List<String> absoluteLow_ratioLow = [
    "전체적으로 유분이 부족하므로, 영양감 있는 크림이나 오일 밤을 단계적으로 활용합니다.",
    "오일 클렌저나 크리미한 텍스처를 사용해 세안 시 피부 장벽 손상을 최소화합니다.",
    "스킨케어 마지막 단계에 오일을 덧발라 주면, 유분 보충에 도움이 됩니다.",
    "수면팩이나 크림 마스크로 깊은 보습을 채워주고, 당김 현상을 줄입니다.",
    "눈가와 입가 등 국소 부위는 아이크림, 립밤 등으로 보강해주면 좋습니다.",
    "건성 전용 선크림으로 외부 자극을 차단하고, 피부 건조를 예방합니다.",
    "각질 관리도 중요하지만, 너무 잦은 필링은 더 건조해질 수 있으니 주의합니다.",
    "약간의 필수 지방산이 함유된 보습 앰플이나 세럼을 사용하면 유분 레이어를 형성하는 데 도움이 됩니다.",
    "데일리 케어 시, 미스트로 수시로 수분 공급하고 적절한 오일 제품으로 마무리합니다.",
    "슬리핑 팩을 2~3일 간격으로 사용하면 아침에도 당김 없이 촉촉한 피부를 유지합니다.",
  ];

  initloading() {
    title_loading.value = false;
    data_loading.value = false;
    opinion_loading.value = false;
    match_loading.value = false;
  }

  startloading() {
    title_loading.value = true;
    data_loading.value = true;
    opinion_loading.value = true;
    match_loading.value = true;
  }

  inituser() {
    name.value = "주영";
    name_check.value = false;
    aestheticId.value = "";
    aestheticId_check.value = false;

    user_id.value = "";

    age.value = "";
    gender.value = Gender.None;
    gendercheck.value = false;

    selectedDateTime.value = DateTime.parse("1996-01-01");
    selectedDatecheck.value = false;

    surveylist = [];
    surveyItemList = {};
  }

  initNewuser() {
    name.value = "주영";
    name_check.value = false;
    user_id.value = "";

    age.value = "";
    gender.value = Gender.None;
    gendercheck.value = false;

    selectedDateTime.value = DateTime.parse("1996-01-01");
    selectedDatecheck.value = false;

    surveylist = [];
    surveyItemList = {};
  }

  initscope() {
    left_led = "";
    right_led = "";
    head_led = "";
    left_uv = "";
    right_uv = "";
    head_uv = "";
    left_led_flag.value = false;
    right_led_flag.value = false;
    head_led_flag.value = false;
    left_uv_flag.value = false;
    right_uv_flag.value = false;
    head_uv_flag.value = false;

    left_led_list = [];
    right_led_list = [];
    head_led_list = [];
    left_uv_list = [];
    right_uv_list = [];
    head_uv_list = [];
  }

  initmachine() {
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

  void addSurveyResult(SurveyEachItem key, SkinSurveyResult newResult) {
    if (surveyItemList.containsKey(key)) {
      surveyItemList[key]!.add(newResult);
    } else {
      surveyItemList[key] = [newResult];
    }
  }

  // ResultController 클래스 내에 추가할 함수
  void applySurveyResultForKey(SurveyEachItem key) {
    // 해당 key에 해당하는 SkinSurveyResult 리스트가 존재하고, 값이 있을 경우
    if (surveyItemList.containsKey(key) && surveyItemList[key]!.isNotEmpty) {
      // 최신 SkinSurveyResult를 선택 (리스트의 마지막 요소)
      SkinSurveyResult result = surveyItemList[key]!.last;

      // Rx 변수의 경우 .value로 업데이트
      cos_ingredients.value = result.cosIngredients;
      ingredient.value = result.ingredient;
      detail.value = result.detail;
      routinecontent.value = result.routineContent;
      routinekeyword.value = result.routineKeyword;
      type.value = result.type;

      print("resultController.title_loading.value = false;");
      title_loading.value = false;

      // Rx가 아닌 일반 변수들은 직접 할당
      skinResultWebContent = result.skinResultWebContent;
      skinResultWebIngre = result.skinResultWebIngre;

      print("resultController.opinion_loading.value = false;");
      opinion_loading.value = false;
      print("resultController.match_loading.value = false;");
      match_loading.value = false;

      // 정수형 변수들도 직접 할당
      sensper = result.sensper;
      tightper = result.tightper;
      waterper = result.waterper;
      oilper = result.oilper;
      pigper = result.pigper;

      print("resultController.data_loading.value = false;");
      data_loading.value = false;

      // 리스트 변수들도 직접 할당
      tag = List.from(result.tag);
      tag_flag = List.from(result.tagFlag);
    }
  }

  setData(sens, tight, water, oil, pig) {
    this.sensper = sens;
    this.tightper = tight;
    this.waterper = water;
    this.oilper = oil;
    this.pigper = pig;

    var temp = [];
    var temp_flag = [];
    if (sensper > 50) {
      temp.add("skin_barrier".tr);
      temp_flag.add(true);
    } else {
      temp.add("sensitive_skin".tr);
      temp_flag.add(false);
    }

    if (waterper > 50) {
      temp.add("sufficient_moisture".tr);
      temp_flag.add(true);
    } else {
      temp.add("lacking_moisture".tr);
      temp_flag.add(false);
    }

    if (tightper > 50) {
      temp.add("elasticity".tr);
      temp_flag.add(true);
    }
    if (pigper > 50) {
      temp.add("pigmentation_vulnerability".tr);
      temp_flag.add(true);
    }
    tag = List.from(temp);
    tag_flag = List.from(temp_flag);
  }

  getFlag(type) {
    var comment = "";
    switch (type) {
      case DataType.SENS:
        if (sensper < 50)
          comment = "insufficient".tr;
        else
          comment = "good".tr;
        return comment;
      case DataType.TIGHT:
        if (tightper < 50)
          comment = "insufficient".tr;
        else
          comment = "good".tr;
        return comment;
      case DataType.PIG:
        if (pigper < 50)
          comment = "severe".tr;
        else
          comment = "good".tr;
        return comment;
      case DataType.WATER:
        if (waterper < 50)
          comment = "insufficient".tr;
        else
          comment = "good".tr;
        return comment;
      case DataType.OIL:
        if (oilper < 50)
          comment = "insufficient".tr;
        else
          comment = "good".tr;
        return comment;
      default:
        return "";
    }
  }

  getColorFlag(type) {
    var flag = false;
    switch (type) {
      case DataType.SENS:
        if (sensper < 50)
          flag = false;
        else
          flag = true;
        return flag;
      case DataType.TIGHT:
        if (tightper < 50)
          flag = false;
        else
          flag = true;
        return flag;
      case DataType.PIG:
        if (pigper < 50)
          flag = false;
        else
          flag = true;
        return flag;
      case DataType.WATER:
        if (waterper < 50)
          flag = false;
        else
          flag = true;
        return flag;
      case DataType.OIL:
        if (oilper < 50)
          flag = false;
        else
          flag = true;
        return flag;
      default:
        return "";
    }
  }

  // ['resistance'.tr, 'elasticity'.tr, 'pigmentation'.tr, 'moisture_retention'.tr,
  // 'oil_retention'.tr ];
  getDataName(type) {
    switch (type) {
      case DataType.SENS:
        return 'resistance'.tr;
      case DataType.TIGHT:
        return 'elasticity'.tr;
      case DataType.PIG:
        return 'pigmentation'.tr;
      case DataType.WATER:
        return 'moisture_retention'.tr;
      case DataType.OIL:
        return 'oil_retention'.tr;
      default:
        return "";
    }
  }

  getPer(type, totalWidth) {
    switch (type) {
      case DataType.SENS:
        return sensper > 10
            ? totalWidth * sensper / 100.toInt()
            : totalWidth * 0.1;
      case DataType.TIGHT:
        return tightper > 10
            ? totalWidth * tightper / 100.toInt()
            : totalWidth * 0.1;
      case DataType.PIG:
        return pigper > 10
            ? totalWidth * pigper / 100.toInt()
            : totalWidth * 0.1;
      case DataType.WATER:
        return waterper > 10
            ? totalWidth * waterper / 100.toInt()
            : totalWidth * 0.1;
      case DataType.OIL:
        return oilper > 10
            ? totalWidth * oilper / 100.toInt()
            : totalWidth * 0.1;
      default:
        return 0;
    }
  }

  getPerValue(type, totalWidth) {
    switch (type) {
      case DataType.SENS:
        return totalWidth * sensper / 100.toInt();
      case DataType.TIGHT:
        return totalWidth * tightper / 100.toInt();
      case DataType.PIG:
        return totalWidth * pigper / 100.toInt();
      case DataType.WATER:
        return totalWidth * waterper / 100.toInt();
      case DataType.OIL:
        return totalWidth * oilper / 100.toInt();
      default:
        return "";
    }
  }

  calAge() {
    DateTime dob = DateTime(int.parse(selectedyear.value),
        int.parse(selectedmonth.value), int.parse(selecteddate.value));
    DateTime now = DateTime.now();
    int _age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
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
    'De3': {
      'en': 'De3 - Very dehydrated skin, extreme lack of moisture',
      'ko': 'De3 - Very dehydrated / 탈수분성-매우수분부족'
    },
    'De2': {
      'en': 'De2 - Dehydrated skin, lacking moisture',
      'ko': 'De2 - '
          'Dehydrated / 탈수분성-수분부족'
    },
    'De1': {
      'en': 'De1 - Slightly dehydrated skin',
      'ko': 'De1 - Slightly '
          'dehydrated / 탈수분성-수분보통'
    },
    'Hy1': {
      'en': 'Hy1 - Adequately hydrated',
      'ko': 'Hy1 - Adequately '
          'hydrated / 수분성-수분적당'
    },
    'Hy2': {
      'en': 'Hy2 - Well hydrated',
      'ko': 'Hy2 - Hydrated / '
          '수분성-수분풍족'
    },
    'Hy3': {
      'en': 'Hy3 - Very well hydrated',
      'ko': 'Hy3 - Very hydrated / '
          '수분성-수분매우풍족'
    },
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
      code.substring(5, 8) // Fifth factor: De3/De2/De1/Hy1/Hy2/Hy3
    ];

    print(factors);

    List<String> descriptions = factors.map((f) {
      // Get the appropriate factor key for multi-character codes
      String key = f;
      if ('DODH'.contains(f)) {
        // For D, O, De, Hy types which are followed by numbers
        int index = factors.indexOf(f);
        key = code.substring(index, index + 3); // Include the number in the key
      }
      return factorDefinitions[key]?[lang] ??
          "Unknown factor"; // Return localized description
    }).toList();

    return descriptions;
  }

  void addingCommentBalance() {
    if (oilper == 0 && waterper == 0) {
      return;
    }
    var normaloil = oilper / (oilper + waterper) * 10;
    var normalwater = waterper / (oilper + waterper) * 10;
    var result = "";
// 목표 비율: 4 : 6, 즉 oilper 4.0, waterper 6.0 (오차 0.4 허용)
    if (int.parse(age.value) < 35) {
      double desiredOil = 4.0;
      if (normaloil > desiredOil + 0.4) {
        result = generateSkinResult(ratioResult: 1, normaloil : normaloil,
            normalwater: normalwater); //
        // oilper가
        // 너무 높음
      } else if (normaloil < desiredOil - 0.4) {
        result = generateSkinResult(ratioResult: 2, normaloil : normaloil,
            normalwater: normalwater); // oilper가 너무 높음
      } else {
        result = generateSkinResult(ratioResult: 3, normaloil : 4.0,
            normalwater: 6.0); // oilper가 너무 높음
      }
    } else {
// age >= 35인 경우 목표 비율: 4.5 : 5.5, 즉 oilper 4.5 (오차 0.4 허용)
      double desiredOil = 4.5;
      if (oilper > desiredOil + 0.4) {
        result = generateSkinResult(ratioResult: 4, normaloil : normaloil,
            normalwater: normalwater); // oilper가 너무 높음
      } else if (oilper < desiredOil - 0.4) {
        result = generateSkinResult(ratioResult: 5, normaloil : normaloil,
            normalwater: normalwater); // oilper가 낮음
      } else {
        result = generateSkinResult(ratioResult: 6, normaloil : 4.5,
            normalwater: 5.5); // 권장
      }
    }
    if (result != "") {
      skinResultWebContent.insert(2, result);
    }
  }

  /// 2번째 메소드: oilper가 55 미만일 경우,
  /// 첫번째 메소드 결과(ratioResult)에 따라 결과 문자열을 생성한다.
  String generateSkinResult({
    required int ratioResult,
    required double normaloil,
    required double normalwater
  }) {

    // 소수점 첫 번째 자리까지만 보이도록 처리
    String oilStr = normaloil.toStringAsFixed(1);
    String waterStr = normalwater.toStringAsFixed(1);

    final random = Random();
    if (oilper >= 55) {
      String randomHighOilCare = absoluteHigh_ratioHigh[random.nextInt(absoluteHigh_ratioHigh.length)];
      String randomLowOilCare = absoluteHigh_ratioLow[random.nextInt(absoluteHigh_ratioLow.length)];

      switch (ratioResult) {
        case 6: //권장
          return "권장하는 유수분 비율운 수분 5.5 : 유분 4.5 입니다. 현재 유수분 밸런스가 좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} ) ";
        case 5: // 유분 적음
          return "권장하는 유수분 비율운 수분 5.5 : 유분 4.5 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} ) 유수분 밸런스 조절에 신경쓰세요. 유분보유력 "
              "증가를 위해 보습관련 코스를 추천합니다.\n${randomHighOilCare} ";
        case 4: // 유분 많음
          return  "권장하는 유수분 비율운 수분 5.5 : 유분 4.5 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )  유수분 밸런스 조절에 신경쓰세요. 유분보유력을 "
              "낮추면서 수분을 높이는 방법을 추천드립니다.\n${randomLowOilCare}";
        case 3:
          return "권장하는 유수분 비율운 수분 6 : 유분 4 입니다. 현재 유수분 밸런스가 좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )";
        case 2:
          return "권장하는 유수분 비율운 수분 6 : 유분 4 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} ) 유수분 밸런스 조절에 신경쓰세요. 유분보유력 "
              "증가를 위해 보습관련 코스를 추천합니다.\n${randomHighOilCare}";
        case 1:
          return "권장하는 유수분 비율운 수분 6 : 유분 4 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )\n${randomLowOilCare}";
        default:
          return "";
      }
    } else {
      String randomHighOilCare = absoluteLow_ratioHigh[random.nextInt(absoluteLow_ratioHigh.length)];
      String randomLowOilCare = absoluteLow_ratioLow[random.nextInt(absoluteLow_ratioLow.length)];
      switch (ratioResult) {
        case 6:
          return "권장하는 유수분 비율운 수분 5.5 : 유분 4.5 입니다. 현재 유수분 밸런스가 좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )\n그렇지만 "
              "절대적인 "
              "유분 "
              "값이 "
              "낮기 "
              "때문에 "
              "유수분을 "
              "골고루 "
              "성장시킬 수 있는 관리나 제품을 사용해주세요.";
        case 5:
          return "권장하는 유수분 비율운 수분 5.5 : 유분 4.5 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )\n수분 대비 유분보유력이 약합니다.${randomHighOilCare}";
        case 4:
          return  "권장하는 유수분 비율운 수분 5.5 : 유분 4.5 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )\n그것의 가장 큰 이유는 피부의 수분보유력이 약해서 그렇습니다. "
              "이 경우 유분감이 많다고 느껴질 수 있으나 이는 상대적으로 느끼는 것입니다. 유수분을 골고루 강화시켜줘야 하지만 수분위주의 관리가 필요합니다. "
              "${randomLowOilCare}";
        case 3:
          return "권장하는 유수분 비율운 수분 6 : 유분 4 입니다. 현재 유수분 밸런스가 좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )\n그렇지만 절대적인 유분 값이 낮기 때문에 유수분을 골고루 "
              "성장시킬 수 있는 관리나 제품을 사용해주세요.";
        case 2:
          return "권장하는 유수분 비율운 수분 6 : 유분 4 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )\n수분 대비 유분보유력이 약합니다. ${randomHighOilCare}";
        case 1:
          return "권장하는 유수분 비율운 수분 6 : 유분 4 입니다. 현재 유수분 밸런스가 안좋습니다. ( 수분 "
              "${waterStr} : 유분 ${oilStr} )\n그것의 가장 큰 이유는 피부의 수분보유력이 약해서 그렇습니다. "
              "이 경우 유분감이 많다고 느껴질 수 있으나 이는 상대적으로 느끼는 것입니다. 유수분을 골고루 강화시켜줘야 하지만 수분위주의 관리가 필요합니다. "
              "${randomLowOilCare}";
        default:
          return "";
      }
    }
  }

  void commentPigmentAdding(){
    var result = "";
    if (pigper >= 55) {
      result= "색소침착에 대한 점수가 높습니다. 육안으로 기미나 색소침착 관련 현상이 보인다면 자외선 차단제를 추천합니다. "
          "만약 사용하고 계신다면 자외선 차단제를 변경하시는 것도 방법입니다. 또한 미백관련 코스를 추천합니다.";
    } else {
      result= "색소침착에 대한 점수가 낮으므로 자외선 차단제를 필수적으로 추천드립니다.";
    }
    skinResultWebContent.add(result);
  }
}
