import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

class ManagerRequestPage extends StatefulWidget {
  const ManagerRequestPage({Key? key}) : super(key: key);

  @override
  State<ManagerRequestPage> createState() => _ManagerRequestPageState();
}

class _ManagerRequestPageState extends State<ManagerRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('면회 신청')),
      body: Text('면회 신청 리스트 출력'),
    );
  }






}
