import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_data/VisitRequest/SelectedTimePage.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'SelectedDatePage.dart';

ThemeColor themeColor = ThemeColor();

class UserRequestPage extends StatefulWidget {
  const UserRequestPage({Key? key}) : super(key: key);

  @override
  State<UserRequestPage> createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {

  late final TextEditingController bodyController = TextEditingController(text: '면회 신청합니다.');
  String selectedHour = '방문 시간 선택';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('면회 목록')),
      body: Text('d'),
      floatingActionButton: writeButton(),
    );
  }



  //글쓰기 버튼
  Widget writeButton(){
    return FloatingActionButton(
      focusColor: Colors.white54,
      backgroundColor: themeColor.getColor(),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () { pageAnimation(context, writePage()); },
      child: Icon(Icons.create_rounded, color: Colors.white),
    );
  }

  //글쓰기 화면
  Widget writePage() {
    return customPage(
      title: '면회 신청',
      onPressed: () {
        String bodyTemp = bodyController.text.replaceAll(' ', '');
        if(bodyTemp.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('할 말 내용을 입력해주세요.')));
          return;
        }

        //TODO: ------------------------ 면회신청 완료 누르면 실행되어야 할 부분
        Navigator.pop(context);


        //TODO: ------------------------
        bodyController.text = '면회 신청합니다.'; //TextFormField 처음으로 초기화

      },
      body: ListView(
        children: [

          //TODO: 날짜, 할말(메모) 만들기
          text('날짜'),
          SelectedDatePage(),
          text('방문 시간'),
          SelectedTimePage(),
          text('할 말'),
          textFormField(),


        ],
      ),
      buttonName: '접수',
    );
  }

  //글자 출력
  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 6),
      child: Text('$text'),
    );
  }

  //달력 선택


  //면회 시간 선택
  Widget selectedClock() {
    return display(
        title: selectedHour,
        onTap: () {

          print('방문 시간 선택 Tap');

        }
    );
  }

  //할 말
  Widget textFormField() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SizedBox(
          height: 200,
          child: TextFormField(
            controller: bodyController,
            maxLines: 100,
            inputFormatters: [LengthLimitingTextInputFormatter(500)], //최대 500글자까지 작성 가능
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.black54),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              filled: true,
              fillColor: Color(0xfff2f3f6),
              //fillColor: Colors.greenAccent,
            ),
          ),
        )
    );
  }



  //날짜, 시간 선택 틀
  Widget display({
    required String title,
    required VoidCallback onTap,
}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$title', textScaleFactor: 1.2),
                Icon(Icons.expand_more_rounded, color: Colors.black54),
              ],
            ),
          )
      ),
    );
  }

}

