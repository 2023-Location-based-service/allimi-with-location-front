import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int uid = 0;
  String urole ='';
  String loginid ='';
  String utell = '';
  String name = '';

  void setInfo(uid, urole, loginid, utell, name) {
    this.uid = uid;
    this.urole = urole;
    this.loginid = loginid;
    this.utell = utell;
    this.name = name;

    notifyListeners();
  }

//TODO 로그아웃
}
