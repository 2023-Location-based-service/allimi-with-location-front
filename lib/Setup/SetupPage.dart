import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Setup/MyInmateProfilePage.dart';
import 'package:test_data/Setup/MyProfilePage.dart';
import 'package:test_data/provider/UserProvider.dart';
import '../AddFacilities.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:test_data/provider/UserProvider.dart';

ThemeColor themeColor = ThemeColor();

List<String> personList = ['구현진', '권태연', '정혜지', '주효림'];


class SetupPage extends StatefulWidget {
  const SetupPage({Key? key, required this.userRole}) : super(key: key);

  final String userRole;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  late String _userRole;

  @override
  void initState() {
    super.initState();
    _userRole = widget.userRole;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [
          appProfile(),
          appInmateProfile(),
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




