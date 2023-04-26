import 'package:flutter/material.dart';

class ApprovedPage extends StatefulWidget {
  const ApprovedPage({Key? key}) : super(key: key);

  @override
  State<ApprovedPage> createState() => _ApprovedPageState();
}

class _ApprovedPageState extends State<ApprovedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: approvelist(),
    );
  }
  Widget approvelist() {
    return Container(
      child: ListView(
        children: [
          Text('승인 대기 중'),
          Container(
            margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Row(
              children: [
                Text('오미자 님'),
                Text('금오요양원'),

              ],
            ),
          ),
          OutlinedButton(
              onPressed:() {},
              child: Text('새로 등록하기')
          ),
        ],
      ),
    );
  }
}

