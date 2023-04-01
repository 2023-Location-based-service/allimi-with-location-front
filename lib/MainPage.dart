import 'package:flutter/material.dart';
import 'Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('요양원 알리미', textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(child: Text('홈 페이지')),
    );
  }

}