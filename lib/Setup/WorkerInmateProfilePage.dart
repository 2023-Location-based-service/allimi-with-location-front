//WorkerInmatePage

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Supplementary/PageRouteWithAnimation.dart';
import '../provider/UserProvider.dart';
import '../provider/ResidentProvider.dart';

import 'package:test_data/Backend.dart';

import 'ResidentDetailPage.dart';

class WorkerInmateProfilePage extends StatefulWidget {
  const WorkerInmateProfilePage({Key? key, required this.facilityId, required this.uid, required this.residentId}) : super(key: key);

  final int facilityId;
  final int uid;
  final int residentId;

  @override
  State<WorkerInmateProfilePage> createState() => _WorkerInmateProfilePageState();
}

class _WorkerInmateProfilePageState extends State<WorkerInmateProfilePage> {
  late int _userId;
  late int _facilityId;
  late int _residentId;
  List<Map<String, dynamic>> _residentList = [];

  @override
  void initState() {
    super.initState();
    _userId = widget.uid;
    _facilityId = widget.facilityId;
    _residentId = widget.residentId;
    addInmate();
  }

  Future<void> addInmate() async {
    debugPrint("@@내가 담당하는 입소자 정보 받아오는 백엔드 요청 ");
    var url = Uri.parse(Backend.getUrl() + 'nhResidents/manage/' + _residentId.toString());
    var headers = {'Content-type': 'application/json'};
    final response = await http.get(url, headers: headers);

    debugPrint("@@statusCode: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    List<Map<String, dynamic>> parsedJsonList 
      = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residentList = parsedJsonList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return myInmateProfile();
  }

  //입소자 정보
  Widget myInmateProfile() {
    return Scaffold(
      appBar: AppBar(title: Text('입소자 정보')),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: Colors.grey),
                SizedBox(width: 5),
                Text('현재 내가 담당하고 있는 입소자 목록입니다'),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _residentList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.person_rounded, color: Colors.grey),
                  title: Row(
                    children: [
                      Text('${_residentList[index]['resident_name']} 님'), //TODO: 수급자 이름 리스트
                    ],
                  ),
                  onTap: () async {
                    await awaitPageAnimation(context, ResidentDetailPage(residentId: _residentList[index]['resident_id']));
                    print('입소자 이름 ${_residentList[index]['resident_name']} Tap');

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
