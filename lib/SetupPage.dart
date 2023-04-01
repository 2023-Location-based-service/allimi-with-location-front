import 'package:flutter/material.dart';
import 'Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('설정', textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(child: Text('설정 페이지')),
    );
  }
}
