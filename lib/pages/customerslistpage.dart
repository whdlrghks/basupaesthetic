import 'package:basup_ver2/component/loadingdialog.dart';
import 'package:basup_ver2/controller/localecontroller.dart';
import 'package:basup_ver2/controller/resultcontroller.dart';
import 'package:basup_ver2/controller/surveycontroller.dart';
import 'package:basup_ver2/data/customer.dart';
import 'package:basup_ver2/design/color.dart';
import 'package:basup_ver2/design/textstyle.dart';
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
    String customerKey =
        '${data['name']}_${data['age']}_${data['sex']}_${data['aestheticId']}';

    // If this customer group already exists, add the survey to it
    if (customerGroups.containsKey(customerKey)) {
      customerGroups[customerKey]!.surveys.add(
            SurveyEachItem(
                date: data['date'],
                surveyId: data['survey_id'],
                onlysurvey: data['onlysurvey']),
          );
    } else {
      // Otherwise, create a new customer group with this survey
      customerGroups[customerKey] = Customer(
        aestheticId: data['aestheticId'],
        age: data['age'],
        name: data['name'],
        sex: data['sex'],
        surveys: [
          SurveyEachItem(
              date: data['date'],
              surveyId: data['survey_id'],
              onlysurvey: data['onlysurvey'])
        ],
        user_id: data[
            'user_id'], // Assuming 'user_id' is how you identify the customer document
      );
    }
  }

  // Convert the map values to a list
  return customerGroups.values.toList();
}

class CustomersListPage extends StatefulWidget {
  final String aestheticId;

  const CustomersListPage({Key? key, required this.aestheticId})
      : super(key: key);

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  final resultcontroller = Get.find<ResultController>(tag: "result");
  final surveyController = Get.find<SurveyController>(tag: "survey");
  final localeController = Get.find<LocaleController>();

  /// 페이징 관련 변수
  final int _limit = 10; // 한 번에 가져올 문서 수
  DocumentSnapshot? _lastDoc; // 마지막으로 가져온 문서
  bool _isLoading = false; // 현재 로딩 중인지
  bool _hasMore = true; // 더 가져올 데이터가 있는지 여부

  /// 실제 표시할 고객 리스트
  List<Customer> _customers = [];

  // ----- 검색 기능 추가 -----
  bool _isSearching = false; // 검색 모드인지 여부
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    print("aestheticId -> " + widget.aestheticId);
    super.initState();

    // 1) 컨트롤러 초기화 (한 번만 실행)
    const type = "initial";
    surveyController.readyforSheet(type);
    resultcontroller.initmachine();
    resultcontroller.initscope();
    resultcontroller.aestheticId.value = widget.aestheticId;

    // 첫 페이지 로딩
    _loadNextPage();
  }

  /// Firestore에서 다음 페이지를 불러와 _customers에 이어붙임
  Future<void> _loadNextPage() async {
    print("_loadNextPage");
    // 중복 호출 방지
    if (_isLoading) return;
    if (!_hasMore) return; // 더 이상 가져올 것이 없으면 종료

    setState(() => _isLoading = true);

    Query query = FirebaseFirestore.instance
        .collection('users')
        .where('aestheticId', isEqualTo: widget.aestheticId)
        // 페이징을 위해 반드시 정렬 기준이 있어야 함 (예: 이름으로 정렬)
        .orderBy('name', descending: false)
        .limit(_limit);

    // 이전에 가져온 문서가 있다면, 해당 문서 다음부터 가져옴
    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    try {
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        // 다음 호출을 위한 마지막 문서 갱신
        _lastDoc = querySnapshot.docs.last;

        // 가져온 문서들을 Customer로 변환 + 그룹화
        final newCustomers = _transformDocsToCustomers(querySnapshot.docs);

        // 기존 목록에 이어붙이기
        setState(() {
          _customers.addAll(newCustomers);
        });
      } else {
        // 더 이상 문서가 없으면
        setState(() {
          _hasMore = false;
        });
      }
    } catch (e) {
      debugPrint('Error while loading next page: $e');
      // 필요하면 에러 처리를 진행
    }

    setState(() => _isLoading = false);
  }

  /// 기존 searchCustomers()의 그룹화 로직을 페이징 버전에 맞춰 변형
  /// - 문서들을 돌며 Customer를 만들고, 같은 key(이름/나이/성별 등)면 surveys에 추가
  /// - 여기서는 예시로 기존 customerKey 방식 사용
  List<Customer> _transformDocsToCustomers(List<QueryDocumentSnapshot> docs) {
    final Map<String, Customer> customerGroups = {};

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Create a unique key (name + age + sex + aestheticId)
      String customerKey =
          '${data['name']}_${data['age']}_${data['sex']}_${data['aestheticId']}';

      if (customerGroups.containsKey(customerKey)) {
        customerGroups[customerKey]!.surveys.add(
              SurveyEachItem(
                  date: data['date'],
                  surveyId: data['survey_id'],
                  onlysurvey: data['onlysurvey']),
            );
      } else {
        customerGroups[customerKey] = Customer(
          aestheticId: data['aestheticId'],
          age: data['age'],
          name: data['name'],
          sex: data['sex'],
          surveys: [
            SurveyEachItem(
                date: data['date'],
                surveyId: data['survey_id'],
                onlysurvey: data['onlysurvey'])
          ],
          user_id: data['user_id'],
        );
      }
    }

    return customerGroups.values.toList();
  }

  /// ------------------------------------------------------------
  /// 검색 로직
  /// ------------------------------------------------------------
  Future<void> _searchCustomersByName(String searchText) async {
    if (searchText.isEmpty) return;
    // 검색 모드 ON
    _isSearching = true;
    setState(() => _isLoading = true);

    // startAt, endAt으로 부분 검색
    try {
      final query = FirebaseFirestore.instance
          .collection('users')
          .where('aestheticId', isEqualTo: widget.aestheticId)
          .orderBy('name')
          .startAt([searchText]).endAt([searchText + '\uf8ff']);

      final snap = await query.get();
      final docs = snap.docs;
      final searchedCustomers = _transformDocsToCustomers(docs);

      setState(() {
        _customers = searchedCustomers;
        _hasMore = false; // 검색 결과에는 더 보기 버튼 비활성화
      });
    } catch (e) {
      print("검색 에러: $e");
    }

    setState(() => _isLoading = false);
  }

  /// 검색어 리셋 -> 페이징 초기화
  void _resetSearch() {
    _searchController.clear();
    _isSearching = false;
    _customers.clear();
    _lastDoc = null;
    _hasMore = true;
    _isLoading = false;
    _loadNextPage(); // 다시 페이징 로딩
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'customers_list'.tr,
          style: TextStyle(
            color: Colors.white, // 텍스트 흰색 지정
          ),
        ),
        backgroundColor: const Color(0xFF49A85E),
        actions: [
          // 검색 TextField
          Container(
            width: 180,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: 14,
                color: Colors.white, ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                hintText: 'search_keyword'.tr, // 예: "검색어 입력"

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintStyle: TextStyle(color: Colors.white),
              ),
              onSubmitted: (value) {
                final txt = value.trim();
                if (txt.isNotEmpty) {
                  _searchCustomersByName(txt);
                }
              },
            ),
          ),
          // 검색 버튼
          IconButton(
            icon: Icon(Icons.search,
              color: Colors.white, // 아이콘 흰색 지정
            ),
            onPressed: () {
              final txt = _searchController.text.trim();
              if (txt.isNotEmpty) {
                _searchCustomersByName(txt);
              }
            },
          ),
          // 리셋 버튼
          IconButton(
            icon: Icon(Icons.clear,
              color: Colors.white, // 아이콘 흰색 지정
            ),
            onPressed: _resetSearch,
          ),
        ],
      ),
      // NotificationListener로 스크롤이 끝났을 때 감지
      body: Column(
        children: [
          // 고객 목록 표시 (고정 높이 or 그냥 Column + Wrap도 가능)
          Expanded(
            child: _customers.isNotEmpty
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                    itemCount: _customers.length,
                    itemBuilder: (context, index) {
                      final customer = _customers[index];
                      return _buildCustomerTile(customer);
                    },
                  )
                : Container(), // _customers가 없으면 빈 컨테이너 표시 (아래에서 메시지 처리)
          ),

          // 추가 로딩 or "더 보기" 버튼
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else if (!_isSearching && _hasMore && _customers.isNotEmpty)
            // 검색 중이 아니고(hasMore == true) 고객 목록이 있으면 "더 보기"
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _loadNextPage,
                child: Text(
                  "load_more".tr,
                  style: more_button,
                ),
                style: ButtonStyle(
                  // Setting the background color
                  backgroundColor: MaterialStateProperty.all(Color(0xFF49A85E)),
                  // Setting the foreground color (text color)
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // Setting padding
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)),
                  // Setting the shape
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFF49A85E)),
                    ),
                  ),
                ),
              ),
            )
          else if (!_isSearching && !_hasMore && _customers.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("all_customers_loaded".tr),
            )
          else if (_customers.isEmpty && !_isLoading)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("no_search_results".tr),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _onFabPressed();
        },
        backgroundColor: const Color(0xFF49A85E),
        icon: const Icon(
          Icons.person_add,
          color: Colors.white, // 아이콘 흰색 지정
        ),
        label: const Text(
          "신규 회원 추가",
          style: TextStyle(
            color: Colors.white, // 텍스트 흰색 지정
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerList() {
    // 아직 아무것도 로딩되지 않았고 _isLoading 중이면 첫 로딩 화면
    if (_customers.isEmpty) {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        // 로딩도 아니고 데이터가 비었으면 "no_customers" 상태
        return Center(
          child: ElevatedButton(
            onPressed: () => Get.toNamed("/survey"),
            child: Text('no_customers'.tr),
          ),
        );
      }
    }

    // _customers가 있으면 ListView.builder
    return ListView.builder(
      // +1: 하단 로딩 인디케이터(또는 끝 표시)를 위한 여분
      itemCount: _customers.length + 1,
      itemBuilder: (context, index) {
        if (index < _customers.length) {
          final customer = _customers[index];
          return _buildCustomerTile(customer);
        } else {
          // 마지막 아이템 아래쪽
          if (_isLoading) {
            // 추가로딩 중이면 인디케이터 표시
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            // 더 로딩할 데이터가 없거나 로딩이 끝났으면 빈 위젯
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _buildCustomerTile(Customer customer) {
    return ListTile(
      onTap: () => _onCustomerSelected(customer), // 타일 전체를 클릭하면 이동
      title: Text(customer.name),
      subtitle: Text(
        'age_recent_test'.trParams({
          'age': customer.age.toString(),
          'recent_test': customer.getMostRecentSurveyDate().toString()
        }),
      ),
      trailing: const Icon(Icons.arrow_forward),
    );
    // return ListTile(
    //   title: Text(customer.name),
    //   subtitle: Text(
    //     'age_recent_test'.trParams({
    //       'age': customer.age.toString(),
    //       'recent_test': customer.getMostRecentSurveyDate().toString()
    //     }),
    //   ),
    //   trailing: IconButton(
    //     icon: const Icon(Icons.arrow_forward),
    //     onPressed: () => _onCustomerSelected(customer),
    //   ),
    // );
  }

  Future<void> _onCustomerSelected(Customer customer) async {
    final mostRecentSurvey = customer.getMostRecentSurvey();
    if (mostRecentSurvey != null) {
      resultcontroller.age.value = customer.age;
      resultcontroller.name.value = customer.name;
      resultcontroller.gender.value =
          (customer.sex == "M") ? Gender.M : Gender.W;
      resultcontroller.aestheticId.value = customer.aestheticId;
      resultcontroller.survey_id.value = mostRecentSurvey.surveyId;
      resultcontroller.user_id.value = customer.user_id;
      resultcontroller.survey_date.value = mostRecentSurvey.date;
      resultcontroller.surveylist = customer.surveys;

      Get.toNamed("/index?userid=${resultcontroller.user_id.value}");
    } else {
      resultcontroller.age.value = customer.age;
      resultcontroller.name.value = customer.name;
      resultcontroller.gender.value =
          (customer.sex == "M") ? Gender.M : Gender.W;
      resultcontroller.aestheticId.value = customer.aestheticId;
      resultcontroller.user_id.value = customer.user_id;

      Get.toNamed("/shortform");
    }
  }

  Future<void> _onFabPressed() async {
    LoadingDialog.show();
    await localeController.loadLocale();
    await resultcontroller.initNewuser();
    await surveyController.readyforSheet('initial');
    LoadingDialog.hide();

    Get.toNamed("/survey");
  }
}
