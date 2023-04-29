import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

//초대하기 화면

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}
enum Answer {protect, employee}

class _InvitePageState extends State<InvitePage> {

  Map<int, Answer?> answerVal = {};

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
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index){
        return Container(
          //color: Colors.white,
          child: Column(
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
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: const Text('초대하실 유형을 선택해주세요', textScaleFactor: 1.2,),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<Answer>(
                            title: const Text('보호자'),
                            value: Answer.protect,
                            groupValue: answerVal[index],
                            onChanged: (Answer? value){
                              setState(() {
                                answerVal[index] = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<Answer>(
                            title: const Text('직원'),
                            value: Answer.employee,
                            groupValue: answerVal[index],
                            onChanged: (Answer? value){
                              setState(() {
                                answerVal[index] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 18,top: 12, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Text('초대하실 유형을 선택하세요', textScaleFactor: 1.4,),
                      SizedBox(height: 10,),
                      Text('휴대폰 번호', textScaleFactor: 1.1,),
                      SizedBox(height: 5,),
                      Form(
                        key: formKey,
                        child: SizedBox(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자만 가능
                              NumberFormatter(), // 자동으로 하이픈
                              LengthLimitingTextInputFormatter(13) //13자리만 입력(하이픈 2+숫자 11)
                            ],
                            validator: (value) {
                              if(value!.isEmpty) { return '내용을 입력하세요'; }
                              else { return null; }
                            },
                            keyboardType: TextInputType.number, //키보드는 숫자
                            maxLines: 1,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xfff2f3f6),
                              //fillColor: Colors.white,
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
                              //focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60,),

                    ],
                  )
              ),
            ],
          ),
        );

      },
    );
  }
}
//자동 하이픈
class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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
