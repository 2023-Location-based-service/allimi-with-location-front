import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Allim/WriteAllimPage.dart';
import 'package:http/http.dart' as http;

import '../provider/ResidentProvider.dart';

import 'package:test_data/Backend.dart';
class PeopleManagementPage extends StatefulWidget {
  const PeopleManagementPage({Key? key}) : super(key: key);

  @override
  State<PeopleManagementPage> createState() => _PeopleManagementPageState();
}

class _PeopleManagementPageState extends State<PeopleManagementPage> with TickerProviderStateMixin {
  static List<Map<String, dynamic>> _employee = [];

  Future<void> getFacilityEmployee(int facilityId) async {
    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "nhResidents/facility/" + facilityId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _employee =  parsedJson;
    });
  }

  //삭제
  Future<void> deleteEmployee(int userId,int nhresidentId) async {
    http.Response response = await http.delete(
        Uri.parse(Backend.getUrl()+ 'nhResidents'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "user_id": userId,
          "nhresident_id": nhresidentId
        })
    );

    if (response.statusCode == 200)
      // 화면 다시 그리기
      setState(() {
        _employee.removeWhere((resident) => resident['user_id'] == userId);
        _employee.removeWhere((resident) => resident['nhresident_id'] == nhresidentId);
      });
  }

  @override
  void initState() {
    super.initState();
    final residentProvider = context.read<ResidentProvider>();
    getFacilityEmployee(residentProvider.facility_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('직원 관리')),
      body: ListView(
        children: [
          approve()
        ],
      )
    );
  }

  Widget approve(){
    return Container(
      padding: EdgeInsets.only(left: 5, top: 10),
      child: Consumer<ResidentProvider>(
        builder: (context, residentProvider, child){
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _employee.length,
            itemBuilder: (BuildContext context, int index) {

              String userRole = '알 수 없음';
              if (_employee[index]['user_role'] == 'PROTECTOR') {
                userRole = '보호자';
              } else if (_employee[index]['user_role'] == 'MANAGER') {
                userRole = '시설장';
              } else if (_employee[index]['user_role'] == 'WORKER') {
                userRole = '직원';
              }

              if (_employee[index]['user_role'] == 'PROTECTOR') {
                return Container();
              }
              return ListTile(
                leading: Icon(Icons.person_rounded, color: Colors.grey),
                title: Row(
                  children: [
                    Text('${_employee[index]['name']} 님 (' + userRole +')'),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(2),
                      child: OutlinedButton(
                          // style: OutlinedButton.styleFrom(
                          //     side: BorderSide(color: themeColor.getColor(),)
                          // ),
                          onPressed: () async {
                            //직원 삭제
                            showDialog(
                                context: context,
                                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text("정말 삭제하시겠습니까?"),
                                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                    actions: [
                                      TextButton(
                                        child: Text('취소',style: TextStyle(color: themeColor.getColor(),),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('삭제',style: TextStyle(color: themeColor.getColor(),),),
                                        onPressed: () async {
                                          try {
                                            await deleteEmployee(_employee[index]['user_id'], _employee[index]['id']);
                                          } catch(e) {
                                          }

                                          getFacilityEmployee(residentProvider.facility_id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                }
                            );
                          },
                          child: Text('삭제',style: TextStyle(color: Colors.grey))
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}