class PhoneNumberFormatter {
  static String format(String phoneNum) {
    if (phoneNum.length == 10) {
      return '${phoneNum.substring(0, 3)}-${phoneNum.substring(3, 6)}-${phoneNum.substring(6)}';
    } else if (phoneNum.length == 11) {
      return '${phoneNum.substring(0, 3)}-${phoneNum.substring(3, 7)}-${phoneNum.substring(7)}';
    } else {
      return "올바른 전화번호가 아닙니다";
    }
  }
}