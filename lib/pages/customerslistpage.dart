import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/data/customer.dart';
import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/value.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

Future<List<Customer>> searchCustomers(String aestheticId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('aestheticId', isEqualTo: aestheticId)
      .get();

  // Temporary structure to hold grouped surveys
  Map<String, Customer> customerGroups = {};

  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    // Create a unique key based on customer identifiers
    String customerKey = '${data['name']}_${data['age']}_${data['sex']}_${data['aestheticId']}';

    // If this customer group already exists, add the survey to it
    if (customerGroups.containsKey(customerKey)) {
      customerGroups[customerKey]!.surveys.add(
        SurveyItem(date: data['date'], surveyId: data['survey_id']),
      );
    } else {
      // Otherwise, create a new customer group with this survey
      customerGroups[customerKey] = Customer(
        aestheticId: data['aestheticId'],
        age: data['age'],
        name: data['name'],
        sex: data['sex'],
        surveys: [SurveyItem(date: data['date'], surveyId: data['survey_id'])],
        user_id: data['user_id'], // Assuming 'user_id' is how you identify the customer document
      );
    }
  }

  // Convert the map values to a list
  return customerGroups.values.toList();
}

class CustomersListPage extends StatelessWidget {
  final String aestheticId;

  var resultcontroller = Get.find<ResultController>(tag: "result");
  CustomersListPage({required this.aestheticId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고객 리스트'),
        backgroundColor: Color(0xFF49A85E),
      ),
      body: FutureBuilder<List<Customer>>(
        future: searchCustomers(aestheticId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.error != null) {
            // Handle errors.
            return Center(child: Text('에러가 발생했습니다. 뒤로가주세요'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: ElevatedButton( onPressed: () {
              Get.toNamed("/survey");
            },
            child : Text('고객이 없습니다. 여기를 '
            '클릭해서 첫번째'
                ' 고객을 '
                '등록하세요')));
          }

          final customers = snapshot.data!;
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer.name),
                subtitle: Text('나이: ${customer.age}, 최근검사일: ${customer.getMostRecentSurveyDate()}'),
                // Add other customer details here.
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    SurveyItem? mostRecentSurvey = customer.getMostRecentSurvey();
                    if(mostRecentSurvey !=null){
                      resultcontroller.age.value = customer.age;
                      resultcontroller.name.value = customer.name;
                      resultcontroller.gender.value = customer.sex =="M" ?
                      Gender.M : Gender.W;
                      resultcontroller.aestheticId.value = customer.aestheticId;
                      resultcontroller.survey_id.value = customer
                          .getMostRecentSurvey()!.surveyId;
                      resultcontroller.user_id.value = customer.user_id;
                      resultcontroller.survey_date.value = customer
                          .getMostRecentSurvey()!.date;
                      resultcontroller.surveylist = customer.surveys;
                      Get.toNamed("/index?userid="+resultcontroller.user_id.value);
                    }
                    else{
                      resultcontroller.age.value = customer.age;
                      resultcontroller.name.value = customer.name;
                      resultcontroller.gender.value = customer.sex =="M" ?
                      Gender.M : Gender.W;
                      resultcontroller.aestheticId.value = customer.aestheticId;
                      resultcontroller.user_id.value = customer.user_id;
                      Get.toNamed("/shortform" );
                    }

                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/survey");
        },
        backgroundColor: Color(0xFF49A85E),
        child: Icon(Icons.plus_one),
      ),
    );
  }
}
