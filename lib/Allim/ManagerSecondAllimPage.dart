import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_data/Allim/EditAllimPage.dart';
import 'package:test_data/Supplementary/PageRouteWithAnimation.dart';
import 'package:test_data/provider/ResidentProvider.dart';

import 'package:test_data/Backend.dart';

import '../MainFacilitySettings/UserPeopleManagementPage.dart';
import '../Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class ManagerSecondAllimPage extends StatefulWidget {
  const ManagerSecondAllimPage(
      {Key? key, required this.noticeId, required this.userRole})
      : super(key: key);

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
        Uri.parse(Backend.getUrl() + 'notices'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({"notice_id": noticeId}));

    debugPrint("@@@statusCode= " + response.statusCode.toString());

    if (response.statusCode != 200) throw Exception();
  }

  Future<void> getNoticeDetail() async {
    debugPrint("@@@@@ 공지사항 상세정보 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + 'notices/detail/' + _noticeId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        });

    if (response.statusCode != 200) {
      throw Exception('POST request failed');
    }

    var data = utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);
    _noticeDetail = parsedJson;

    _imageUrls = List<String>.from(parsedJson['image_url']);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8), //배경색
      appBar: AppBar(
        title: const Text('알림장 내용'),
      ),
      body: eachmanager(),
    );
  }

  //시설장 및 직원 알림장(각 목록)
  Widget eachmanager() {
    if (_noticeDetail['notice_id'] == null)
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()));

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
          width: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              if (_userRole != 'PROTECTOR')
                SizedBox(
                  width: (MediaQuery.of(context).size.width) / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_noticeDetail['target_name'] + ' 보호자님'),
                      Text(
                        _noticeDetail['create_date']
                            .toString()
                            .substring(0, 10)
                            .replaceAll('-', '.'), //TODO 2023-03-30으로 바꾸기
                      ),
                    ],
                  ),
                ),
              if (_userRole == 'PROTECTOR')
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_noticeDetail['target_name'] + ' 보호자님'),
                      Text(
                        _noticeDetail['create_date']
                            .toString()
                            .substring(0, 10)
                            .replaceAll('-', '.'), //TODO 2023-03-30으로 바꾸기
                      ),
                    ],
                  ),
                ),
              Positioned(
                top: -10,
                right: 5,
                child: Row(
                  children: [
                    if (_userRole != 'PROTECTOR')
                      Container(
                        child: Consumer<ResidentProvider>(
                            builder: (context, residentProvider, child) {
                          return OutlinedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditAllimPage(
                                            noticeId: _noticeId,
                                            residentId:
                                                residentProvider.resident_id,
                                            noticeDetail: _noticeDetail,
                                            imageUrls: _imageUrls,
                                            facility_id:
                                                residentProvider.facility_id,
                                          )),
                                );
                                getNoticeDetail();
                              },
                              child: Text('수정',
                                  style: TextStyle(color: Colors.grey)));
                        }),
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
                                      content: Text("정말 삭제하시겠습니까?"),
                                      insetPadding: const EdgeInsets.fromLTRB(
                                          0, 80, 0, 80),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                                color: themeColor.getColor()),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            '삭제',
                                            style: TextStyle(
                                              color: themeColor.getColor(),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (checkClick.isRedundentClick(
                                                DateTime.now())) {
                                              return;
                                            }

                                            try {
                                              await deleteNotice(_noticeId);
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // 바깥 영역 터치시 닫을지 여부
                                                  builder:
                                                      (BuildContext context3) {
                                                    return AlertDialog(
                                                      content: Text('삭제되었습니다'),
                                                      insetPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              0, 80, 0, 80),
                                                      actions: [
                                                        TextButton(
                                                          child: Text(
                                                            '확인',
                                                            style: TextStyle(
                                                              color: themeColor
                                                                  .getColor(),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            } catch (e) {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // 바깥 영역 터치시 닫을지 여부
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          "알림장 업로드 실패! 다시 시도해주세요"),
                                                      insetPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              0, 80, 0, 80),
                                                      actions: [
                                                        TextButton(
                                                          child: Text(
                                                            '확인',
                                                            style: TextStyle(
                                                              color: themeColor
                                                                  .getColor(),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text('삭제',
                                style: TextStyle(color: Colors.grey))),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(children: [
            for (int i = 0; i < _imageUrls.length; i++) ...[
              Image.network(
                _imageUrls[i],
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ]
          ]),
        ),

        //알림장 세부 내용
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            _noticeDetail['content'].toString(),
          ),
        ),

        //알림장 안에 있는 어르신의 일일정보
        informdata(_noticeDetail['sub_content'].toString())
      ],
    ));
  }

  //알림장 안에 있는 어르신의 일일정보 함수
  Widget informdata(String info) {
    List<String> result = info.split('\n');

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
      child: Column(
        children: [
          inform('아침', result[0]),
          Divider(
            thickness: 0.5,
          ),
          inform('점심', result[1]),
          Divider(
            thickness: 0.5,
          ),
          inform('저녁', result[2]),
          Divider(
            thickness: 0.5,
          ),
          inform('투약', result[3]),
        ],
      ),
    );
  }

  Widget inform(String text1, String text2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 30),
          child: Text(
            '$text1',
            style: TextStyle(color: Colors.black38),
          ),
        ),
        Text(
          '$text2',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
