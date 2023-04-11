import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

class UserRequestPage extends StatefulWidget {
  const UserRequestPage({Key? key}) : super(key: key);

  @override
  State<UserRequestPage> createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('면회 목록')),
      body: writePage(),
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

          //TODO: 날짜, 시간, 할말
          text('날짜'),
          text('시간'),
          text('메모'),


        ],
      ),
      buttonName: '접수',
    );
  }


  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 6),
      child: Text('$text'),
    );
  }

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

}



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