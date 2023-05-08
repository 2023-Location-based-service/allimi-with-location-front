import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ResidentProvider.dart';
import '/Invite/InvitePage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

//초대목록화면

class InviteListPage extends StatefulWidget {
  const InviteListPage({Key? key}) : super(key: key);

  @override
  State<InviteListPage> createState() => _InviteListPageState();
}

class _InviteListPageState extends State<InviteListPage> {
  static List<Map<String, dynamic>> _inviteDatalist = [];
  late int _inviteId;

  Future<void> getInvitation(int facilityId) async {
    http.Response response = await http.get(
        Uri.parse(backendUrl + "invitations/" + facilityId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _inviteDatalist =  parsedJson;
    });
  }

  Future<void> deleteInvitation(int invitId) async {
    http.Response response = await http.delete(
        Uri.parse(backendUrl+ 'invitations'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "invit_id": invitId
        })
    );

    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(response.statusCode);
    if (response.statusCode == 200){
      setState(() {
        _inviteDatalist.removeWhere((invite) => invite['invit_id'] == invitId);
      });
    } else {
      throw Exception('Failed to delete invitation');
    }
  }

  @override
  void initState() {
    super.initState();
    final residentProvider = context.read<ResidentProvider>();
    getInvitation(residentProvider.facility_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: inviteButton(),
      appBar: AppBar(title: Text('초대 목록')),
      body: ListView(
        children: [
          appInviteList(),
        ],
      )
    );
  }
  //전체 구성
  Widget appInviteList(){
    return Container(
      padding: EdgeInsets.only(left: 5, top: 10,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _inviteDatalist.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.person_rounded, color: Colors.grey),
                title: Row(
                  children: [
                    if(_inviteDatalist[index]['userRole'] == 'PROTECTOR')
                      Text('보호자 '),
                    if(_inviteDatalist[index]['userRole'] == 'WORKER')
                      Text('직원 '),
                    Text(_inviteDatalist[index]['name']), //초대 리스트
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(2),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: themeColor.getColor(),)
                          ),
                          onPressed: () async {
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
                                            await deleteInvitation(_inviteDatalist[index]['id']);
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
                          child: Text('취소하기',style: TextStyle(color: themeColor.getColor(),),)
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 80,)
        ],
      ),
    );
  }

  //초대하기 버튼
  Widget inviteButton(){
    return FloatingActionButton(
      focusColor: Colors.white54,
      backgroundColor: themeColor.getColor(),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () { pageAnimation(context, InvitePage()); },
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}