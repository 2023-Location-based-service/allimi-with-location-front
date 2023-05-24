import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_data/Backend.dart';
//시설 기본정보 설정 화면

class FacilityBasicInfoPage extends StatefulWidget {
  const FacilityBasicInfoPage({Key? key, required this.facilityId}) : super(key: key);
  final int facilityId;

  @override
  State<FacilityBasicInfoPage> createState() => _FacilityBasicInfoPageState();
}
class _FacilityBasicInfoPageState extends State<FacilityBasicInfoPage> {
  int _facilityId = 0;
  Map<String, dynamic> _facilityInfo = {};

  Future<void> getFacilityInfo() async {
    debugPrint("@@@@시설 정보 받아오기 백엔드");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "facilities/" + _facilityId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);

    setState(() {
      _facilityInfo =  parsedJson;
    });
  }

  @override
  void initState() {
    super.initState();
    _facilityId = widget.facilityId;
    getFacilityInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('시설 기본 정보')),
      body: appSetting(),
    );
  }

  Widget appSetting(){
    if (_facilityInfo.length == 0) {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator()));
    } else {
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      text('시설 정보'),
                      myDetailBox(_facilityInfo['name']), //시설 이름
                      myDetailBox(_facilityInfo['tel']),  //전화번호
                    ],
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    text('시설 주소'),
                    myDetailBox(_facilityInfo['address']), //시설 주소
                  ],
                )
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    text('시설장 이름'),
                    myDetailBox(_facilityInfo['fm_name']),  //시설 이름
                  ],
                )
              ),
            ],
          );
        }
      )
      );
    }
  }
  Widget text(String text) {
    return Container(
      child: Text('$text',style: TextStyle(fontWeight: FontWeight.bold),),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          border: Border.all(color: Color(0xfff2f3f6),width: 3)
      ),
    );
  }

  Widget myDetailBox(String text) {
    return Container(
      child: Text('$text'),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xfff2f3f6),width: 2)
      ),
    );
  }
}