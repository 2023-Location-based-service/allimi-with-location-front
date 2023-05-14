import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: const Color(0xff6E6E6E),
    fontSize: 13,
    toastLength: Toast.LENGTH_SHORT,
  );
}