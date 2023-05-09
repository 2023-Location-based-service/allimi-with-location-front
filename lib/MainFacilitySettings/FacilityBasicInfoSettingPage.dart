import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ResidentProvider.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;

String backendUrl = "http://52.78.62.115:8080/v2/";

//시설 기본정보 설정 화면

class FacilityBasicInfoPage extends StatefulWidget {
  const FacilityBasicInfoPage({Key? key}) : super(key: key);

  @override
  State<FacilityBasicInfoPage> createState() => _FacilityBasicInfoPageState();
}
class _FacilityBasicInfoPageState extends State<FacilityBasicInfoPage> {
  static List<Map<String, dynamic>> _facilityList = [];

  Future<void> getFacilityInfo() async {
    http.Response response = await http.get(
        Uri.parse(backendUrl + "facilities/admin/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _facilityList =  parsedJson;
    });
  }

  @override
  void initState() {
    super.initState();
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
    return Container(
      child: Consumer<ResidentProvider>(
        builder: (context, residentProvider, child){
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _facilityList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  if(_facilityList[index]['id']==residentProvider.facility_id)
                    Container(
                        padding: EdgeInsets.all(18),
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
                              child: Text(_facilityList[index]['name'], textScaleFactor: 1.2,),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xfff2f3f6),width: 2)
                              ),
                            ),
                            Container(  //전화번호
                              child: Text(_facilityList[index]['tel'], textScaleFactor: 1.2,),
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
                        padding: EdgeInsets.all(18),
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
                              child: Text(_facilityList[index]['address'], textScaleFactor: 1.2,),
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
          );
        },
      ),
    );
  }
}