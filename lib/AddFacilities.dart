import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart'; //http 사용

import 'package:test_data/Backend.dart';
String backendUrl = Backend.getUrl();

class AddFacilities extends StatefulWidget {
  const AddFacilities({Key? key}) : super(key: key);

  @override
  State<AddFacilities> createState() => _AddFacilitiesState();
}

class _AddFacilitiesState extends State<AddFacilities> {
  final formKey = GlobalKey<FormState>();
  TextEditingController facilityNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController personNameController = TextEditingController();

  String _facilityName = '';
  String _location = '';
  String _number = '';
  String _personName = '';
  int _facilityId = 0;
  int _resident_id = 0;

  Future<void> facilityRequest(int uid) async {
    debugPrint("@@@@ 시설 추가하는 백엔드 url보냄: " + _personName);
    //입소자추가 psot
    http.Response response1 = await http.post(
      Uri.parse(backendUrl+ 'facilities'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "name": _facilityName,
        "address": _location,
        "tel": _number,
      })
    );

    debugPrint("@@@@ statusCode: " + response1.statusCode.toString());

    if (response1.statusCode != 200) {
        throw Exception('POST request failed');
    }

    var data =  utf8.decode(response1.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);
    _facilityId = parsedJson['facility_id'];

    debugPrint("@@@@ 시설장 resident 추가하는 백엔드 url보냄");

    http.Response response2 = await http.post(
      Uri.parse(backendUrl+ 'nhResidents'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "user_id": uid,
        "facility_id": _facilityId,
        "resident_name": '',
        "birth": '',
        "user_role": 'MANAGER',
        "health_info": ''
      })
    );

    if (response2.statusCode != 200) {
        throw Exception('POST');
    }

    data =  utf8.decode(response2.bodyBytes);
    decodedJson = json.decode(data);
    parsedJson = Map<String, dynamic>.from(decodedJson);
    _resident_id = parsedJson['resident_id'];
  }


  @override
  Widget build(BuildContext context) {
    return addFacilities();
  }

  Widget addFacilities() {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Text('시설 정보를 입력해주세요.'),
            Form(
              key: formKey,
              child: Column(
                children: [
                  getTextFormField(
                    textInputType: TextInputType.text,
                    icon: Icons.home_rounded,
                    hintText: '시설명',
                    controller: facilityNameController,
                    errormsg: '시설명을 입력하세요'),
                  getTextFormField(
                    textInputType: TextInputType.text,
                    icon: Icons.place_rounded,
                    hintText: '주소',
                    controller: locationController,
                    errormsg: '주소를 입력하세요'),

                  getTextFormField(
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')
                    ],
                    icon: Icons.call_rounded,
                    hintText: '전화번호',
                    controller: numberController,
                    errormsg: '전화번호를 입력하세요'),
                  getTextFormField(
                    textInputType: TextInputType.text,
                    icon: Icons.person_rounded,
                    hintText: '시설장 이름',
                    controller: personNameController,
                    errormsg: '시설장 이름을 입력하세요'),
                ],
              )
            ),


            OutlinedButton(
              child: Text('확인'),
              onPressed: (){
                if(this.formKey.currentState!.validate()) {
                  this.formKey.currentState!.save();

                  showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context1) {
                      return AlertDialog(
                        content: Text("요양원을 등록하시겠습니까?"),
                        insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                        actions: [
                          Consumer<UserProvider>(
                            builder: (context2, userProvider, child) {
                              return TextButton(
                                child: const Text('확인'),
                                onPressed: () async {
                                  try {
                                    await facilityRequest(userProvider.uid);

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context3) {
                                        return AlertDialog(
                                          content: Text('요양원 등록에 성공하였습니다'),
                                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop(); 
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    );

                                    Provider.of<ResidentProvider>(context, listen:false)
                                                  .setInfo(_resident_id, _facilityId, _facilityName, '', 'MANAGER','', '');
                                    
                                    Provider.of<UserProvider>(context, listen: false)
                                                  .setRole('MANAGER');

                                    Provider.of<UserProvider>(context, listen: false)
                                                  .getData();
                                  
                                  } catch(e) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context_) {
                                        return AlertDialog(
                                          content: Text('시설 등록에 실패하였습니다'),
                                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                Navigator.of(context_).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }

                                  // Navigator.of(context).pop();
                                },
                              );
                            }
                          ),
                          TextButton(
                            child: const Text('취소'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );

                }
              },
            ),
          ],
        )
      ),
    );
  }

  Widget getTextFormField({
    TextInputType? textInputType,
    required IconData? icon,
    required String? hintText,
    required TextEditingController controller,
    required String? errormsg,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if(value!.isEmpty) { return errormsg; } else { return null; }
      },
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.black54),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        filled: true,
        fillColor: Color(0xfff2f3f6),
      ),
      onSaved: (value) {
        if (hintText == '시설명') {
          _facilityName = value!;
        } else if (hintText == '주소') {
          _location = value!;
        } else if (hintText == '전화번호') {
          _location = value!;
        } else if (hintText == '시설장 이름') {
          _personName = value!;
        } 
      }
    );
  }
}