import 'dart:convert';

import 'package:flutter/material.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '/Supplementary/ThemeColor.dart';
import 'WriteNoticePage.dart';
import '/Allim/WriteAllimPage.dart';
import 'package:http/http.dart' as http; //http 사용

ThemeColor themeColor = ThemeColor();

String backendUrl = "http://52.78.62.115:8080/v2/";

class ManagerNoticePage extends StatefulWidget {
  const ManagerNoticePage({
    Key? key,
    required this.userRole,
    required this.facilityId
  }) : super(key: key);

  final String userRole;
  final int facilityId;

  @override
  State<ManagerNoticePage> createState() => _ManagerNoticePageState();
}

class _ManagerNoticePageState extends State<ManagerNoticePage> {
  String _userRole = '';
  int _facilityId = 0;
  List<Map<String, dynamic>> _noticeList = [];

  Future<void> getNotice(int residentId) async {
    debugPrint("@@@@@ 공지사항 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(backendUrl + "all-notices/" + residentId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _noticeList =  parsedJson;
    });
  }

  @override
  void initState() {
    _userRole = widget.userRole;
    _facilityId = widget.facilityId;
    getNotice(_facilityId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지사항')),
      body: ListView(
        children: [
          noticeList(),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }

  //플로팅 버튼
  Widget _getFAB() {
    if (_userRole == 'PROTECTOR')
      return Container();
    else
      return FloatingActionButton(
        onPressed: () {
          //글쓰기 화면으로 이동
          pageAnimation(context, WriteNoticePage());

        },
        child: const Icon(Icons.create),
      );

        //writeButton(context, WriteNoticePage());
  }

  //공지사항 목록
  Widget noticeList() {
    return ListView.separated(
      itemCount: _noticeList.length, //공지 목록 출력 개수
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {


        if(_noticeList != null && _noticeList.length != 0) {
          List<String> imgList = List<String>.from(_noticeList[index]['imageUrl']);
          return Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            color: Colors.white,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getGreyTag(),  //TODO: 태그
                      SizedBox(height: 5),
                      Container(
                          child: Text(_noticeList[index]['title'], overflow: TextOverflow.ellipsis), //공지사항 제목
                          width: MediaQuery.of(context).size.width * 0.5),
                      Text(_noticeList[index]['create_date'].toString().substring(0, 10).replaceAll('-', '.')), //공지사항 날짜
                    ],
                  ),
                  if (imgList.length != 0)
                    Container(
                        width: 100,
                        height: 100,
                        child: Container(
                          child: Image.network(imgList[0], fit: BoxFit.fill,),
                        )
                    ),
                ],
              ),
              onTap: () {
                print('공지 목록: ${_noticeList[index]['title']} Tap');
                //pageAnimation(context, noticeManagerPage(index)); // TODO: 공지사항 내용으로 이동
              },
            ),
          );
        }

        else
          return Container();











      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }

  Widget getRedTag() {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Color(0xffffe9e9),
      ),
      child: Text('중요', textScaleFactor: 0.85, style: TextStyle(color: Color(0xffed3939))),
    );
  }

  Widget getGreyTag() {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Color(0xfff2f3f5),
        ),
        child: Text('공지사항', textScaleFactor: 0.85, style: TextStyle(color: Color(0xff6d767f))),
    );
  }


  //TODO: 공지사항 상세 내용
  //요양보호사 버전 - 공지 상세 내용
  // Widget noticeManagerPage(int index) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('공지사항 내용')),
  //     body: ListView(
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
  //               width: double.infinity,
  //               color: Colors.white,
  //               child: Row(
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(titleList[index]), //공지 제목
  //                       Text(dateList[index]), //공지 게시한 날짜
  //                     ],
  //                   ),
  //                   const Spacer(),
  //                   OutlinedButton(
  //                     child: Text('수정'),
  //                     onPressed: (){
  //                       //TODO: 수정 화면으로 넘어가기
  //                     },
  //                   ),
  //                   OutlinedButton(
  //                     child: Text('삭제'),
  //                     onPressed: (){
  //                       showDialog(
  //                         context: context,
  //                         builder: (context) =>
  //                             AlertDialog(
  //                               content: const Text('삭제하시겠습니까?'),
  //                               actions: [
  //                                 TextButton(child: Text('취소',
  //                                     style: TextStyle(color: themeColor.getMaterialColor())),
  //                                     onPressed: () {
  //                                       Navigator.pop(context);
  //                                     }),
  //                                 TextButton(child: Text('예',
  //                                     style: TextStyle(color: themeColor.getMaterialColor())),
  //                                     onPressed: () {
  //                                       Navigator.pop(context);
  //                                       //TODO: 공지 삭제 이벤트
  //                                     }),
  //                               ],
  //                             ),
  //                       );
  //                     },
  //
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             //공지사항 사진
  //             Container(
  //                 margin: EdgeInsets.fromLTRB(0,10,0,0),
  //                 width: double.infinity,
  //                 color: Colors.white,
  //                 height: imgList[index].isNotEmpty ? 300 : null,
  //                 child: Container(
  //                     child: imgList[index].isNotEmpty
  //                         ? Container(
  //                       child: Image.asset(imgList[index], fit: BoxFit.fill,),
  //                     )
  //                         : null
  //                 )
  //             ),
  //
  //             //공지사항 세부 내용
  //             Container(
  //               width: double.infinity,
  //               color: Colors.white,
  //               padding: EdgeInsets.fromLTRB(7,7,7,7),
  //
  //               child: Text('공지사항 내용: ${titleList[index]} ${titleList[index]} ${titleList[index]} ${titleList[index]} ${titleList[index]}'),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

}
