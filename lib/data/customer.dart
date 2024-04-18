class SurveyItem{
  String date;
  String surveyId;
  SurveyItem({
    required this.date,
    required this.surveyId
  });
  factory SurveyItem.fromMap(Map<String, dynamic> map) {
    return SurveyItem(
      date: map['date'] as String,
      surveyId: map['survey_id'] as String,
    );
  }
}

class Customer {
  final String aestheticId;
  final String age;
  // final String date;
  final String name;
  final String sex;

  final List<SurveyItem> surveys; // Changed to store SurveyItem objects
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
    var surveyItems = <SurveyItem>[];
    if (firestore['surveys'] != null) {
      // Ensure each item is treated as a Map<String, dynamic>
      var surveysList = List<Map<String, dynamic>>.from(firestore['surveys']);
      surveyItems = surveysList.map((item) => SurveyItem.fromMap(item)).toList();
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
  void addSurvey(SurveyItem surveyItem) {
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
  SurveyItem? getMostRecentSurvey() {
    if (surveys.isEmpty) {
      return null; // Or handle accordingly if no surveys exist
    }

    // Sort the surveys by date in descending order to get the most recent one first
    surveys.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    // Return the most recent survey item
    return surveys.first;
  }
}