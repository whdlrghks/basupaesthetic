class SurveyEachItem{
  String date;
  String surveyId;
  bool onlysurvey;
  SurveyEachItem({
    required this.date,
    required this.surveyId,
    required this.onlysurvey,
  });
  factory SurveyEachItem.fromMap(Map<String, dynamic> map) {
    return SurveyEachItem(
      date: map['date'] as String,
      surveyId: map['survey_id'] as String,
      onlysurvey: map['onlysurvey'] as bool,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SurveyEachItem &&
              runtimeType == other.runtimeType &&
              surveyId == other.surveyId &&
              date == other.date;

  @override
  int get hashCode => surveyId.hashCode ^ date.hashCode;
}
class SkinSurveyResult {
  List<dynamic> cosIngredients;
  List<dynamic> ingredient;
  List<dynamic> detail;
  List<String> routineContent;
  List<String> routineKeyword;
  List<String> skinResultWebContent;

  List<String> skinResultContent;
  List<List<String>> skinResultWebIngre;
  int sensper;
  int tightper;
  int waterper;
  int oilper;
  int pigper;
  String type;
  List<String> tag;
  List<bool> tagFlag;

  SkinSurveyResult({
    List<dynamic>? cosIngredients,
    List<dynamic>? ingredient,
    List<dynamic>? detail,
    List<String>? routineContent,
    List<String>? routineKeyword,
    List<String>? skinResultWebContent,
    List<List<String>>? skinResultWebIngre,
    List<String>? skinResultContent,
    int? sensper,
    int? tightper,
    int? waterper,
    int? oilper,
    int? pigper,
    String? type,
    List<String>? tag,
    List<bool>? tagFlag,
  })  : cosIngredients = cosIngredients ?? [],
        ingredient = ingredient ?? [],
        detail = detail ?? [],
        routineContent = routineContent ?? [],
        routineKeyword = routineKeyword ?? [],
        skinResultWebContent = skinResultWebContent ?? [],
        skinResultWebIngre = skinResultWebIngre ?? [],
        skinResultContent = skinResultContent ?? [],
        sensper = sensper ?? 0,
        tightper = tightper ?? 0,
        waterper = waterper ?? 0,
        oilper = oilper ?? 0,
        pigper = pigper ?? 0,
        type = type ?? "",
        tag = tag ?? [],
        tagFlag = tagFlag ?? [];

  /// Map의 키에 해당하는 값이 있으면 해당 필드를 업데이트합니다.
  void updateFromMap(Map<String, dynamic> data) {
    if (data.containsKey('cos_ingredients')) {
      cosIngredients = List<dynamic>.from(data['cos_ingredients'] ?? []);
    }
    if (data.containsKey('ingredient')) {
      ingredient = List<dynamic>.from(data['ingredient'] ?? []);
    }
    if (data.containsKey('detail')) {
      detail = List<dynamic>.from(data['detail'] ?? []);
    }
    if (data.containsKey('routinecontent')) {
      routineContent = List<String>.from(data['routinecontent'] ?? []);
    }
    if (data.containsKey('routinekeyword')) {
      routineKeyword = List<String>.from(data['routinekeyword'] ?? []);
    }
    if (data.containsKey('skinResultWebContent')) {
      skinResultWebContent = List<String>.from(data['skinResultWebContent'] ?? []);
    }
    if (data.containsKey('skinResultContent')) {
      skinResultContent = List<String>.from(data['skinResultContent'] ?? []);
    }
    if (data.containsKey('skinResultWebIngre')) {
      var temp = data['skinResultWebIngre'];
      if (temp is List) {
        skinResultWebIngre = temp.map<List<String>>((e) {
          return List<String>.from(e);
        }).toList();
      }
    }
    if (data.containsKey('sensper')) {
      sensper = data['sensper'] is int
          ? data['sensper']
          : int.tryParse(data['sensper'].toString()) ?? 0;
    }
    if (data.containsKey('tightper')) {
      tightper = data['tightper'] is int
          ? data['tightper']
          : int.tryParse(data['tightper'].toString()) ?? 0;
    }
    if (data.containsKey('waterper')) {
      waterper = data['waterper'] is int
          ? data['waterper']
          : int.tryParse(data['waterper'].toString()) ?? 0;
    }
    if (data.containsKey('oilper')) {
      oilper = data['oilper'] is int
          ? data['oilper']
          : int.tryParse(data['oilper'].toString()) ?? 0;
    }
    if (data.containsKey('pigper')) {
      pigper = data['pigper'] is int
          ? data['pigper']
          : int.tryParse(data['pigper'].toString()) ?? 0;
    }
    if (data.containsKey('type')) {
      type = data['type']?.toString() ?? "";
    }
    if (data.containsKey('tag')) {
      tag = List<String>.from(data['tag'] ?? []);
    }
    if (data.containsKey('tag_flag')) {
      tagFlag = List<bool>.from(data['tag_flag'] ?? []);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'cos_ingredients': cosIngredients,
      'ingredient': ingredient,
      'detail': detail,
      'routinecontent': routineContent,
      'routinekeyword': routineKeyword,
      'skinResultWebContent': skinResultWebContent,
      'skinResultWebIngre': skinResultWebIngre,
      'skinResultContent' : skinResultContent,
      'sensper': sensper,
      'tightper': tightper,
      'waterper': waterper,
      'oilper': oilper,
      'pigper': pigper,
      'type': type,
      'tag': tag,
      'tag_flag': tagFlag,
    };
  }
}

class Customer {
  final String aestheticId;
  final String age;
  // final String date;
  final String name;
  final String sex;

  final List<SurveyEachItem> surveys; // Changed to store SurveyItem objects
  // final String surveyId;
  final String user_id;

  Customer({
    required this.aestheticId,
    required this.age,
    required this.name,
    required this.sex,
    required this.surveys, // Now expects a list of SurveyItem objects
    required this.user_id,
  });

  factory Customer.fromFirestore(Map<String, dynamic> firestore) {
    var surveyItems = <SurveyEachItem>[];
    if (firestore['surveys'] != null) {
      // Ensure each item is treated as a Map<String, dynamic>
      var surveysList = List<Map<String, dynamic>>.from(firestore['surveys']);
      surveyItems = surveysList.map((item) => SurveyEachItem.fromMap(item)).toList();
    }

    return Customer(
      aestheticId: firestore['aestheticId'] as String,
      age: firestore['age'] as String,
      name: firestore['name'] as String,
      sex: firestore['sex'] as String,
      surveys: surveyItems,
      user_id: firestore['user_id'] as String,
    );
  }


  // Method to add a new survey item to the customer
  void addSurvey(SurveyEachItem surveyItem) {
    surveys.add(surveyItem);
  }

  // Add this method to find the most recent survey date
  String? getMostRecentSurveyDate() {
    if (surveys.isEmpty) {
      return null; // Or handle accordingly if no surveys exist
    }

    // Sort the surveys by date in descending order to get the most recent date first
    surveys.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    // Return the date of the most recent survey
    return surveys.first.date;
  }
  // Method to find the most recent survey item
  SurveyEachItem? getMostRecentSurvey() {
    if (surveys.isEmpty) {
      return null; // Or handle accordingly if no surveys exist
    }

    // Sort the surveys by date in descending order to get the most recent one first
    surveys.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    // Return the most recent survey item
    return surveys.first;
  }
}