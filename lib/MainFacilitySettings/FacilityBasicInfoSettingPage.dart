import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ResidentProvider.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
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
      appBar: AppBar(title: Text('시설 기본 정보 설정')),
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
                      Container(
                        child: Text('시설 정보'),
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color(0xfff2f3f6),
                            border: Border.all(color: Color(0xfff2f3f6),width: 3)
                        ),
                      ),
                      Container(  //시설 이름
                        child: Text(_facilityInfo['name']),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xfff2f3f6),width: 2)
                        ),
                      ),
                      Container(  //전화번호
                        child: Text(_facilityInfo['tel']),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xfff2f3f6),width: 2)
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text('시설 주소'),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Color(0xfff2f3f6),
                          border: Border.all(color: Color(0xfff2f3f6),width: 3)
                      ),
                    ),
                    Container(
                      child: Text(_facilityInfo['address']),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xfff2f3f6),width: 2)
                      ),
                    ),
                  ],
                )
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text('시설장 이름'),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Color(0xfff2f3f6),
                          border: Border.all(color: Color(0xfff2f3f6),width: 3)
                      ),
                    ),
                    Container(
                      child: Text(_facilityInfo['fm_name']),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xfff2f3f6),width: 2)
                      ),
                    ),
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
}