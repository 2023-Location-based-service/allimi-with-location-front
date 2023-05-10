import 'package:flutter/material.dart';

class NoticeTempProvider with ChangeNotifier {
  bool trueTag = true;
  bool falseTag = false;

  void setTrueTag(tag) {
    this.trueTag = tag;
  }

  void setFalseTag(tag) {
    this.falseTag = tag;
  }

  void getData() {
    notifyListeners();
  }

}