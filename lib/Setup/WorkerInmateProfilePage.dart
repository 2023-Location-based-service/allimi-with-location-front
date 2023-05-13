import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../provider/UserProvider.dart';
import '../provider/ResidentProvider.dart';

import 'package:test_data/Backend.dart';
String backendUrl = Backend.getUrl();

class WorkerInmateProfilePage extends StatefulWidget {
  const WorkerInmateProfilePage({Key? key, required this.uid, required this.facilityId, required this.residentId}) : super(key: key);

  final int residentId;
  final int uid;
  final int facilityId;

  @override
  State<WorkerInmateProfilePage> createState() => _WorkerInmateProfilePageState();
}

class _WorkerInmateProfilePageState extends State<WorkerInmateProfilePage> {
  late int _residentId;
  late int _userId;
  late int _facilityId;
  List<Map<String, dynamic>> _residentList = [];

  @override
  void initState() {
    super.initState();
    _residentId = widget.residentId;
    _userId = widget.uid;
    _facilityId = widget.facilityId;
    getResident();
  }

  Future<void> getResident() async {
    debugPrint("@@@@@ 유저의 입소자들 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(backendUrl+ 'nhResidents/' + _userId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    if (response.statusCode != 200) {
      throw Exception('POST request failed');
    }

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);

    List<Map<String, dynamic>> parsedJsonList
    = List<Map<String, dynamic>>.from(parsedJson['resident_list']);

    setState(() {
      _residentList = parsedJsonList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
