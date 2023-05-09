import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/ResidentProvider.dart';
import '../provider/UserProvider.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

//초대하기 화면

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}
enum Answer {PROTECTOR, WORKER}

class _InvitePageState extends State<InvitePage> {
  String result = '';
  bool isprotect = true;
  bool isemployee = false;
  late List<bool> isSelected;
  List<Map<String, dynamic>> _phoneNumUsers = [];

  @override
  void initState() {
    isSelected = [isprotect, isemployee];
    super.initState();
  }
  final formKey = GlobalKey<FormState>();

  // 전화번호 받아오기
  Future<void> getUserByPhoneNum(String phoneNum) async {
    debugPrint("@@@@@ 전화번호로 user목록 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl + "users/phone-num/" + phoneNum),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _phoneNumUsers =  parsedJson;
    });
  }

  // 서버에 초대하기 업로드
  Future<void> addComment(userId, facilityId, userRole) async {
    var url = Uri.parse(backendUrl + 'invitations');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": userId,
      "facility_id": facilityId,
      "user_role": userRole,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ResidentProvider> (
        builder: (context, userProvider, residentProvider, child){
          return customPage(
            title: '초대하기',
            onPressed: () async {
              
              if(this.formKey.currentState!.validate()) {
                this.formKey.currentState!.save();


                //전화번호 리스트 출력@@@TODO

                try {
                  await addComment(userProvider.uid, residentProvider.facility_id, userProvider.urole);
                  setState(() {});
                  Navigator.pop(context);
                } catch(e) {
                  showDialog(
                      context: context,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("초대 실패! 다시 시도해주세요"),
                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                          actions: [
                            TextButton(
                              child: const Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                  );
                }
              }},
            body: inviteFormat(),
            buttonName: '확인',
          );
        }
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
                //color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: const Text('초대하실 유형을 선택해주세요', textScaleFactor: 1.1,),
                  subtitle: Column(
                    children: [
                      SizedBox(height: 25,),
                      ToggleButtons(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
                              child: Text('보호자', style: TextStyle(fontSize: 18))),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
                              child: Text('직원', style: TextStyle(fontSize: 18))),
                        ],
                        isSelected: isSelected,
                        onPressed: toggleSelect,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  //color: Colors.white,
                  padding: EdgeInsets.only(left: 18,top: 12, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                              if(value!.isEmpty||value.length!=13) { return '번호를 입력해주세요'; }
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
  void toggleSelect(value) {
    if (value == 0) {
      isprotect = true;
      isemployee = false;
    } else {
      isprotect = false;
      isemployee = true;
    }
    setState(() {
      isSelected = [isprotect, isemployee];
    });
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
          buffer.write('-');
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
