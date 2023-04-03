import 'package:flutter/material.dart';
import 'Supplementary/ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('설정', textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [

          //TODO: 위젯 작성
          appProfile(),
          appNotification(),
          Divider(thickness: 7, color: Colors.grey[100]),
          appLogout(),

        ],
      ),
    );
  }



  Widget appProfile() {
    return ListTile(
        title: Text('내 정보'),
        leading: Icon(Icons.person_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myProfile());
          // PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myProfile());
          // Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        });
  }

  Widget appNotification() {
    return ListTile(
        title: Text('알림 설정'),
        leading: Icon(Icons.notifications_active_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myNotification());
          // PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myNotification());
          // Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        });
  }

  Widget appLogout() {
    return ListTile(
        title: Text('로그아웃'),
        leading: Icon(Icons.logout_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myLogout());
          // PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myLogout());
          // Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        });
  }






  Widget myProfile() {
    return Scaffold(body: Text('테스트'));
  }

  Widget myNotification() {
    return Scaffold(body: Text('테스트'));
  }

  Widget myLogout() {
    return Scaffold(body: Text('테스트'));
  }

  // void pageAnimation(BuildContext context, Widget page) {
  //   PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(page);
  //   Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
  // }


}
