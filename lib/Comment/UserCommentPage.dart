import 'dart:convert';

import 'package:flutter/material.dart';
import '../Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'WriteCommentPage.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

ThemeColor themeColor = ThemeColor();

class UserCommentPage extends StatefulWidget {

  const UserCommentPage({
    Key? key,
    required this.userRole,
    required this.residentId
  }) : super(key: key);

  final String userRole;
  final int residentId;

  @override
  State<UserCommentPage> createState() => _UserCommentPageState();
}

class _UserCommentPageState extends State<UserCommentPage> {
  late int _letterId;
  String _userRole = '';
  int _residentId = 0;
  List<Map<String, dynamic>> _CommentList = [];

  Future<void> getComment(int residentId) async {
    http.Response response = await http.get(
        Uri.parse(backendUrl + "letters/" + residentId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _CommentList =  parsedJson;
    });
  }

  @override
  void initState() {
    _userRole = widget.userRole;
    _residentId = widget.residentId;
    getComment(_residentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(title: Text('한마디')),
      body: userCommentList(),
      floatingActionButton: _getFAB()
    );
  }

  Widget _getFAB() {
    if (_userRole == 'PROTECTOR')
      return FloatingActionButton(
        backgroundColor: themeColor.getColor(),
        onPressed: () {
          //글쓰기 화면으로 이동
          pageAnimation(context, WriteCommentPage());

        },
        child: const Icon(Icons.create),
      );
    else
      return Container();
  }

  Future<void> deleteComment(int letterid) async {
    http.Response response = await http.delete(
        Uri.parse(backendUrl+ 'letters'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "letter_id": letterid
        })
    );

    if (response.statusCode == 200){
      setState(() {
        _CommentList.removeWhere((comment) => comment['letter_id'] == letterid);
      });
    } else {
      throw Exception('Failed to delete comment');
    }
  }

  // 보호자 한마디 목록
  Widget userCommentList(){
    return ListView(
      children: [
         ListView.separated(
            itemCount: _CommentList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                height: 130,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_userRole != 'PROTECTOR')
                      Container(
                        child: Text(_CommentList[index]['nhr_name'] + " 보호자님", textScaleFactor: 1.0,),
                      ),
                      Row(
                      children: [
                        Text(_CommentList[index]['create_date'].toString().substring(0, 10).replaceAll('-', '.'), textScaleFactor: 1.0,),
                        Spacer(),
                        if (_userRole == 'PROTECTOR')
                          Container(
                            padding: EdgeInsets.all(4),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: themeColor.getColor(),)
                                ),
                                onPressed: () async {
                                  _letterId = _CommentList[index]['letter_id'];
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text("정말 삭제하시겠습니까?"),
                                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                          actions: [
                                            TextButton(
                                              child: Text('취소',style: TextStyle(color: themeColor.getColor(),),),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('삭제',style: TextStyle(color: themeColor.getColor(),),),
                                              onPressed: () async {
                                                try {
                                                  await deleteComment(_letterId);
                                                } catch(e) {
                                                }
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Text('삭제',style: TextStyle(color: themeColor.getColor(),),)
                            ),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (_userRole != 'PROTECTOR')
                          SizedBox(height: 10,),
                        Text(
                          _CommentList[index]['content'],
                          textScaleFactor: 1.1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )

                  ],
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) => const Divider(height: 9, color: Color(0xfff8f8f8),),  //구분선(height로 상자 사이 간격을 조절)
          ),
      ],
    );
  }
}