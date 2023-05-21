import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Backend.dart';
import 'package:test_data/VisitRequest/SelectedTimePage.dart';
import 'package:test_data/VisitRequest/VisitWritePage.dart';
import 'package:test_data/provider/VisitTempProvider.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'SelectedDatePage.dart';
import 'package:http/http.dart' as http; //http 사용
import '../Supplementary/CustomClick.dart';

String backendUrl = Backend.getUrl();

ThemeColor themeColor = ThemeColor();

class ManagerRequestPage extends StatefulWidget {
  const ManagerRequestPage({
    Key? key, 
    required this.userId,
    required this.residentId,
    required this.facilityId,
    required this.userRole
  }) : super(key: key);

  final int userId;
  final int residentId;
  final int facilityId;
  final String userRole;

  @override
  State<ManagerRequestPage> createState() => _ManagerRequestPageState();
}

class _ManagerRequestPageState extends State<ManagerRequestPage> {
  final formKey = GlobalKey<FormState>();
  CheckClick checkClick = new CheckClick();
  late final TextEditingController bodyController = TextEditingController(text: '면회 신청합니다.');
  late final TextEditingController refusalController = TextEditingController();
  String selectedHour = '시간 선택';
  List<Map<String, dynamic>> _visitList = [];
  late int _userId;
  late int _residentId;
  late int _facilityId;
  late String _userRole;
  String _rejectReason = '';
  String? stateText;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _residentId = widget.residentId;
    _facilityId = widget.facilityId;
    _userRole = widget.userRole;
    getVisitList(_userId);
  }

  // 서버에 면회신청 상태변경 WAITING -> REJECTED, APPROVED, COMPLETED
  Future<void> editState(int visit_id, String state) async {
    var url = Uri.parse(Backend.getDomain() + 'visit/approval');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
        "visit_id": visit_id,
        "state": state,
        "rejReason": _rejectReason
    });

    final response = await http.post(url, headers: headers, body: body);

    debugPrint("@@@" + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  Future<void> approve(int visit_id) async {
    debugPrint("@@@@@ 면회신청 수락하는 백앤드 url 보냄");
    await editState(visit_id, "APPROVED");
  }

  Future<void> reject(int visit_id) async {
    debugPrint("@@@@@ 면회신청 거절하는 백앤드 url 보냄");
    await editState(visit_id, "REJECTED");
  }

  Future<void> complete(int visit_id) async {
    debugPrint("@@@@@ 면회 완료 백앤드 url 보냄");
    await editState(visit_id, "COMPLETED");
  }

  Future<void> getVisitList(int userId) async {
    debugPrint("@@@@@ 면회신청목록 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl + "visit/" + userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _visitList =  parsedJson;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('면회 목록')),
      backgroundColor: Color(0xfff8f8f8), //배경색
      body: RequestList(),
      floatingActionButton: getButton()
    );
  }

  // 면회 리스트
  Widget RequestList() {
    return  ListView.separated(
      itemCount: _visitList.length, //면회 목록 출력 개수
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          color: Colors.white,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_visitList[index]['want_date'].substring(0, 10).replaceAll('-', '.')), //TODO: 면회 날짜
                    SizedBox(width: 10),
                    Icon(Icons.schedule_rounded, color: Colors.grey, size: 20),
                    SizedBox(width: 2),
                    Text(_visitList[index]['want_date'].substring(11, 16)), //TODO: 면회 시간 //"2023-05-08T21:09:00.298Z"
                    const Spacer(),

                    if (_userRole != 'PROTECTOR' && _visitList[index]['state'] == 'WAITING')
                      Row(
                      children: [
                        OutlinedButton(
                          child: Text('수락'),
                          onPressed: (){
                            showDialog(
                              context: context,
                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text("면회신청을 수락하시겠습니까?"),
                                  insetPadding:
                                      const EdgeInsets.fromLTRB(0, 80, 0, 80),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        '취소',
                                        style: TextStyle(
                                          color: themeColor.getColor(),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                          color: themeColor.getColor(),
                                        ),
                                      ),
                                      onPressed: () async {
                                        try {
                                          // await deleteSchedule(sc.scheduleId);
                                          // setState(() {
                                          //   mySelectedEvents = {};
                                          //   getSchedules();
                                          // });

                                          // visit approve event
                                          await approve(_visitList[index]['visit_id']);
                                          setState(() {
                                            getVisitList(_userId);
                                          });
                                          showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // 바깥 영역 터치시 닫을지 여부
                                            builder: (BuildContext context3) {

                                              return AlertDialog(
                                                content: Text('면회신청을 수락하였습니다'),
                                                insetPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 80, 0, 80),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('확인'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                        } catch (e) {
                                          debugPrint("@@@@@ososfdo");
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }); 
                          },
                        ),
                        const SizedBox(width: 3),
                        OutlinedButton(
                          child: const Text('거절'),
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context) =>
                                AlertDialog(
                                  title: const Text('거절 사유'),
                                  content: Form(
                                    key: formKey,
                                    autovalidateMode: AutovalidateMode.always,
                                    child: TextFormField(
                                      controller: refusalController,
                                      validator: (value) {
                                        if(value!.isEmpty) return '면회 거절 사유를 입력하세요';
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      minLines: 1,
                                      maxLines: 10,
                                      decoration: const InputDecoration(
                                        hintText: '내용을 입력하세요',
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                      ),
                                      onSaved: (value) {
                                        _rejectReason = value!;
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(child: Text('취소',
                                      style: TextStyle(color: themeColor.getMaterialColor())),
                                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                    TextButton(child: Text('예',
                                      style: TextStyle(color: themeColor.getMaterialColor())),
                                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                      onPressed: () async {
                                        if(this.formKey.currentState!.validate()) {
                                          this.formKey.currentState!.save();

                                          try {
                                            if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                              return ;
                                            }

                                            await reject(_visitList[index]['visit_id']);
                                            setState(() {
                                              getVisitList(_userId);
                                            });
                                            Navigator.pop(context);
                                          } catch(e) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text("실패하였습니다 다시 시도해주세요"),
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
                                        }
                                        Future.delayed(const Duration(milliseconds: 300), () {
                                          refusalController.text = '';
                                        });
                                      }),
                                  ],
                                ),
                            );
                          },
                        ),
                      ]
                      ),
                    
                    if (_userRole == 'PROTECTOR')
                      OutlinedButton(
                        child: Text('취소', style: TextStyle(color: Colors.grey),),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                              AlertDialog(
                                content: const Text('면회 신청을 취소하시겠습니까?'),
                                actions: [
                                  TextButton(child: Text('아니오',
                                      style: TextStyle(color: themeColor.getMaterialColor())),
                                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  TextButton(child: Text('예',
                                      style: TextStyle(color: themeColor.getMaterialColor())),
                                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                      onPressed: () {
                                        try {
                                          // visit approve event
                                          // await addAllim(userProvider.uid, residentProvider.facility_id);

                                          if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                            return ;
                                          }

                                          showDialog(
                                            context: context,
                                            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                            builder: (BuildContext context3) {
                                              return AlertDialog(
                                                content: Text('면회신청을 취소하였습니다'),
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
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text("면회 취소 실패! 다시 시도해주세요"),
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
                                        Navigator.pop(context);
                                      }),
                                  ],
                                ),
                            );
                          },
                        ),
                  
                    if (_userRole != 'PROTECTOR' && _visitList[index]['state'] == 'APPROVED')
                      OutlinedButton(
                        child: Text('완료'),
                        onPressed: (){
                          showDialog(
                            context: context,
                            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text("면회신청을 완료처리하시겠습니까?"),
                                insetPadding:
                                    const EdgeInsets.fromLTRB(0, 80, 0, 80),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                        color: themeColor.getColor(),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        color: themeColor.getColor(),
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        await complete(_visitList[index]['visit_id']);
                                        setState(() {
                                          getVisitList(_userId);
                                        });

                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        debugPrint("@@@@@ososfdo");
                                      }
                                    },
                                  ),
                                ],
                              );
                            }); 
                        },
                      )
                        
                      
                  ],
                ),


                Text(_visitList[index]['residentName'].toString() + " 님(" + _visitList[index]['visitorName'] + " 보호자님)"), //TODO: ㅇㅇㅇ 보호자님 출력
                Text(_visitList[index]['texts']), //TODO: 할 말 출력
                Divider(thickness: 0.5),
                if (_visitList[index]['state'] == 'WAITING')
                  Text('면회 수락 대기 중입니다.', style: TextStyle(color: Colors.grey)),
                if (_visitList[index]['state'] == 'APPROVED')
                  Text('면회 수락되었습니다. 제때 방문하세요.', style: TextStyle(color: themeColor.getColor())),
                if (_visitList[index]['state'] == 'REJECTED')
                  Text("거절되었습니다.\n사유: " + _visitList[index]['rejReason'], style: TextStyle(color: themeColor.getColor())), //TODO: 수락/거절 출력
                // if (_visitList[index]['state'] != 'REJECTED')
                //   Text(_visitList[index]['state'], style: TextStyle(color: themeColor.getColor())), //TODO: 수락/거절 출력
              ],
              //'2022.12.23'
              // '16:00'
              // '삼족오 보호자님'
              // '면회 신청합니다.'
              // '거절하였습니다. (면회 시간이 아님)'
            )
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }

  //글쓰기 버튼
  Widget getButton(){

    if (_userRole == 'PROTECTOR') {
      return writeButton(
          context: context,
        onPressed: () async {
            await awaitPageAnimation(context, VisitWritePage(userId: _userId, residentId: _residentId, facilityId: _facilityId));

          // await Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => VisitWritePage(userId: _userId, residentId: _residentId, facilityId: _facilityId)));

          getVisitList(_userId);
        },
      );
    } else {
      return Container();
    }
    
  }
}
