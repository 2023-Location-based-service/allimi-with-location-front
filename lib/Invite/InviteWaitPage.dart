import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/AddFacilities.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/LoginPage.dart';
import '/ResidentInfoInputPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;

import 'package:test_data/Backend.dart';
String backendUrl = Backend.getUrl();
//사용자의 초대대기 화면

class InviteWaitPage extends StatefulWidget {
  @override
  _InviteWaitPageState createState() => _InviteWaitPageState();

  const InviteWaitPage({
    Key? key, 
    required this.uid
  }) : super(key: key);

  final int uid;
}

class _InviteWaitPageState extends State<InviteWaitPage> {
  late int _count ;
  int uid = 0;

  List<Map<String, dynamic>> _residentList = [];

  @override
  void initState() {
    this.uid = widget.uid;
    getResidentList(uid);
    
  }

  Future<void> getResidentList(int userId) async {
    debugPrint("@@@@@ 입소자 정보 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl + "users/invitations/" + userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residentList = parsedJson;
      this._count = parsedJson.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton (
                  child: Text(
                    '시설 추가하기',
                    style: TextStyle(fontSize: 18.0,),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: themeColor.getColor(),
                      padding: EdgeInsets.all(7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onPressed: (){
                    pageAnimation(context, AddFacilities());
                  }
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: ElevatedButton (
                  child: Text(
                    '로그아웃',
                    style: TextStyle(fontSize: 18.0, ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: themeColor.getColor(),
                      padding: EdgeInsets.all(7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            content: const Text('로그아웃하시겠습니까?'),
                            actions: [
                              TextButton(child: Text('아니오',
                                style: TextStyle(color: themeColor.getMaterialColor())),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              TextButton(child: Text('예',
                                style: TextStyle(color: themeColor.getMaterialColor())),
                                  onPressed: () {
                                  Provider.of<UserProvider>(context, listen:false) //로그아웃
                                    .uid = 0;

                                  Provider.of<UserProvider>(context, listen:false) //Provider에게 값이 바뀌었다고 알려줌 -> 화면 재로딩
                                    .getData();
                                  Navigator.pop(context);
                              })
                                
                            ],
                          ),
                    );

                     
                  }
              ),
            ),
          ],
        )
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          '초대 대기목록',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          width: 37, height: 37,
                          child: CircleAvatar(
                            backgroundColor: Color(0xffF3959D),
                            child: Text(
                              '$_count',
                              style: TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ),
                        IconButton(onPressed: () {
                          getResidentList(uid);
                        }, icon: Icon(Icons.restart_alt))
                        
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children:[
                          for (var i=0; i< _residentList.length; i++)... [
                            addList(_residentList[i]['id'], _residentList[i]['facility_id'], _residentList[i]['name'], _residentList[i]['facility_name'], _residentList[i]['userRole'],_residentList[i]['date'])
                          ]
                        ],
                      )
                    ),
                  ],
                )
                
            ),
          ],
        )
      ),
    );
  }


  Card addList(int id, int facilityId, String name, String facility_name, String userRole, String date){
    String userRoleString = '';

    if (userRole == 'PROTECTOR')
      userRoleString = '보호자';
    else if (userRole == 'MANAGER')
      userRoleString = '매니저';
    else if (userRole == 'WORKER')
      userRoleString = '요양보호사';
    else
      userRoleString = '누구세요';

    return Card(
        child: Container(
          padding: EdgeInsets.only(right: 7, left: 7),
          child: Row(
            children: [
              Text(
                facility_name + ": " + userRoleString
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(2),
                child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: themeColor.getColor(),)
                      ),
                      onPressed: (){
                        pageAnimation(context, ResidentInfoInputPage(invitationId: id, invitationUserRole: userRole, 
                                    invitationFacilityId: facilityId, invitationFacilityName : facility_name,
                                    userId: userProvider.uid));
                      },
                      child: Text('초대받기',style: TextStyle(color: themeColor.getColor(),),)
                    );
                  }
                ),
              )
                
            ],
          ),
        )
    );
  }
}