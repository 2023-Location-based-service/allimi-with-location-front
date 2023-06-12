import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer buffer = StringBuffer();
    String value = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    //최대 입력 가능한 글자 개수
    if (value.length > 11) {
      value = value.substring(0, 11);
    }

    if (value.startsWith("02")) { //02로 시작할 경우
      for (int i = 0; i < value.length; i++) {
        if (i == 2 || i == 6) buffer.write('-');
        buffer.write(value[i]);
      }
    } else {
      if (value.length > 10) { //000-0000-0000
        for (int i = 0; i < value.length; i++) {
          if (i == 3 || i == 7) buffer.write('-');
          buffer.write(value[i]);
        }
      } else { //000-000-0000
        for (int i = 0; i < value.length; i++) {
          if (i == 3 || i == 6) buffer.write('-');
          buffer.write(value[i]);
        }
      }
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class PhoneNumberFormatter {
  static String format(String phoneNum) {
    if (phoneNum.length == 10) {
      if (phoneNum.startsWith('02')) {
        return '${phoneNum.substring(0, 2)}-${phoneNum.substring(2, 6)}-${phoneNum.substring(6)}';
      } else {
        return '${phoneNum.substring(0, 3)}-${phoneNum.substring(3, 6)}-${phoneNum.substring(6)}';
      }
    } else if (phoneNum.length == 11) {
      return '${phoneNum.substring(0, 3)}-${phoneNum.substring(3, 7)}-${phoneNum.substring(7)}';
    } else {
      return "올바른 전화번호가 아닙니다";
    }
  }
}