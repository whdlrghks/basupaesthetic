import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'contact_basup': 'Please contact BASUP to pre-register and login',
      'user_id': 'User ID',
      'password': 'Password',
      'login': 'Login',
      'login_fail': 'Login Failed',
      'login_fail_comment': 'The ID and password are different\nPlease enter '
          'them again.',
      'skin_microscope': 'Skin Microscope Photography',
      'confirm_microscope': 'Press confirm to proceed to microscope photography.',
      'proceed_later': 'Proceed Later',
      'proceed_microscope': 'Proceed with Microscope',
      'skin_data_complete': 'Skin Data Complete',
      'view_results': 'Press to view results.',
      'check_later': 'Check Later',
      'view_result': 'View Result',
      'no_skin_data': 'No Skin Data',
      'no_skin_data_comment': 'There is no skin data. Please proceed with the skin questionnaire.',
      'proceed_questionnaire': 'Proceed with Questionnaire',
      'login_failed': 'Login Failed',
      'login_failed_comment': 'Please check your credentials and try again.',
      'microscope_input': 'Microscope Input',
      'connect_via_qr': 'Please connect using the QR code below with your smartphone camera.',
      'proceed_homepage': 'Proceed on Homepage',
      'customers_list': 'Customer List',
      'error_occurred': 'An error occurred. Please go back.',
      'no_customers': 'No customers found. Click here to register the first customer.',
      'age_recent_test': 'Age: @age, Recent Test: @recent_test',
      'register_customer': 'Register Customer',
      'age': 'Age',
      'recent_test': 'Recent Test Date',
      'click_register': 'Click to Register First Customer',
      'welcome_user': '@name, welcome.',
      'welcome_guest': 'Click BASUP skin questionnaire to register a new customer.',
      'skin_questionnaire': 'BASUP Skin Questionnaire',
      'skin_measurement_input': 'BASUP Skin Measurement Input',
      'skin_microscope_input': 'BASUP Skin Microscope Input',
      'skin_results_check': 'Check BASUP Skin Results',
      'logout': 'Logout',
      'error_no_user': 'No user ID provided.',
      'skin_measure_machine': 'Skin Machine',
      'enter_skin_values': 'Please enter the values measured by the BASUP '
          'skin measurement machine\nafter cleansing your skin.',
      'submit': 'Submit',
      'moisture': 'Moisture',
      'oil': 'Oil',
      'wrinkle': 'Wrinkle',
      'pore': 'Pore',
      'corneous': 'Corneous',
      'blemishes': 'Blemishes',
      'sebum': 'Sebum',
      'skin_microscope': 'Microscope',
      'open_camera': 'Please open this window on your smartphone.\nConnect to the BASUP skin microscope\nand enter the values measured.',
      'capture_left_led': 'Capture Left LED',
      'recapture_left_led': 'Recapture Left LED',
      'capture_right_led': 'Capture Right LED',
      'recapture_right_led': 'Recapture Right LED',
      'capture_head_led': 'Capture Head LED',
      'recapture_head_led': 'Recapture Head LED',
      'capture_left_uv': 'Capture Left UV',
      'recapture_left_uv': 'Recapture Left UV',
      'capture_right_uv': 'Capture Right UV',
      'recapture_right_uv': 'Recapture Right UV',
      'capture_head_uv': 'Capture Head UV',
      'recapture_head_uv': 'Recapture Head UV',
      'submit': 'Submit',
      'uploading_data': 'Uploading Data...',
      'error_uploading_files': 'An error occurred during file uploads: {error}',
      'analyzing_skin': 'Analyzing BASUP SKIN AI...',
      'analyzing_skin_detail': 'Based on four different skin data,\nbasup are '
          'analyzing your skin in various aspects.',

      "skin_diagnosis_title": "Self Diagnosis",
      "detailed_prescription_collect_info": "Information is collected for a "
          "detailed prescription\nand is not used for any other purposes.",
      "enter_cosmetic_info": "Please enter cosmetic information\nExample: Dr. G - Red Blemish Soothing Toner",
      "enter_skin_concerns": "Please write down your skin concerns\nExample: Even if I apply cosmetics in the morning, my skin feels tight by lunchtime",
      "next": "Next",
      'skin_analysis_results': '\'s Skin Analysis Results',
      '288_result' : "Out of 288 skin types\n",
      'anlayzed_result' : '\'s skin has been analyzed',
      'no_results': 'No results available.',
      'skin_type_description': 'Description of Skin Type:',
      'expert_opinion': 'Expert Opinion:',
      'personalized_care_instructions': 'Personalized Care Instructions',
      'matched_ingredients': 'Matched Ingredients',
      'prescription_ingredients_title': 'Prescription Ingredients for Your Skin Type!',
      'ingredients_benefit': 'These ingredients work well for you.',
      'your_skin_type_is': '\'s skin type',
      'skin_type':"Skin Type",
      'resistance': 'Resistance',
      'elasticity': 'Elasticity',
      'pigmentation': 'Pigmentation',
      'moisture_retention': 'Moisture Retention',
      'oil_retention': 'Oil Retention',
      'insufficient': 'Bad',
      'good': 'Good',
      'severe': 'Severe',
      'skin_barrier': 'Skin Barrier',
      'sensitive_skin': 'Sensitive Skin',
      'sufficient_moisture': 'Sufficient Moisture',
      'lacking_moisture': 'Lacking Moisture',
      'elasticity': 'Elasticity',
      'pigmentation_vulnerability': 'Pigmentation Vulnerability',
      'result_time' : 'skin report',
      'user_general_info' : "Information",
      'info_input' : "Please enter simple basic information\nfor skin "
          "diagnosis.",
      'start_diagnostice' : "Start Diagnostice",
      'year' : 'year',
      'month' : 'month',
      'day' : 'day',
      'name' : 'name',
      'sex_m' : 'Man',
      'sex_w' : 'Woman',
      "skin_diagnosis": "Skin Condition Diagnosis",
      "hydration_diagnosis": "Hydration Diagnosis",
      "sebum_diagnosis": "Sebum Diagnosis",
      "wrinkle_elasticity_diagnosis": "Wrinkle / Elasticity Diagnosis",
      "pigmentation_check": "Pigmentation Check",
      "sensitivity_check": "Sensitivity Check",
      "previous_question":"Previous Question",

      "submit":"Submit",
      "sending_skin_data": "Sending skin diagnosis data to the BASUP server.",
      "data_use_disclaimer": "This data will be used by BASUP developers for "
          "cosmetic prescription.",

      'search_keyword': 'Search', // 이미 존재하던 것
      // 새로 추가
      'load_more': 'Load More',
      'all_customers_loaded': 'All customers loaded.',
      'no_search_results': 'No search results found.',
      "analyzing_skin_detail_1": "BASUP is retrieving your data.",
      "analyzing_skin_detail_2": "BASUP is now loading the microscope data.",
      "analyzing_skin_detail_3": "BASUP AI is analyzing the microscopic data.",
      "analyzing_skin_detail_4": "BASUP is generating the skin analysis "
          "report.",
      "error_occurred" : "Network Error",
      "error_text" : "Try later",
      "check_later" : "Check",

    },
    'ko_KR': {
      'contact_basup': 'BASUP에 연락하여 사전 회원가입을 하고 로그인해주세요',
      'user_id': '아이디',
      'password': '비밀번호',
      'login': '로그인',
      'login_fail': '로그인 실패',
      'login_fail_comment' : '아이디와 비밀번호가 다릅니다\n다시 입력해주세요.',
      'skin_microscope': '피부 현미경 촬영',
      'confirm_microscope': '확인을 누르시면 현미경 촬영으로 넘어갑니다.',
      'proceed_later': '다음에 진행',
      'proceed_microscope': '현미경 진행',
      'skin_data_complete': '피부 데이터 완료',
      'view_results': '결과보기를 누르시면 결과가 보여집니다.',
      'check_later': '다음에 확인',
      'view_result': '결과보기',
      'no_skin_data': '피부 데이터',
      'no_skin_data_comment': '피부 데이터가 없습니다 피부 문진을 진행해주세요.',
      'proceed_questionnaire': '문진 진행',
      'login_failed': '로그인 실패',
      'login_failed_comment': '자격 증명을 확인하고 다시 시도해주세요.',
      '력': '현미경 입력',
      'connect_via_qr': '피부 현미경 데이터를 아래의 QR코드를 사용하여\n스마트폰 카메라로 접속해주세요.',
      'proceed_homepage': '홈페이지에서 진행',
      'customers_list': '고객 리스트',
      'error_occurred': '에러가 발생했습니다. 뒤로가주세요',
      'no_customers': '고객이 없습니다. 여기를 클릭해서 첫번째 고객을 등록하세요',
      'age_recent_test':'나이: @age, 최근검사일: @recent_test',
      'register_customer': '고객 등록하기',
      'age': '나이',
      'recent_test': '최근 검사일',
      'click_register': '첫 고객 등록을 위해 클릭하세요',
      'welcome_user': '@name님을 환영합니다.',
      'welcome_guest': 'BASUP 피부 문진을 클릭해서\n새로운 고객을 등록해주세요.',
      'skin_questionnaire': 'BASUP 피부 문진',
      'skin_measurement_input': 'BASUP 피부 측정기 입력',
      'skin_microscope_input': 'BASUP 피부 현미경 입력',
      'skin_results_check': 'BASUP 피부 결과 확인',
      'logout': '로그아웃',
      'error_no_user': '사용자 ID가 제공되지 않았습니다.',
      'skin_measure_machine': '피부 측정기',
      'enter_skin_values': '피부 세안후 BASUP 피부 측정기로\n측정하여 나온 값을 적어주세요.',
      'submit': '제출하기',
      'moisture': '수분',
      'oil': '유분',
      'wrinkle': '주름',
      'pore': '모공',
      'corneous': '각질',
      'blemishes': '잡티',
      'sebum': '피지',
      'skin_microscope': '피부 현미경',
      'open_camera': '스마트폰으로 현재 창을 켜주세요. \n현미경을 연결하여 BASUP 피부 현미경로\n측정하여 나온 값을 적어주세요.',
      'capture_left_led': 'Left LED 촬영',
      'recapture_left_led': 'Left LED 재촬영',
      'capture_right_led': 'Right LED 촬영',
      'recapture_right_led': 'Right LED 재촬영',
      'capture_head_led': 'Head LED 촬영',
      'recapture_head_led': 'Head LED 재촬영',
      'capture_left_uv': 'Left UV 촬영',
      'recapture_left_uv': 'Left UV 재촬영',
      'capture_right_uv': 'Right UV 촬영',
      'recapture_right_uv': 'Right UV 재촬영',
      'capture_head_uv': 'Head UV 촬영',
      'recapture_head_uv': 'Head UV 재촬영',
      'submit': '제출하기',
      'uploading_data': '데이터 업로드중',
      'error_uploading_files': '파일 업로드 중 오류가 발생했습니다: @error',
      'analyzing_skin': 'BASUP SKIN AI 분석중...',
      'analyzing_skin_detail': '총 4가지의 피부 데이터를 기반으로\n고객님의 피부를 다방면으로 분석하고 있습니다.',
      "skin_diagnosis_title": "피부 상태 진단",
      "detailed_prescription_collect_info": "자세한 처방을 목적으로 수집하며,\n그 외 어떠한 용도로도 사용하지 않아요!",
      "enter_cosmetic_info": "화장품 정보를 입력해주세요\n예) 닥터지 - 레드 블레미쉬 수딩 토너",
      "enter_skin_concerns": "피부 고민을 적어주세요\n예) 아침에 화장품을 발라도 점심만 되어도 땡겨요",
      "next": "다음",
      'no_search_results' :
  "현재 등록된 고객이 없습니다.\n우측 하단에서 신규 회원을 추가해주세요.",
      'skin_analysis_results': '님의 피부 분석 결과',

      '288_result' : "288가지의 피부 타입 중\n",
      'anlayzed_result' :"님의 피부를 분석했어요.",
      'no_results': '결과가 없습니다.',
      'skin_type_description': '피부 타입 설명:',
      'expert_opinion': '전문가 의견:',
      'personalized_care_instructions': '맞춤 관리 방법',
      'matched_ingredients': '처방 성분',
      'recommend_products': '추천 제품',
      'prescription_ingredients_title': '피부 타입에 맞는 성분 처방!',
      'ingredients_benefit': '이런 성분이 잘 맞아요.',
      'your_skin_type_is': '님의 피부 타입은',
      'skin_type':"피부 타입",

      'resistance': '저항성',
      'elasticity': '탄력성',
      'pigmentation': '색소침착',
      'moisture_retention': '수분보유력',
      'oil_retention': '유분보유력',
      'insufficient': '부족',
      'good': '좋음',
      'severe': '심함',
      'skin_barrier': '피부장벽',
      'sensitive_skin': '민감성피부',
      'sufficient_moisture': '수분 충분',
      'lacking_moisture': '수분 부족',
      'elasticity': '탄력',
      'pigmentation_vulnerability': '색소 취약',
      'result_time' : '진단 결과',
  'user_general_info' : "기본 정보",
      'info_input' : "피부 진단을 위한\n간단한 기본 정보를 입력해주세요.",
      'start_diagnostice' : "진단 시작하기",
      'year' : '년',
      'month' : '월',
      'day' : '일',
      'name' : '이름',
      'sex_m' : '남성',
      'sex_w' : '여성',

      "skin_diagnosis": "피부 상태 진단",
      "hydration_diagnosis": "수분량 진단",
      "sebum_diagnosis": "유분량 진단",
      "wrinkle_elasticity_diagnosis": "주름 / 탄력 진단",
      "pigmentation_check": "색소 침착 확인",
      "sensitivity_check": "민감성 확인",
      "previous_question":"이전 질문으로 가기",

      "submit":"제출",
      "sending_skin_data": "피부 진단 데이터를 BASUP 서버로 전송중입니다.",
      "data_use_disclaimer": "해당 데이터는 BASUP 개발진이 \n화장품 처방하는데 사용됩니다.",
      'search_keyword': '검색', // 이미 존재하던 것
      // 새로 추가
      'load_more': '더 보기',
      'all_customers_loaded': '모든 고객을 불러왔습니다.',
      'no_search_results': '검색 결과가 없습니다.',
      "analyzing_skin_detail_1": "🔍 고객님의 데이터를 불러오는 중입니다. 잠시만 기다려 주세요!",
      "analyzing_skin_detail_2": "📸 피부 현미경 데이터를 불러오는 중입니다. 잠시만 기다려 주세요!",
      "analyzing_skin_detail_3": "🤖 BASUP AI가 피부 데이터를 정밀 분석 중입니다. 곧 맞춤 솔루션을 제공해 드릴게요!",
      "analyzing_skin_detail_4": "📝 피부 결과보고서를 작성 중입니다. 곧 최적의 솔루션을 확인하실 수 있어요!",

      "error_occurred" : "Network Error",
      "error_text" : "잠시 후에 다시 시도해주세요.",
      "check_later" : "확인",
    },
    // 추가 언어 지원
  };
}
//
// INSERT INTO SURVEY_LANGUAGE (survey_version, type, contents, reg_date, mod_date, language)
// VALUES
// ('0.1', 'initial', '{\"questions\":[{\"id\": 1,\"questionType\": 1,\"questionTitle\": \"For cosmetic prescription\\nExisting I need information about the cosmetics you are using. \\nPlease write the brand and product name of the cosmetics you are using!\",\"answerList\": [],\"answerType\" : 1},{ \"id\": 2,\"questionType\": 1,\"questionTitle\": \"Please tell us what you know about your skin for 1:1 prescription!\\n Any information is okay. :D \\nIf you don\'t know, you can say you don\'t know!\",\"answerList\": [],\"answerType\" : 1},{\"id\": 3 ,\"questionType\": 2,\"questionTitle\": \"Have you had symptoms of dryness and tightness in your face over the past two weeks?\",\"answerList\": [\"Always\",\"Sometimes There was\",\"Almost not\",\"Not at all\"],\"answerType\" : 0},{\"id\": 4,\"questionType\": 2,\"questionTitle\" : \"What is the condition of your skin after washing your face with cleanser?\",\"answerList\": [\"It feels dry and tight\",\"It feels a little dry, but there is no tightness\", \"It feels normal\",\"It feels greasy\"],\"answerType\" : 0},{\"id\": 5,\"questionType\": 2,\"questionTitle\" : \"Is your skin moist when you don\'t use moisturizer?\",\"answerList\": [\"It\'s not moist at all and it\'s a lot of tightness\",\"It\'s almost not moist and it\'s a little tight\",\ "Sometimes moist, no tightness\",\"Always moist\"],\"answerType\" : 0},{\"id\": 6,\"questionType\": 2,\"questionTitle\" : \"Have you had any symptoms of dead skin around your mouth or cheeks over the past two weeks? \",\"answerList\": [\"Always\",\"Sometimes\",\"Almost never\",\"Never\"],\"answerType\" : 0},{\ "id\": 7,\"questionType\": 3,\"questionTitle\": \"What is the level of sebum secretion on your face on a regular basis?\",\"answerList\": [\"It\'s relatively low\" ,\"Appropriate\",\"A lot only in the T-zone, such as around the forehead and nose\",\"A lot overall\"],\"answerType\" : 0},{\"id\": 8 ,\"questionType\": 3,\"questionTitle\": \"What is the condition of the makeup and the level of shine after 2-3 hours of makeup?\",\"answerList\": [\"Is the makeup stuck between the wrinkles? It is shiny and not shiny\",\"The makeup is smooth and not shiny\",\"The makeup is smooth and only shiny in the T-zone, such as around the forehead and nose\",\"It is shiny and very shiny overall.\"],\"answerType\" : 0},{\"id\": 9,\"questionType\": 3,\"questionTitle\": \"What is the condition of your skin 2-3 hours after using moisturizer? Is it?\",\"answerList\": [\"Very rough and dead skin cells\",\"Slightly rough and dull\",\"Slightly moist\",\"Moist and shiny\"], \"answerType\" : 0},{\"id\": 10,\"questionType\": 3,\"questionTitle\": \"How many pores are visible on your skin?\",\"answerList\" : [\"It\'s barely visible\",\"You can see it if you look close\",\"It\'s annoying\",\"It\'s visible overall.\"],\"answerType\" : 0},{\"id \": 11,\"questionType\": 4,\"questionTitle\": \"Do you see wrinkles or fine lines on your face? \",\"answerList\": [\"Thick wrinkles are clearly visible\",\"Wrinkles are visible around the eyes and mouth\",\"Fine, thin wrinkles are visible around the eyes and mouth\", \"invisible\"],\"answerType\" : 0},{\"id\": 12,\"questionType\": 4,\"questionTitle\": \"Time exposed to sunlight during daily life How much per day?\",\"answerList\": [\"More than 1 hour\",\"30 minutes to 1 hour\",\"Within 30 minutes\",\"Within 10 minutes or sunscreen Use\"],\"answerType\" : 0},{\"id\": 13,\"questionType\": 4,\"questionTitle\": \"Do you use sunscreen every day?\", \"answerList\": [\"Almost never used\",\"Used only when doing outdoor activities for long periods of time (less than 1-2 days a week)\",\"Used only when going out (3-6 days a week) )\",\"I use it every day\"],\"answerType\" : 0},{\"id\": 14,\"questionType\": 4,\"questionTitle\": \"Cigarettes a day Or how much do you smoke e-cigarettes? (Including secondhand smoke)\",\"answerList\": [\"I smoke every day (1 pack or more)\",\"I smoke occasionally (10 or more cigarettes)\",\"I have smoked in the past, but I do not currently smoke\" ",\"I have never smoked\"],\"answerType\" : 0},{\"id\": 15,\"questionType\": 4,\"questionTitle\": \"Press marks on my face How long does it take for the marks to disappear after they appear?\",\"answerList\": [\"More than 30 minutes (slow recovery speed)\",\"Within 10 to 30 minutes (moderate recovery speed)\", \"Within 10 minutes (quick recovery)\",\"Skin immediately returns to its original state (quick recovery)\"],\"answerType\" : 0},{\"id\": 16 ,\"questionType\": 5,\"questionTitle\": \"Do sun spots and blemishes (freckles) on your face become darker?\",\"answerList\": [\"They become very much darker\" ",\"It becomes slightly darker\",\"There are freckles and blemishes, but it does not become darker\",\"There are no freckles and blemishes\"],\"answerType\" : 0},{\"id\ ": 17,\"questionType\": 5,\"questionTitle\": \"Are there blemishes on areas exposed to ultraviolet rays?\",\"answerList\": [\"There are a lot\",\" Quite a lot\",\"A little\",\"None\"],\"answerType\" : 0},{\"id\": 18,\"questionType\": 5,\"questionTitle\" ": \"Do you have any serious symptoms of melasma that require treatment?\",\"answerList\": [\"It is very serious and is being treated\",\"Severe, but improves with treatment\",\"Melasma There is, but not to the extent that treatment is necessary\",\"Not applicable\"],\"answerType\" : 0},{\"id\": 19,\"questionType\": 5,\" questionTitle\": \"Does the pigment tend to remain dark where there was acne or inflammation?\",\"answerList\": [\"It always occurs, and recovery is very slow\",\"It occurs frequently, and recovery is slow. \",\"It happens sometimes, but it recovers quickly\",\"It doesn\'t happen at all\"],\"answerType\" : 0},{\"id\": 20,\"questionType\": 6, \"questionTitle\": \"Have you had acne or red pimples on your face within the past year?\",\"answerList\": [\"It occurs more than once a week\",\"It occurs more than once a month does\",\"rarely occurs\",\"never occurs\"],\"answerType\" : 0},{\"id\": 21,\"questionType\": 6,\ "questionTitle\": \"Have you had symptoms of atopic dermatitis, eczema, or contact dermatitis within the past year?\",\"answerList\": [\"I have been diagnosed and receiving treatment due to severe symptoms\",\"Frequently It gets scaly and red and itchy\",\"Sometimes it gets scaly and itchy\",\"No symptoms at all\"],\"answerType\" : 0},{\"id\": 22,\ "questionType\": 6,\"questionTitle\": \"After using cosmetics, do you experience rashes and stinging or itchy symptoms?\",\"answerList\": [\"Symptoms always appear\",\" Symptoms appear often\",\"Symptoms appear sometimes\",\"Symptoms do not appear at all\"],\"answerType\" : 0},{\"id\": 23,\"questionType\" : 6,\"questionTitle\": \"Do you have any symptoms such as facial flushing or vasodilation?\",\"answerList\": [\"Have been diagnosed\",\"Strong movement and emotional changes, The face turns red a lot due to temperature changes\",\"Strong exercise and emotional changes, the face turns slightly red due to temperature changes\",\"No symptoms at all\"],\"answerType\" : 0} ,{\"id\": 24,\"questionType\": 6,\"questionTitle\": \"Do you have any allergic symptoms to substances such as accessories, pollen, food, or perfume?\",
// \"answerList\": [\"I always have an allergic reaction\",\"I have an allergic reaction often\",\"I have an allergic reaction sometimes\",\"I never have an allergic reaction\"],\"answerType\" : 0}]}', '2022-04-15 22:54:07','2023-05-08 14:59:23', 'English');