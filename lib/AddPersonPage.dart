import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';

import 'package:test_data/Backend.dart';
String backendUrl = Backend.getUrl();

// List<String> home =['금오요양원', '빛나요양원', '강아지요양원'];
// List<String> person =['구현진 님', '주효림 님', '권태연 님'];



class AddPersonPage extends StatefulWidget {
  const AddPersonPage({Key? key, required this.uid}) : super(key: key);

  final int uid;

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  late int _userId;
  List<Map<String, dynamic>> _residentList = [];

    @override
  void initState() {
    super.initState();
    _userId = widget.uid;
    getResident();
  }

  @override
  Widget build(BuildContext context) {
    return personList();
  }

  Future<void> getResident() async {
    debugPrint("@@@@@ 유저의 입소자들 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl+ 'nhResidents/' + _userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    if (response.statusCode != 200) {
        throw Exception('POST request failed');
    }

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);

    List<Map<String, dynamic>> parsedJsonList 
      = List<Map<String, dynamic>>.from(parsedJson['resident_list']);

    setState(() {
      _residentList = parsedJsonList;
    });
  }

  Future<void> changeResident(int residentId) async {
    debugPrint("@@@@@ 유저의 현재 입소자를 변경하는 백앤드 url 보냄");
    http.Response response = await http.patch(
      Uri.parse(backendUrl+ 'users/nhrs'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "user_id" : _userId,
        "nhr_id": residentId
      })
    );

    if (response.statusCode != 200)
      throw Exception();
  }


  Widget personList() {
    if (_residentList.length != 0) {
      return Scaffold(
      appBar: AppBar(title: Text('등록된 요양원 목록')),
      body: ListView.separated(
        itemCount: _residentList.length, //면회 목록 출력 개수
        itemBuilder: (context, index) {
          String userRoleString = _residentList[index]['user_role'];
          if (userRoleString == 'PROTECTOR')
            userRoleString = '보호자';
          else if (userRoleString == 'WORKER')
            userRoleString = '직원';
          else if (userRoleString == 'MANAGER')
            userRoleString = '시설장';
          else
            userRoleString = '알 수 없음';

          return Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.home_rounded, size: 50),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_residentList[index]['facility_name']!= null?_residentList[index]['facility_name']:"null"), //요양원
                    Row(
                      children: [
                        if (_residentList[index]['user_role'] == 'PROTECTOR')
                          Text(_residentList[index]['resident_name'] != null?_residentList[index]['resident_name']+"님":"null"),
                        if (_residentList[index]['user_role'] == 'WORKER')
                          Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                              return Text(userProvider.name + "님");
                            }
                          ),
                        SizedBox(width: 10),
                        Text("("+ userRoleString +")"),
                      ],
                    ), //사람 이름
                  ],
                ),
              onTap: () {
                //현재 입소자 바꿈
                changeResident(_residentList[index]['resident_id']);

                Provider.of<ResidentProvider>(context, listen:false)
                          .setInfo(_residentList[index]['resident_id'], _residentList[index]['facility_id'], _residentList[index]['facility_name'], 
                                    _residentList[index]['resident_name'], _residentList[index]['user_role'], '', '');

                Provider.of<UserProvider>(context, listen: false)
                          .setRole(_residentList[index]['user_role']);

                Provider.of<UserProvider>(context, listen: false)
                          .getData();

                Navigator.pop(context);
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
      ),
    );
  
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator()));
    }
  }
}
