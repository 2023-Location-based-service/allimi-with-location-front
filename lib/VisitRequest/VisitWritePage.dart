import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_data/VisitRequest/SelectedTimePage.dart';
import 'package:test_data/provider/VisitTempProvider.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'SelectedDatePage.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/";

ThemeColor themeColor = ThemeColor();
// List<String> dateList =['2022.12.23','2022.12.24','2022.12.25'];
// List<String> timeList =['16:00', '13:00', '11:00'];
// List<String> personList =['삼족오 보호자님', '사족오 보호자님', '오족오 보호자님'];
// List<String> textList =['면회 신청합니다.', '면회 신청합니다. 동생이 갑니다.', '면회 신청합니다.'];
// List<String> subtextList =[' ', '거절하였습니다. (면회 시간이 아님)', ' 수락하였습니다.'];

class VisitWritePage extends StatefulWidget {
  const VisitWritePage({
    Key? key,
    required this.userId,
    required this.residentId,
    required this.facilityId
  }) : super(key: key);

  final int userId;
  final int residentId;
  final int facilityId;

  @override
  State<VisitWritePage> createState() => _VisitWritePageState();
}

class _VisitWritePageState extends State<VisitWritePage> {

    late final TextEditingController bodyController = TextEditingController(text: '면회 신청합니다.');
  late final TextEditingController refusalController = TextEditingController();
    String _text = '';
    final formKey = GlobalKey<FormState>();

    late int _userId;
  late int _residentId;
  late int _facilityId;



  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _residentId = widget.residentId;
    _facilityId = widget.facilityId;
  }

  // 서버에 면회신청 업로드
  Future<void> addVisit(String date, String time) async {
    //2023.05.10  //04:00

    String datetimeConvert = date.replaceAll('.', '-') + 'T' + time + ":00.000Z";

    debugPrint("@@@@@ 면회신청 추가하는 백앤드 url 보냄");
    var url = Uri.parse("http://52.78.62.115:8080/" + 'visit');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": _userId,
      "nhresident_id": _residentId,
      "facility_id": _facilityId,
      "texts": _text, 
      "dateTime": datetimeConvert 
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
    return Scaffold(
      body: writePage()
    );
  }

    //글쓰기 화면
  Widget writePage() {
    return customPage(
      title: '면회 신청',
      buttonName: '접수',
      onPressed: () {
        String bodyTemp = bodyController.text.replaceAll(' ', '');
        if(bodyTemp.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('할 말 내용을 입력해주세요.')));
          return;
        }

        this.formKey.currentState!.save();

        showDialog(
          context: context,
          barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
          builder: (BuildContext context) {
            return Consumer<VisitTempProvider>(
              builder: (context, visitProvider, child) {
                return AlertDialog(
                  content: Text("면회를 신청하시겠습니까?"),
                  insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                  actions: [
                    TextButton(
                      child: Text('취소',style: TextStyle(color: themeColor.getColor(),),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                      onPressed: () async {
                        try {
                          await addVisit(visitProvider.selectedDate, visitProvider.selectedTime);

                          showDialog(
                            context: context,
                            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                            builder: (BuildContext context3) {
                              return AlertDialog(
                                content: Text('작성 완료'),
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
                                content: Text("면회 신청 실패! 다시 시도해주세요"),
                                insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
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
                            }
                          );
                        }
                        },
                      ),
                    ],
                  );
              
              }
            );
            }
        );

        // //TODO: ------------------------ 면회신청 완료 누르면 실행되어야 할 부분
        // Navigator.pop(context);

        //TODO: ------------------------
        // Future.delayed(Duration(milliseconds: 300), () {
        //   bodyController.text = '면회 신청합니다.'; //TextFormField 처음으로 초기화
        // });
      },
      body: ListView(
        children: [
          //TODO: 날짜, 할말(메모) 만들기
          text('날짜'),
          SelectedDatePage(),
          text('방문 시간'),
          SelectedTimePage(),
          text('할 말'),
          textFormField(),
        ],
      ),
    );
      
  }

    //할 말
  Widget textFormField() {
    return Form(
      // padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      key: formKey,
      child: SizedBox(
        height: 200,
        child: TextFormField(
          controller: bodyController,
          maxLines: 100,
          inputFormatters: [LengthLimitingTextInputFormatter(500)], //최대 500글자까지 작성 가능
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.black54),
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
            filled: true,
            fillColor: Color(0xfff2f3f6),
            //fillColor: Colors.greenAccent,
          ),
          onSaved: (value) {
            _text = value!;
          }
        ),
      )
    );
  }

    //글자 출력
  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 6),
      child: Text('$text'),
    );
  }

  
  // //글쓰기 버튼
  // Widget writeButton(){
  //   return FloatingActionButton(
  //     focusColor: Colors.white54,
  //     backgroundColor: themeColor.getColor(),
  //     elevation: 0,
  //     focusElevation: 0,
  //     highlightElevation: 0,
  //     hoverElevation: 0,
  //     onPressed: () { pageAnimation(context, VisitWritePage()); },
  //     child: Icon(Icons.create_rounded, color: Colors.white),
  //   );
  // }

}
