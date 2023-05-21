import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Supplementary/ThemeColor.dart';
import '../Allim/WriteAllimPage.dart';
import 'package:http/http.dart' as http;
import '../Supplementary/CustomClick.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '../provider/ResidentProvider.dart'; //http 사용

import 'package:test_data/Backend.dart';

import '../provider/UserProvider.dart';
ThemeColor themeColor = ThemeColor();
CheckClick checkClick = new CheckClick();
class userPeopleManagementPage extends StatefulWidget {
  const userPeopleManagementPage({Key? key}) : super(key: key);

  @override
  State<userPeopleManagementPage> createState() => _userPeopleManagementPageState();
}


class _userPeopleManagementPageState extends State<userPeopleManagementPage> with TickerProviderStateMixin {
  static List<Map<String, dynamic>> _residents = [];
  Map<String, dynamic> _residentsdetail = {};

  Future<void> getFacilityResident(int facilityId) async {
    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "nhResidents/protectors/" + facilityId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residents =  parsedJson;
    });
  }

  Future<void> getResidentDetail(int nhrId) async {
    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + nhrId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson =  Map<String, dynamic>.from(decodedJson);

    setState(() {
      _residentsdetail =  parsedJson;
    });
    if (response.statusCode == 200)
      print('성공');
    else
      print('실패');
  }

  //추가
  Future<void> addInmate(residentId, uid, facilityId) async {
    debugPrint("@@입소자를 내가 담당하는 입소자로 추가 백엔드 요청 보냄: " + residentId.toString() + "/" + uid.toString() + "/" + facilityId.toString());
    var url = Uri.parse(Backend.getUrl() + 'nhResidents/manage');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "nhresident_id": residentId,
      "user_id": uid,
      "facility_id": facilityId,
    });
  
    final response = await http.post(url, headers: headers, body: body);

    debugPrint("@@추가에서 statuscode: " + response.statusCode.toString());
  
    if (response.statusCode == 200) {
      print("성공: $residentId $uid $facilityId"); //39 10 1
    } else {
      throw Exception();
    }
  }

  //삭제
  Future<void> deleteresident(int userId, int nhresidentId) async {
    http.Response response = await http.delete(
        Uri.parse(Backend.getUrl() + 'nhResidents'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "user_id": userId,
          "nhresident_id": nhresidentId
        })
    );
    print(response.statusCode);
    if (response.statusCode == 200)
      // 화면 다시 그리기
      setState(() {
        _residents.removeWhere((resident) => resident['user_id'] == userId);
        _residents.removeWhere((resident) => resident['nhresident_id'] == nhresidentId);
      });
  }

  @override
  void initState() {
    super.initState();
    final residentProvider = context.read<ResidentProvider>();
    getFacilityResident(residentProvider.facility_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('입소자 관리')),
        body: ListView(
          children: [
            approve()
          ],
        )
    );
  }

  Widget approve(){
    return Container(
      padding: EdgeInsets.only(left: 5, top: 10),
      child: Consumer2<ResidentProvider, UserProvider>(
          builder: (context, residentProvider, userProvider, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _residents.length,
              itemBuilder: (BuildContext _context, int index) {
                return ListTile(
                  leading: Icon(Icons.person_rounded, color: Colors.grey),
                  title: Row(
                    children: [
                      Text('${_residents[index]['name']} 님'),
                      Spacer(),
                      Row(
                        children: [
                          if (_residents[index]['worker_id'] != residentProvider.resident_id)
                            OutlinedButton(
                              child: Text('추가',style: TextStyle(color: themeColor.getColor()),),
                              style: OutlinedButton.styleFrom(side: BorderSide(color: themeColor.getColor())),
                              onPressed: () async {
                                //입소자 추가 시 -> 입소자 정보에 추가
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("내가 담당하는 입소자로 추가하시겠습니까?"),
                                      insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                      actions: [
                                        TextButton(
                                          child: Text('취소',style: TextStyle(color: themeColor.getColor(),),),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('예',style: TextStyle(color: themeColor.getColor())),
                                          onPressed: () async {
                                            try {
                                              await addInmate(_residents[index]['id'], userProvider.uid, residentProvider.facility_id);
                                            } catch(e) { print('에러@@@@@@@@@@@@@@@@@@@' + e.toString()); }

                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                );
                              
                                getFacilityResident(residentProvider.facility_id);
                              },
                            ),

                          SizedBox(width: 4,),
                          OutlinedButton(
                              // style: OutlinedButton.styleFrom(
                              //     side: BorderSide(color: themeColor.getColor(),)
                              // ),
                              onPressed: () async {
                                //입소자 삭제
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
                                                await deleteresident(_residents[index]['user_id'], _residents[index]['id']);
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
                              child: Text('삭제',style: TextStyle(color: Colors.grey))
                          ),

                        ],
                      )


                    ],
                  ),
                  onTap: () async {
                    if (checkClick.isRedundentClick(DateTime.now())) {
                      return;
                    }
                    await getResidentDetail(_residents[index]['id']);
                    pageAnimation(context, residentDetailPage(index));
                  },
                );
              },
            );
          }
      ),
    );
  }



  //입소자 상세 내용
  Widget residentDetailPage(int index) {
    return Scaffold(
        appBar: AppBar(title: Text('입소자 세부 정보')),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),child: Text('입소자 이름'),),
                myDetailBox(_residentsdetail['resident_name']),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),child: Text('입소자 생년월일'),),
                myDetailBox(_residentsdetail['birth']),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),child: Text('보호자 이름'),),
                myDetailBox(_residentsdetail['protector_name']),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),child: Text('보호자 연락처'),),
                myDetailBox(_residentsdetail['protector_phone_num'])
              ],
            )
          ],
        )
    );
  }

  Widget myDetailBox(String text) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('$text'),
              ],
            )
        )
    );
  }
}