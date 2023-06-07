import 'package:google_maps_flutter/google_maps_flutter.dart';

class changeCity {

  String? change(int idx) {
    switch(idx) {
      case 0: return "서울특별시";
      case 1: return "부산광역시";
      case 2: return "대구광역시";
      case 3: return "인천광역시";
      case 4: return "광주광역시";
      case 5: return "대전광역시";
      case 6: return "울산광역시";
      case 7: return "세종특별자치시";
      case 8: return "경기도";
      case 9: return "강원도";
      case 10: return "충청북도";
      case 11: return "충청남도";
      case 12: return "전라북도";
      case 13: return "전라남도";
      case 14: return "경상북도";
      case 15: return "경상남도";
      case 16: return "제주특별자치도";
    }
  }

  String? change2(String str) {
    switch(str) {
      case '서울특별시': return "seoul";
      case '부산광역시': return "busan";
      case '대구광역시': return "daegu";
      case '인천광역시': return "incheon";
      case '광주광역시': return "gwangju";
      case '대전광역시': return "daejeon";
      case '울산광역시': return "ulsan";
      case '세종특별자치시': return "sejong";
      case '경기도': return "gyeonggido";
      case '강원도': return "gangwondo";
      case '충청북도': return "chungcheongbukdo";
      case '충청남도': return "chungcheongnamdo";
      case '전라북도': return "jeollabukdo";
      case '전라남도': return "jeollanamdo";
      case '경상북도': return "gyeongsangbukdo";
      case '경상남도': return "gyeongsangnamdo";
      case '제주특별자치도': return "jejudo";
    }
  }

  // LatLng cityLatLng(String str) {
  //   switch(str) {
  //     case "seoul": return LatLng(, );
  //     case "busan": return LatLng(, );
  //     case "daegu": return LatLng(, );
  //     case "incheon": return LatLng(, );
  //     case "gwangju": return LatLng(, );
  //     case "daejeon": return LatLng(, );
  //     case "ulsan": return LatLng(, );
  //     case "sejong": return LatLng(, );
  //     case "gyeonggido": return LatLng(, );
  //     case "gangwondo": return LatLng(, );
  //     case "chungcheongbukdo": return LatLng(, );
  //     case "chungcheongnamdo": return LatLng(, );
  //     case "jeollabukdo": return LatLng(, );
  //     case "jeollanamdo": return LatLng(, );
  //     case "gyeongsangbukdo": return LatLng(, );
  //     case "gyeongsangnamdo": return LatLng(, );
  //     case "jejudo": return LatLng(, );
  //   }
  // }


}