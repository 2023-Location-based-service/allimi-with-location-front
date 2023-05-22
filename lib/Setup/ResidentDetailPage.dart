import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ResidentProvider.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;

import 'package:test_data/Backend.dart';
//시설 기본정보 설정 화면

class ResidentDetailPage extends StatefulWidget {
  const ResidentDetailPage({Key? key, required this.residentId}) : super(key: key);
  final int residentId;

  @override
  State<ResidentDetailPage> createState() => _ResidentDetailPageState();
}
class _ResidentDetailPageState extends State<ResidentDetailPage> {
  int _residentId = 0;
  Map<String, dynamic> _residentInfo = {};

  Future<void> getFacilityInfo() async {
    debugPrint("@@@@입소자 상세정보 받아오기 백엔드");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + 'nhResidents/' + _residentId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);

    setState(() {
      _residentInfo =  parsedJson;
    });
  }

  @override
  void initState() {
    super.initState();
    _residentId = widget.residentId;
    getFacilityInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children:[
            Text('입소자 상세 정보'),
            Spacer(),
            OutlinedButton(
              onPressed: () {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditAllimPage(noticeId: _noticeId, noticeDetail: _noticeDetail, imageUrls: _imageUrls,facility_id: residentProvider.facility_id,)),
                // );
                // getNoticeDetail();
              },
              child: Text('수정',style: TextStyle(color: Colors.grey))
          )
          ] 
        ),
        
      ),
      body: appSetting(),
    );
  }

  Widget appSetting(){
    if (_residentInfo.length == 0) {
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

                text('입소자 성함'),
                myProfileBox(_residentInfo['resident_name']), //입소자 이름

                text('생일'),
                myProfileBox(_residentInfo['birth']), //입소자 생일
                
                text('건강정보'),
                myProfileBox('건강정보 데이터?'), //건강정보?

            ],
          );
        }
      )
      );
    }
  }

  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
      child: Text('$text',
        style: TextStyle(fontWeight: FontWeight.bold),
        //textScaleFactor: 1.2,
      ),
    );
  }

  Widget myProfileBox(String text) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$text', textScaleFactor: 1.2),
              ],
            )
        )
    );
  }
}