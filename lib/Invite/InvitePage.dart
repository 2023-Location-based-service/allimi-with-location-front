import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

//초대하기 화면

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return customPage(
      title: '초대하기',
      onPressed: () {
        print('초대하기 누름');

        if(this.formKey.currentState!.validate()) {

          //TODO: 확인 버튼 누르면 실행되어야 하는 부분

          Navigator.pop(context);
        }},
      body: inviteFormat(),
      buttonName: '확인',
    );
  }
  Widget inviteFormat(){
    return ListView(
      children: [
        Column(
          children: [
            Container(
              color: Color(0xfff8f8f8),
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
                padding: EdgeInsets.only(left: 18,top: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '초대하실 유형을 선택하세요',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    SizedBox(height: 50,),
                    Text(
                      '휴대폰 번호',
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, //숫자만!
                        NumberFormatter(), // 자동하이픈
                        LengthLimitingTextInputFormatter(13) //13자리만 입력받도록 하이픈 2개+숫자 11개
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'PhoneNumber',
                        hintText: '010-123-4567 or 010-1234-5678'),
                      ),
                  ],
                )
            ),


          ],
        )
      ],
    );
  }
}
class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
