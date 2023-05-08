import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/UserProvider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return myProfile();
  }

  String _getRoleText(String urole) {
    switch (urole) {
      case 'PROTECTOR':
        return '보호자';
      case 'WORKER':
        return '요양보호사';
      case 'MANAGER':
        return '시설장';
      case 'ADMIN':
        return '관리자';
      default:
        return urole;
    }
  }

  Widget myProfile() {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('내 정보')),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Text('아이디'),
          myProfileBox(userProvider.loginid),
          Text('역할'),
          myProfileBox(_getRoleText(userProvider.urole)),
          Text('이름'),
          myProfileBox(userProvider.name),
          Text('전화번호'),
          myProfileBox(userProvider.phone_num),
        ],
      ),
    );
  }

  Widget myProfileBox(String text) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('$text', textScaleFactor: 1.2),
              ],
            )));
  }
}
