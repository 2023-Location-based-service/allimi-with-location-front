import 'package:flutter/material.dart';

class NoticeTempProvider with ChangeNotifier {
  String tag = '공지사항';

  void setTag(medication) {
    this.tag = tag;
  }

  void getData() {
    notifyListeners();
  }

}