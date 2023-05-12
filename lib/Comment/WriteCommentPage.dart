import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import '/Supplementary/ThemeColor.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

ThemeColor themeColor = ThemeColor();

class WriteCommentPage extends StatefulWidget {
  const WriteCommentPage({Key? key}) : super(key: key);


  @override
  State<WriteCommentPage> createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteCommentPage> {
  final formKey = GlobalKey<FormState>();
  String _contents = '';

  // 서버에 한마디 업로드
  Future<void> addComment(userId, nhresidentid, facilityId) async {
    var url = Uri.parse(backendUrl + 'letters');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": userId,
      "nhresident_id": nhresidentid,
      "facility_id": facilityId,
      "contents": _contents,
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
            title: '한마디 작성',
            onPressed: () async {
              print('한마디');
              if(this.formKey.currentState!.validate()) {
                this.formKey.currentState!.save();
                try {
                  await addComment(userProvider.uid, residentProvider.resident_id, residentProvider.facility_id);
                  Navigator.pop(context);
                } catch(e) {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("한마디 업로드 실패! 다시 시도해주세요"),
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
            body: commentWrite(),
            buttonName: '완료',
          );
        }
    );
  }

  Widget commentWrite(){
    String currentDate = DateTime.now().toString().substring(0, 10).replaceAll('-', '.');
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('날짜'),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xfff2f3f6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(currentDate, textScaleFactor: 1.3),
              ),
              SizedBox(height: 15,),
              Text('한마디 작성'),
              SizedBox(height: 5,),
              createField()
            ],
          ),
        ),
      ],
    );
  }
  Widget createField() {
    return Form(
      key: formKey,
      child: SizedBox(
        child: TextFormField(
          validator: (value) {
            if(value!.isEmpty) { return '내용을 입력하세요'; }
            else { return null; }
          },
          maxLines: 10,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xfff2f3f6),
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
          onSaved: (value) {
            _contents = value!;
          }
        ),
      ),
    );
  }
}
