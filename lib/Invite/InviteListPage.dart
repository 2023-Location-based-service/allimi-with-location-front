import 'package:flutter/material.dart';
import '/Invite/InvitePage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

//초대목록화면

class InviteListPage extends StatefulWidget {
  const InviteListPage({Key? key}) : super(key: key);

  @override
  State<InviteListPage> createState() => _InviteListPageState();
}

class _InviteListPageState extends State<InviteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: inviteButton(),
      
      //아래에 초대하기 버튼을 넣었을 때
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.all(10),
      //   child: ElevatedButton (
      //       child: Text(
      //         '초대하기',
      //         style: TextStyle(fontSize: 18.0),
      //       ),
      //       style: ElevatedButton.styleFrom(
      //         padding: EdgeInsets.all(7),
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10)
      //         ),
      //       ),
      //       onPressed: (){
      //         pageAnimation(context, InvitePage());
      //       }
      //   ),
      // ),
      appBar: AppBar(title: Text('시설 설정')),
      body: appInviteList(),
    );
  }

  //전체 구성
  Widget appInviteList(){
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 18,top: 12),
              child: Text(
                '초대 목록',
                style: TextStyle(
                    fontSize: 18
                ),
              ),
            ),
            inviteList(),

          ],
        )
      ],
    );
  }

  //이름 나오는 부분
  Widget inviteList(){
    return Column(
      children: [
        invitePeople(),
        invitePeople(),
        invitePeople(),
        invitePeople(),
        invitePeople(),
        invitePeople(),
        invitePeople(),
        invitePeople(),
        invitePeople(),
        invitePeople(),
        //아직 색이 안 바뀜
        Container(
          color: Colors.white,
          child: SizedBox(
            height: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  //사람 한명
  Widget invitePeople(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, top: 10, right: 10),
      child: Row(
        children: [
          Icon(Icons.person_rounded, color: Colors.grey),
          SizedBox(width: 20,),
          Text(
            '보호자 홍길동',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(3),
            child: OutlinedButton(
                onPressed: (){
                  //취소
                },
                child: Text('취소하기')
            ),
          ),
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