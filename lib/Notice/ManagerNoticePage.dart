//ManagerNoticePage
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Notice/ModificationNoticePage.dart';
import 'package:test_data/Notice/NoticeDetailPage.dart';
import 'package:test_data/Supplementary/CustomWidget.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '../provider/NoticeTempProvider.dart';
import '../provider/ResidentProvider.dart';
import '/Supplementary/ThemeColor.dart';
import 'WriteNoticePage.dart';
import 'package:http/http.dart' as http; //http 사용




import 'package:test_data/Backend.dart';
ThemeColor themeColor = ThemeColor();

class ManagerNoticePage extends StatefulWidget {
  const ManagerNoticePage({
    Key? key,
    required this.userRole,
    required this.facilityId,
    required this.residentId,
  }) : super(key: key);

  final String userRole;
  final int facilityId;
  final int residentId;

  @override
  State<ManagerNoticePage> createState() => _ManagerNoticePageState();
}

class _ManagerNoticePageState extends State<ManagerNoticePage> {
  late int _facilityId;
  late int _residentId;
  String _userRole = '';
  List<Map<String, dynamic>> _noticeList = [];

    @override
  void initState() {
    _userRole = widget.userRole;
    _facilityId = widget.facilityId;
    _residentId = widget.residentId;
    getNotice(_facilityId);
  }

  //삭제
  Future<void> deleteNotice(int allnoticeId) async {
    http.Response response = await http.delete(
        Uri.parse(Backend.getUrl()+ 'all-notices'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "allnotice_id": allnoticeId
        })
    );

    debugPrint("@@@statusCode= " + response.statusCode.toString());

    if (response.statusCode != 200)
      throw Exception();
  }

  //공지사항 받아옴
 Future<void> getNotice(int facility_id) async {
    debugPrint("@@@@@ 공지사항 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "all-notices/facilities/" + facility_id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    parsedJson.sort((a, b) { //날짜 최신순으로 정렬
      DateTime aDate = DateTime.parse(a['create_date']);
      DateTime bDate = DateTime.parse(b['create_date']);
      return bDate.compareTo(aDate);
    });

    setState(() {
      _noticeList =  parsedJson;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지사항')),
      backgroundColor: Color(0xfff8f8f8), //배경색
      body: ListView(
        children: [
          noticeList(),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }

  //플로팅액션버튼
  Widget _getFAB() {
    if (_userRole == 'PROTECTOR') {
      return Container();
    } else {
      return writeButton(
          context: context,
          onPressed: () async {
            await awaitPageAnimation(context, WriteNoticePage(residentId: _residentId));
            getNotice(_facilityId);
          });
    }
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

          bool isImportant = _noticeList[index]['important']; // 각 게시물의 중요 여부 가져오기

          return Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            color: Colors.white,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isImportant ? getRedTag() : getGreyTag(), // 중요 여부에 따른 태그 표시
                        SizedBox(height: 5),

                        Text(_noticeList[index]['title'], maxLines: 1, overflow: TextOverflow.ellipsis), //공지 제목
                        Text(_noticeList[index]['create_date'].toString().substring(0, 10).replaceAll('-', '.'), textScaleFactor: 1.0,), //TODO: 공지사항 날짜
                      ],
                    ),
                  ),

                  //TODO: 이미지
                  Container(
                    width: 100,
                    height: 100,
                    color: imgList.length != 0 ? null : Colors.white,
                    child: imgList.length != 0
                        ? Image.network(
                      imgList[0],
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )
                        : null,
                  ),





                  // if (imgList.length != 0)
                  //   Container(
                  //       width: 100,
                  //       height: 100,
                  //       child: Container(
                  //         child: Image.network(
                  //           imgList[0],
                  //           fit: BoxFit.fill,
                  //           loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  //             if (loadingProgress == null) return child;
                  //             return Center(
                  //               child: CircularProgressIndicator(
                  //                 value: loadingProgress.expectedTotalBytes != null
                  //                     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                  //               ),
                  //             );
                  //           },),
                  //       )
                  //   ),
                  //
                  // if(imgList.length == 0)
                  //   Container(width: 100, height: 100, color: Colors.red,)
                ],
              ),
              onTap: () {
                print('공지 목록: ${_noticeList[index]['title']} Tap');
                pageAnimation(context, noticeManagerPage(index)); //공지사항 내용으로 이동
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


  //태그 선택
  Widget getTag(BuildContext context) {
    if (Provider.of<NoticeTempProvider>(context).isImportant) {
      return getRedTag(); // 중요
    } else {
      return getGreyTag(); // 공지사항
    }
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


  Widget noticeManagerPage(int index) {
    return NoticeDetailPage(
        index: index,
        userRole: _userRole,
        noticeList: _noticeList,
        getNotice: getNotice,
        facilityId: _facilityId,
        deleteNotice: deleteNotice);
  }

  //공지 상세 내용 - 원래 되던 거
  Widget TestnoticeManagerPage(int index) {
    List<String> imgList = List<String>.from(_noticeList[index]['imageUrl']);

    return Scaffold(
      appBar: AppBar(title: Text('공지사항 내용')),
      body: ListView(
        children: [
          Column(
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
                        Text(_noticeList[index]['title']), //공지 제목
                        Text(_noticeList[index]['create_date'].toString().substring(0, 10).replaceAll('-', '.')), //공지 게시한 날짜
                      ],
                    ),
                    const Spacer(),
                    if (_userRole != 'PROTECTOR')
                      OutlinedButton(
                        child: Text('수정'),
                        onPressed: () async {
                          int facility_id = Provider.of<ResidentProvider>(context, listen: false).facility_id;
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ModificationNoticePage(noticeId: _noticeList[index]['allNoticeId'],
                                          facility_id: facility_id, noticeList: _noticeList[index], imageUrls: imgList))
                            //EditAllimPage(noticeId: _noticeId, noticeDetail: _noticeDetail, imageUrls: _imageUrls,facility_id: residentProvider.facility_id,)),

                          );
                        },
                      ),
                    if (_userRole != 'PROTECTOR')
                      OutlinedButton(
                        child: Text('삭제'),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text("정말 삭제하시겠습니까?"),
                                  insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                  actions: [
                                    TextButton(
                                      child: const Text('삭제'),
                                      onPressed: () async {
                                        try {
                                          await deleteNotice(_noticeList[index]['allNoticeId']);
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                              builder: (BuildContext context3) {
                                                return AlertDialog(
                                                  content: Text('삭제 완료'),
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
                                        } catch(e) {
                                          debugPrint("@@@삭제 오류 $e");
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text("공지사항 삭제 실패! 다시 시도해주세요"),
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

                      ),

                  ],
                ),
              ),

              //TODO: 공지사항 본문 사진
              Container(
                margin: EdgeInsets.fromLTRB(0,10,0,0),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                    children: [
                      for (int i =0; i< imgList.length; i++ ) ...[
                        Image.network(imgList[i], fit: BoxFit.fill,),
                      ]
                    ]
                ),
              ),

              //TODO: 공지사항 세부 내용
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(7,7,7,7),

                child: Text('공지사항 내용: ${_noticeList[index]['content']}'),
              ),
            ],
          )
        ],
      ),
    );
  }

}


