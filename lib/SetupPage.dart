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
          appTest(),

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
        });
  }

  Widget appNotification() {
    return ListTile(
        title: Text('알림 설정'),
        leading: Icon(Icons.notifications_active_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myNotification());
        });
  }

  Widget appLogout() {
    return ListTile(
        title: Text('로그아웃'),
        leading: Icon(Icons.logout_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myLogout());
        });
  }

  Widget appTest() {
    return ListTile(
        title: Text('알림장 글쓰기'),
        leading: Icon(Icons.logout_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, writePost());
        });
  }






  //수급자 선택 페이지
  Widget myTest2() {
    return Container();
  }

  //알림장 글쓰기
  Widget writePost() {
    return Scaffold(
      appBar: AppBar(title: Text('알림장 작성하기'), elevation: 0.0, actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 50,
            height: 10,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.getMaterialColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text('완료', style: TextStyle(color: themeColor.getColor())),
              onPressed: () { /*  TODO: 글 쓰기 완료버튼 누르면 실행되어야 할 부분 */ },
            ),
          ),
        ),
      ],),

      body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: [

                  TextButton(onPressed: () {}, child: Row(
                    children: [
                      Icon(Icons.person_rounded, color: Colors.grey, size: 25),
                      Text('수급자 선택하기'),
                    ],
                  ),),


                  Divider(thickness: 0.5),
                  SizedBox(
                    width: double.infinity,
                    height: 430,
                    child: TextFormField(
                      cursorColor: themeColor.getMaterialColor(),
                      maxLines: 100,
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10,10,10,0),
                    child: Container(
                      height: 220, //210 이상으로만 설정하기 (글자 출력되는 부분 크기)
                      child: Text(
                        '자취 백과사전은 깨끗한 커뮤니티를 만들기 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다. '
                            '위반 시 게시물이 삭제되고 서비스 이용이 제한되오니 반드시 숙지하시길 바랍니다.\n\n',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 0.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),

      bottomSheet: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: Icon(Icons.camera_alt_outlined, color: Colors.black), // 좌측 하단 카메라 버튼
                  onPressed: () { /* 카메라 버튼 누르면 앨범으로 이동 */ },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

}
