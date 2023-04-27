import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

List<String> hoursList = [];

class UserRequestPage extends StatefulWidget {
  const UserRequestPage({Key? key}) : super(key: key);

  @override
  State<UserRequestPage> createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {

  String selectedHour = '방문 시간 선택';

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i <= 23; i++) {
      String hour = i.toString().padLeft(2, '0');
      hoursList.add('$hour:00');
    }

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
      onPressed: () {},
      body: ListView(
        children: [
          text('예약자명'),
          textFormField(
            textInputType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(15)]
          ),
          text('핸드폰 번호'),
          textFormField(
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                PhoneNumberFormatter()
              ]),

          //TODO: 날짜, 할말(메모) 만들기
          text('날짜\n나중에 추가'),
          text('시간'),
          // ※ 요양원마다 면회 가능 시간이 상이하므로 경우에 따라 면회 거절될 수도 있습니다.
          selectedClock(),
          text('메모\n나중에 추가'),


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

  //텍스트 입력 위젯
  Widget textFormField({ //이름, 전번, 날짜, 시간, 할말
    required TextInputType textInputType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: SizedBox(
        child: TextFormField(
          keyboardType: textInputType,
          inputFormatters: inputFormatters, //선택 옵션
          textAlignVertical: TextAlignVertical.top,


          decoration: InputDecoration(
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
          ),
        ),
        height: 50,
      )
    );
  }

  //면회 시간 선택하는 위젯
  Widget selectedClock() {
    return GestureDetector(
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
              Text('$selectedHour', textScaleFactor: 1.2),  //TODO: 글자가 바뀌어야 함
              Icon(Icons.expand_more_rounded, color: Colors.black54),
            ],
          ),
        )
      ),
      onTap: () {
        print('시간 Tap');

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('방문 시간 선택'),
                content: Container(
                    child: ListView.builder(
                      itemCount: 24,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('${hoursList[index]}'), //TODO: 시간 리스트
                          onTap: () {
                            print('${hoursList[index]} Tap');

                            // TODO: 시간 선택 시 업데이트
                            setState(() {
                              if(selectedHour != null){ selectedHour = '${hoursList[index]}'; }
                              else { selectedHour = '방문 시간 선택'; }
                            });

                            Navigator.pop(context);

                          },
                        );
                      },
                    ),
                ),
                actions: [
                  TextButton(child: Text('취소',
                      style: TextStyle(color: themeColor.getMaterialColor())),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
        );

      },
    );
  }

}



// 핸드폰 번호 하이픈(-) 자동으로 추가
class PhoneNumberFormatter extends TextInputFormatter {
  //입력값 변경 로직
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    //숫자만 추출하고 하이픈을 추가한 새로운 문자열을 생성
    final number = newValue.text.replaceAllMapped(RegExp(r'(\d{3})(\d{4})(\d{4})'), (m) => '${m[1]}-${m[2]}-${m[3]}');
    //새로운 문자열로 TextEditingValue 객체를 생성하여 반환
    return TextEditingValue(
      text: number,
      selection: TextSelection.collapsed(offset: number.length),
    );
  }
}