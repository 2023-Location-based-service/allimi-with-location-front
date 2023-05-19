import 'package:flutter/material.dart';
import 'package:test_data/Invite/InvitePage.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import '../Supplementary/ThemeColor.dart';
import '/MainFacilitySettings/FacilityBasicInfoSettingPage.dart';
import '/Invite/InviteListPage.dart';
import 'PeopleManagementPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'UserPeopleManagementPage.dart';

ThemeColor themeColor = ThemeColor();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              groupText('직원 및 입소자 관리'),
              appEmployeeManagement(),
              appResidentManagement(),
              SizedBox(height: 15,),
              groupText('초대'),
              appInvite(),
              appInviteList(),
              groupText('시설'),
              appFacilityBasicSetting(),
            ],
          )
        ],
      ),
    );
  }

  Widget groupText(String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20,10,20,10),
      child: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: themeColor.getColor()
        ),
      ),
    );
  }

  Widget appResidentManagement() {
    return ListTile(
        title: Text('입소자 관리'),
        leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, userPeopleManagementPage());
        });
  }

  Widget appEmployeeManagement() {
    return ListTile(
        title: Text('직원 관리'),
        leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, PeopleManagementPage());
        });
  }

  Widget appInvite() {
    return ListTile(
        title: Text('초대하기'),
        leading: Icon(Icons.send_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, InvitePage());
        });
  }

  Widget appInviteList() {
    return ListTile(
        title: Text('초대목록'),
        leading: Icon(Icons.favorite_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, InviteListPage());
        });
  }

  Widget appFacilityBasicSetting() {
    return Consumer<ResidentProvider>(
      builder: (context, residentProvider, child) {
        return ListTile(
          title: Text('시설 기본 정보 설정'),
          leading: Icon(Icons.home_rounded, color: Colors.grey),
          onTap: () {
            pageAnimation(context, FacilityBasicInfoPage(facilityId: residentProvider.facility_id));
          });
      }
    );
  }
}