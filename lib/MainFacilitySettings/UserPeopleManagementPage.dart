import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Allim/WriteAllimPage.dart';
import 'package:http/http.dart' as http;
import '../provider/ResidentProvider.dart'; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

class userPeopleManagementPage extends StatefulWidget {
  const userPeopleManagementPage({Key? key}) : super(key: key);

  @override
  State<userPeopleManagementPage> createState() => _userPeopleManagementPageState();
}


class _userPeopleManagementPageState extends State<userPeopleManagementPage> with TickerProviderStateMixin {
  static List<Map<String, dynamic>> _residents = [];

  Future<void> getFacilityResident(int facilityId) async {
    http.Response response = await http.get(
        Uri.parse(backendUrl + "nhResidents/protectors/" + facilityId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residents =  parsedJson;
    });
  }

  //삭제
  Future<void> deleteresident(int userId, int nhresidentId) async {
    http.Response response = await http.delete(
        Uri.parse(backendUrl + 'nhResidents'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "user_id": userId,
          "nhresident_id": nhresidentId
        })
    );

    if (response != 200)
      // 화면 다시 그리기
      setState(() {
        _residents.removeWhere((resident) => resident['user_id'] == userId);
        _residents.removeWhere((resident) => resident['nhresident_id'] == nhresidentId);
      });
  }

  @override
  void initState() {
    super.initState();
    final residentProvider = context.read<ResidentProvider>();
    getFacilityResident(residentProvider.facility_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('입소자 관리')),
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
          builder: (context, residentProvider, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _residents.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.person_rounded, color: Colors.grey),
                  title: Row(
                    children: [
                      Text('${_residents[index]['name']} 님'),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: themeColor.getColor(),)
                            ),
                            onPressed: () async {
                              //입소자 삭제
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
                                              await deleteresident(_residents[index]['user_id'], _residents[index]['id']);
                                            } catch(e) {
                                            }
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            child: Text('삭제',style: TextStyle(color: themeColor.getColor(),),)
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