import 'package:flutter/material.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'MainPage.dart';

import 'domain/UserInfo.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; //http 사용
import 'dart:convert';

Future<String> postUserRequest(String id, String password) async {
  // http.Response response = await http.post(
  //   Uri.parse('주소'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //   },
  //   body: jsonEncode({
  //     "id": id,
  //     "password": password,
  //   }),
  //
  // );
  //return response.body; //반환받은 데이터(user_id, userRole) 반환

  //더미 데이터
  String response = jsonEncode({
    'user_id': 1,
    'userRole': 'PROTECTER',
    'id': 'asdf1234',
    'tel':'0100000000',
    'user_name': '권태연'
  });
  return response;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _id = '';
  String _password= '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $_id, password: $_password');
    } else {
      print('Form is invalid ID: $_id, password: $_password');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('로그인 화면'),
      // ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '아이디'),
                validator: (value) =>
                value!.isEmpty ? '아이디를 입력해주세요.' : null,
                onSaved: (value) => _id = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
                validator: (value) =>
                value!.isEmpty ? '비밀번호를 입력해주세요.' : null,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20.0,),
              ElevatedButton (
                  child: Text(
                    '로그인',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),

                  onPressed: () async {
                    if(validateAndSave() == true){
                      //프론트->백엔드
                      var data = await postUserRequest(_id, _password);
                      var json_data = json.decode(data);

                      Provider.of<UserProvider>(context, listen:false)
                          .setInfo(json_data['user_id'], json_data['userRole'], json_data['id'], json_data['tel'], json_data['user_name']);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MainPage()),
                      // );
                    }

                  }
              ),
              SizedBox(height: 10.0,),
              OutlinedButton (
                child: Text(
                  '회원가입',
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}