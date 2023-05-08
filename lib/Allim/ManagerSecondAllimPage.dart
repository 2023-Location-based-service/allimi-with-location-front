import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_data/Allim/EditAllimPage.dart';
import 'package:test_data/Supplementary/PageRouteWithAnimation.dart';
import 'package:test_data/provider/ResidentProvider.dart';

String backendUrl = "http://52.78.62.115:8080/v2/";

class ManagerSecondAllimPage extends StatefulWidget {
  const ManagerSecondAllimPage({
    Key? key,
    required this.noticeId,
    required this.userRole
  }) : super(key: key);

  final int noticeId;
  final String userRole;

  @override
  State<ManagerSecondAllimPage> createState() => _ManagerSecondAllimPageState();
}

class _ManagerSecondAllimPageState extends State<ManagerSecondAllimPage> {
  late int _noticeId;
  late Map<String, dynamic> _noticeDetail = Map<String, dynamic>();
  late List<String> _imageUrls = [];
  late String _userRole;

  @override
  void initState() {
    _noticeId = widget.noticeId;
    _userRole = widget.userRole;
    getNoticeDetail();
  }

  Future<void> deleteNotice(int noticeId) async {

    http.Response response = await http.delete(
      Uri.parse(backendUrl+ 'notices'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "notice_id": noticeId
      })
    );

    if (response != 200)
      throw Exception();
  }

  Future<void> getNoticeDetail() async {
      debugPrint("@@@@@ 공지사항 상세정보 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl+ 'notices/detail/' + _noticeId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    if (response.statusCode != 202) {
        throw Exception('POST request failed');
    }

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);
    _noticeDetail = parsedJson;

    _imageUrls = List<String>.from(parsedJson['image_url']);

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('알림장 내용'),
      ),
      body: eachmanager(),

    );
  }
  //시설장 및 직원 알림장(각 목록)
  Widget eachmanager() {
        if (_noticeDetail['notice_id'] == null)
          return Text("asdf");

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '삼족오 보호자님', //_noticeDetail['resident_name'] + '입소자님'
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          _noticeDetail['create_date'].toString().substring(0, 10).replaceAll('-', '.'), //TODO 2023-03-30으로 바꾸기
                          style: TextStyle(fontSize: 10),
                        ),
                      ],

                    ),
                    Spacer(),
                    
                    if (_userRole != 'PROTECTOR')
                      Container(
                        child: Consumer<ResidentProvider>(
                          builder: (context, residentProvider, child) {
                            return OutlinedButton(
                                onPressed: (){
                                  pageAnimation(context, EditAllimPage(noticeId: _noticeId, noticeDetail: _noticeDetail, imageUrls: _imageUrls,facility_id: residentProvider.facility_id,));
                                },
                                child: Text('수정')
                            );
                          }
                        ),

                      ),
                    if (_userRole != 'PROTECTOR')
                      Container(
                        padding: EdgeInsets.all(5),
                        //alignment: Alignment.centerRight,
                        child: OutlinedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text("정말 삭제하시겠습니까>"),
                                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                    actions: [
                                      TextButton(
                                        child: const Text('삭제'),
                                        onPressed: () async {
                                          try {
                                            await deleteNotice(_noticeId);
                                          } catch(e) {
                                          }

                                          Navigator.of(context).pop();
                                        },
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
                            },
                            child: Text('삭제')
                        ),
                      ),
                    
                  ],
                ),
              ),
              Column(
                children: [
                  for (int i =0; i< _imageUrls.length; i++ ) ...[
                    Image.network(_imageUrls[i], fit: BoxFit.fill,),
                  ]
                ]
              ),

              //알림장 세부 내용
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(7,7,7,7),
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  _noticeDetail['content'].toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ),

              //알림장 안에 있는 어르신의 일일정보
              informdata(_noticeDetail['sub_content'].toString())
            ],
          )
          
        );
      }

  }

  //알림장 안에 있는 어르신의 일일정보 함수
  Widget informdata(String info){
    List<String> result = info.split('\n');

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(7,7,7,7),
        child: Column(
          children: [
            inform('아침',result[0]),
            Divider(thickness: 0.5,),
            inform('점심',result[1]),
            Divider(thickness: 0.5,),
            inform('저녁',result[2]),
            Divider(thickness: 0.5,),
            inform('투약',result[3]),
          ],
        ),
    );
  }

  Widget inform(String text1, String text2){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 30),
          child: Text(
            '$text1',
            style: TextStyle(fontSize: 15,color: Colors.black38),
          ),
        ),
        Text('$text2',style: TextStyle(fontSize: 15,color: Colors.black),),
      ],
    );
}




