import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('요양원 알리미')),
        body: ListView(
          children: [
            Text('이미지 잘 출력되는지 확인'),
            Container(
              child: Image.asset('assets/images/zudah.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
