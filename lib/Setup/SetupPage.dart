import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Invite/InvitationListPage.dart';
import 'package:test_data/Invite/InviteListPage.dart';
import 'package:test_data/Invite/InviteWaitPage.dart';
import 'package:test_data/Setup/MyInmateProfilePage.dart';
import 'package:test_data/Setup/MyProfilePage.dart';
import 'package:test_data/provider/UserProvider.dart';
import '../AddFacilities.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'package:http/http.dart' as http;

import 'package:test_data/Backend.dart';
String backendUrl = Backend.getUrl();

ThemeColor themeColor = ThemeColor();

List<String> personList = ['구현진', '권태연', '정혜지', '주효림'];


class SetupPage extends StatefulWidget {
  const SetupPage({Key? key, required this.userRole, required this.userId}) : super(key: key);

  final String userRole;
  final int userId;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  late String _userRole;
  late int _userId;
  int _count = 0;

  Future<void> getResidentList() async {
    debugPrint("@@@@@ 입소자 정보 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl + "users/invitations/" + _userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      this._count = parsedJson.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _userRole = widget.userRole;
    _userId = widget.userId;
    getResidentList();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("@@@@userRole: " + _userRole);
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [
          appProfile(),
          appInmateProfile(),
          if (_userRole != 'MANAGER')
            appInvitation(),
          appLogout()
        ],
      ),
    );
  }

  Widget appProfile() {
    return ListTile(
        title: Text('내 정보'),
        leading: Icon(Icons.person_rounded, color: Colors.grey),
        onTap: () { pageAnimation(context, MyProfilePage()); });
  }

  Widget appInmateProfile() {
    return Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return ListTile(
              title: Text('입소자 정보'),
              leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
              onTap: () { pageAnimation(context, MyInmateProfilePage(uid: userProvider.uid,)); });
        }
    );
  }

  Widget appInvitation() {
      return ListTile(
          title: Text('초대받기'),
          leading: Icon(Icons.person_rounded, color: Colors.grey),
          onTap: () { pageAnimation(context, InvitationListPage(uid:_userId)); },
          trailing: inviteCount()
      );
  }

  Widget inviteCount() {
    if (_count > 0) {
      return Container(
          padding: EdgeInsets.all(5),
          width: 37, height: 37,
          child: CircleAvatar(
            backgroundColor: Color(0xffF3959D),
            child: Text(
              '$_count',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        );
    } else {
      return Text('');
    }
    
  }

  Widget appLogout() {
    return ListTile(
        title: Text('로그아웃'),
        leading: Icon(Icons.logout_rounded, color: Colors.grey),
        onTap: () {
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
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return TextButton(child: Text('예',
                        style: TextStyle(color: themeColor.getMaterialColor())),
                          onPressed: () {
                        userProvider.logout();
                            userProvider.getData();
                        Navigator.pop(context);
                      });
                    }
                  ),
                ],
              ),
          );
        });
  }
}




