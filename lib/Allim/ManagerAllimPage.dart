import 'dart:convert';

import 'package:flutter/material.dart';
import '/Allim/WriteAllimPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'ManagerSecondAllimPage.dart';
import '/AllimModel.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

class ManagerAllimPage extends StatefulWidget {

  const ManagerAllimPage({
    Key? key,
    required this.userRole,
    required this.residentId
  }) : super(key: key);

  final String userRole;
  final int residentId;

  @override
  State<StatefulWidget> createState() {
    return ManagerAllimPageState();
  }
}
class ManagerAllimPageState extends State<ManagerAllimPage>{
  String _userRole = '';
  int _residentId = 0;
  List<Map<String, dynamic>> _noticeList = [];

  Future<void> getNotice(int residentId) async {
      debugPrint("@@@@@ 공지사항 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl + "notices/" + residentId.toString()),
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
    _residentId = widget.residentId;
    getNotice(_residentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('알림장'),
      ),
      body: managerlist(),
      floatingActionButton: _getFAB()
    );
  }

  Widget _getFAB() {

    if (_userRole == 'PROTECTOR')
      return Container();
    else
      return FloatingActionButton(
      onPressed: () async{
        //글쓰기 화면으로 이동
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WriteAllimPage()),
        );

        getNotice(_residentId);
      },
      child: const Icon(Icons.create),
    );

  }

//시설장 및 직원 알림장 목록
  Widget managerlist() {
    return ListView(
      children: [
        ListView.separated(
          itemCount: _noticeList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){


            if (_noticeList != null && _noticeList.length != 0) {
              List<String> imgList = List<String>.from(_noticeList[index]['imageUrl']);
              
              return Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          width: double.infinity,
                          height: 130,
                          padding: EdgeInsets.only(top: 5,left: 1,right: 1),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //어떤 보호자에게 썼는지
                                    Container(
                                      child: Text(
                                        _noticeList[index]['resident_name'] + " 입소자님",
                                        style: TextStyle(fontSize: 12,),
                                      ),
                                    ),
                                    //언제 썼는지
                                    Container(
                                      child: Text(
                                        _noticeList[index]['create_date'].toString().substring(0, 10).replaceAll('-', '.'),
                                        style: TextStyle(fontSize: 10,)
                                        
                                      ),
                                    ),
                                    Spacer(),
                                    //세부내용(너무 길면 ...로 표시)
                                    Container(
                                        padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                                        child: Text(
                                          _noticeList[index]['content'],
                                          style: TextStyle(fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        )
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              //이미지
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
                        ),
                      ],
                    ),
                    onTap: (){
                      pageAnimation(context, ManagerSecondAllimPage(noticeId: _noticeList[index]['noticeId'], userRole: _userRole));
              
                    },
                  ),
              );

            }
              
            
            else 
              return Container();
          
          }, separatorBuilder: (BuildContext context, int index) => const Divider(height: 9, color: Color(0xfff8f8f8),),  //구분선(height로 상자 사이 간격을 조절)
        ),

      ],

    );
          
        
      
    
  }
}