import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Supplementary/ThemeColor.dart';
import '../provider/ResidentProvider.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

//초대하기 화면

ThemeColor themeColor = ThemeColor();

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}
enum Answer {PROTECTOR, WORKER}

class _InvitePageState extends State<InvitePage> {
  final _contentEditController = TextEditingController();

  String result = 'PROTECTOR';
  bool isprotect = true;
  bool isemployee = false;
  late List<bool> isSelected;
  List<Map<String, dynamic>> _phoneNumUsers = [];
  late String _phone_num;

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
  Future<void> addInvite(phone_userId, facilityId, userRole) async {
    var url = Uri.parse(backendUrl + 'invitations');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": phone_userId,
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
    return Consumer<ResidentProvider> (
        builder: (context, residentProvider, child){
          return customPage(
            title: '초대하기',
            onPressed: () async {
              
              if(this.formKey.currentState!.validate()) {
                this.formKey.currentState!.save();

                if(_phoneNumUsers.length != 0){

                  //전화번호 리스트 출력
                  showDialog(
                      context: context,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("초대할 사람을 선택해주세요"),
                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                          actions: [
                            TextButton(
                              child: Text('다시 작성하기',style: TextStyle(color: themeColor.getColor(),),),
                              onPressed: () {
                                _phoneNumUsers = [];
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          content: Container(
                            height: 500,
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _phoneNumUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    ListTile(
                                        title: Text(_phoneNumUsers[index]['user_name']),
                                        onTap: () async {
                                          await addInvite(_phoneNumUsers[index]['user_id'], residentProvider.facility_id, result);
                                          Navigator.of(context, rootNavigator: true).pop();
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text("초대하기를 완료하였습니다."),
                                                  insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                          );

                                        })
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }
                  );
                }

                try {
                  await getUserByPhoneNum(_phone_num);
                  setState(() {});
                  if(_phoneNumUsers.length == 0){
                    return showDialog(
                        context: context,
                        barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("회원가입을 하지 않은 전화번호입니다. \n다시 확인해주세요."),
                            insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                            actions: [
                              TextButton(
                                child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                    );
                  }
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
                              child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: themeColor.getColor(),
                        selectedColor: Colors.white,
                        fillColor: themeColor.getColor(),
                        color: themeColor.getColor(),
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
                            controller: _contentEditController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자만 가능
                              LengthLimitingTextInputFormatter(11) //11자리만 입력(숫자 11)
                            ],

                            validator: (value) {
                              if(value!.isEmpty) { return '전화번호를 입력해주세요'; }
                              if(value.length!=11){ return '전화번호를 알맞게 입력해주세요';}
                              else { return null; }
                            },
                            onSaved: (value){
                              _phone_num = value!;
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
      result = 'PROTECTOR';
    } else {
      isprotect = false;
      isemployee = true;
      result = 'WORKER';
    }
    setState(() {
      isSelected = [isprotect, isemployee];
    });
  }
}