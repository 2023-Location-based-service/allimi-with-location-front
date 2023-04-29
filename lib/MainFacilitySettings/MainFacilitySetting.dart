import 'package:flutter/material.dart';
import '/MainFacilitySettings/FacilityBasicInfoSettingPage.dart';
import '/Invite/InviteListPage.dart';
import 'PeopleManagementPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'UserPeopleManagementPage.dart';

class MainFacilitySettingsPage extends StatefulWidget {
  const MainFacilitySettingsPage({Key? key}) : super(key: key);

  @override
  State<MainFacilitySettingsPage> createState() => _MainFacilitySettingsPageState();
}

class _MainFacilitySettingsPageState extends State<MainFacilitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('시설 설정')),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                color: Color(0xfff8f8f8),
                padding: EdgeInsets.only(left: 13, top: 13, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.room,
                      color: Colors.black,
                    ),
                    Text(
                      "구미요양원",
                      style: TextStyle(fontSize: 12.0),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8,),
              appResidentManagement(),
              Divider(thickness: 0.5,),
              appEmployeeManagement(),
              Divider(thickness: 0.5,),
              appInvite(),
              Divider(thickness: 0.5,),
              appFacilityBasicSetting(),
              Divider(thickness: 0.5,),
            ],
          )
        ],
      ),
    );
  }

  Widget appResidentManagement() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -3),
        title: Text('입소자 관리'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, userPeopleManagementPage());
        });
  }

  Widget appEmployeeManagement() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('직원 관리'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, PeopleManagementPage());
        });
  }

  Widget appInvite() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('초대하기'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, InviteListPage());
        });
  }

  Widget appFacilityBasicSetting() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('시설 기본 정보 설정'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, FacilityBasicInfoPage());
        });
  }

}