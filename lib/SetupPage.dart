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
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [

          //TODO: 위젯 작성
          appProfile(),
          appNotification(),
          appLogout(),
        ],
      ),
    );
  }


  Widget appProfile() {
    return ListTile(
        title: Text('내 정보'),
        leading: Icon(Icons.person_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, myProfile());
        });
  }

  Widget appNotification() {
    return ListTile(
        title: Text('알림 설정'),
        leading: Icon(Icons.notifications_active_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, myNotification());
        });
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
                    TextButton(child: Text('예',
                      style: TextStyle(color: themeColor.getMaterialColor())),
                        onPressed: () {
                      Navigator.pop(context);
                      //TODO: 로그아웃 실행
                    }),
                  ],
                ),
          );
        });
  }


  Widget myProfile() {
    return Scaffold(body: Text('테스트22'));
  }

  Widget myNotification() {
    return Scaffold(body: Text('테스트'));
  }
}




