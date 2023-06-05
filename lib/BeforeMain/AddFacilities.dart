import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Supplementary/CustomWidget.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Supplementary/ThemeColor.dart';
import '../../Supplementary/CustomClick.dart';
import 'package:test_data/Backend.dart';
import '../location/changeCity.dart';
import '../location/localData.dart';

const API_KEY = 'AIzaSyAMGh5-F_doU_fTq0DpFFdqz4rKKKy8to8';

ThemeColor themeColor = ThemeColor();
localData data = localData();

class AddFacilities extends StatefulWidget {
  const AddFacilities({Key? key, required this.uid}) : super(key: key);
  final int uid;

  @override
  State<AddFacilities> createState() => _AddFacilitiesState();
}

class _AddFacilitiesState extends State<AddFacilities> {
  late GoogleMapController _controller;
  TextEditingController _textController = TextEditingController();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CheckClick checkClick = new CheckClick();

  List<String> result = [];
  List<String> nursingHomeNameresult = [];
  List<String> nursingHomeAddressresult = [];
  List<String> nursingHomePhone = [];
  List<bool> nursingHomeSupportresult = [];

  int check = 0; //시/도가 선택되었는지 확인하는 변수
  int city_id = 0;
  String text1 = '시/도 선택';
  String text2 = '지역 선택';
  String searchText = "";
  late var curLat, curLng;


  final formKey = GlobalKey<FormState>();
  String _facilityName = '';
  String _location = '';
  String _number = '';
  String _personName = '';
  int _facilityId = 0;
  late int _uid;
  int _resident_id = 0;

  @override
  void initState() {
    super.initState();
    _uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    // return ChooseFacility();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🏡', style: GoogleFonts.notoColorEmoji(fontSize: 55)),
                  SizedBox(height: 10),
                  Text('시설을 등록해주세요', textScaleFactor: 1.5,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 20,
                          child: OutlinedButton(
                            onPressed: () {
                              _searchCity(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white)),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    // '시/도 선택',
                                    text1,
                                    textScaleFactor: 1.1,
                                    style: TextStyle(color: Colors.black,),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp, size: 18,
                                    color: Colors.black,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 20,
                          child: OutlinedButton(
                            onPressed: () {
                              if (check == 0) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext ctx) {
                                      return AlertDialog(
                                        content: Text('시/도를 먼저 선택해주세요!'),
                                        actions: [
                                          Center(
                                            child: TextButton(
                                                child: Text("확인",
                                                    style: TextStyle(
                                                        color: themeColor
                                                            .getMaterialColor())),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                );
                              }
                              else {
                                _searchRegion(context);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white)),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    // '지역 선택',
                                    text2,
                                    textScaleFactor: 1.1,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp, size: 18,
                                    color: Colors.black,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '요양원 이름, 주소로 검색',
                              hintStyle: TextStyle(fontSize: 16),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                              ),
                            ),
                            controller: _textController,
                          ),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                nursingHomeNameresult = [];
                                nursingHomeAddressresult = [];
                                nursingHomeSupportresult = [];
                                markers = {};
                                searchText = _textController.text;
                              });
                              getSearchInfo(searchText);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  map(context),
                  Divider(),
                  list()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> facilityRequest(int uid) async {
    debugPrint("@@@@ 시설 추가하는 백엔드 url보냄: " + _personName);
    //입소자추가 post
    http.Response response1 = await http.post(
        Uri.parse(Backend.getUrl() + 'facilities'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "name": _facilityName,
          "address": _location,
          "tel": _number,
          "fm_name": _personName
        })
    );

    debugPrint("@@@@ statusCode: " + response1.statusCode.toString());
    if (response1.statusCode != 200) {
      throw Exception('POST request failed');
    }

    http.Response response2 = await http.post(
        Uri.parse(Backend.getUrl() + 'change'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "name": _facilityName,
          "address": _location,
        })
    );
    debugPrint("@@@@ statusCode: " + response2.statusCode.toString());

    if (response2.statusCode != 200) {
      throw Exception('POST request failed');
    }

    var data = utf8.decode(response1.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);
    _facilityId = parsedJson['facility_id'];

    debugPrint("@@@@ 시설장 resident 추가하는 백엔드 url보냄");

    http.Response response3 = await http.post(
        Uri.parse(Backend.getUrl() + 'nhResidents'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "user_id": uid,
          "facility_id": _facilityId,
          "resident_name": '',
          "birth": '',
          "user_role": 'MANAGER',
          "health_info": ''
        })
    );

    if (response3.statusCode != 200) {
      throw Exception('POST');
    }

    data = utf8.decode(response3.bodyBytes);
    decodedJson = json.decode(data);
    parsedJson = Map<String, dynamic>.from(decodedJson);
    _resident_id = parsedJson['resident_id'];
  }

  void onWhereTap(int index) {
    switch (index) {
      case 0:
        result = data.p1;
        break;
      case 1:
        result = data.p2;
        break;
      case 2:
        result = data.p3;
        break;
      case 3:
        result = data.p4;
        break;
      case 4:
        result = data.p5;
        break;
      case 5:
        result = data.p6;
        break;
      case 6:
        result = data.p7;
        break;
      case 7:
        result = data.p8;
        break;
      case 8:
        result = data.p9;
        break;
      case 9:
        result = data.p10;
        break;
      case 10:
        result = data.p11;
        break;
      case 11:
        result = data.p12;
        break;
      case 12:
        result = data.p13;
        break;
      case 13:
        result = data.p14;
        break;
      case 14:
        result = data.p15;
        break;
      case 15:
        result = data.p16;
        break;
      case 16:
        result = data.p17;
        break;
      default:
        break;
    }
  }

  // 시/도 선택
  Future _searchCity(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('시/도 선택'),
            content: Container(
              height: 400,
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.placedata.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(data.placedata[index]),
                      onTap: () {
                        check = 1; //시/도 선택 여부 확인
                        print(index);
                        onWhereTap(index);
                        Navigator.of(context, rootNavigator: true).pop();
                        setState(() {
                          nursingHomeNameresult = [];
                          nursingHomeAddressresult = [];
                          nursingHomeSupportresult = [];
                          nursingHomePhone = [];
                          city_id = index;
                          text1 = data.placedata[index];
                          text2 = '지역 선택';
                        });
                      });
                },
              ),
            ),
          );
        }
    );
  }

  // 지역 선택
  Future _searchRegion(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('지역 선택'),
            // content: setupAlertDiaload2(),
            content: Container(
              height: result.length >= 8 ? 400 : (50 * result.length)
                  .toDouble(),
              width: 300,
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: result.length,
                  itemBuilder: (BuildContext context, int index2) {
                    return ListTile(
                        title: Text(result[index2]),
                        onTap: () {
                          print(index2);
                          Navigator.of(context, rootNavigator: true).pop();
                          setState(() {
                            text2 = result[index2];
                            nursingHomeNameresult = [];
                            nursingHomeAddressresult = [];
                            nursingHomeSupportresult = [];
                            nursingHomePhone = [];
                            markers = {};
                          });
                          var city = changeCity().change(city_id);
                          getInfo(city!, result[index2]);
                        });
                  },
                ),
              ),
            ),
          );
        }
    );
  }

  // 선택한 지역의 요양원 지도에 출력
  Future<void> getInfo(String city, String region) async {
    http.Response response = await http.post(
        Uri.parse(Backend.getUrl() + 'find'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "city": city,
          "region": region
        })
    );
    String viewPoint = '$city $region청';
    String geocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=${viewPoint}&key=${API_KEY}&language=ko';
    http.Response viewResponse = await http.get(
        Uri.parse(geocodeUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    if (response.statusCode == 200) {
      var viewResponseBody = utf8.decode(viewResponse.bodyBytes);
      var viewLat = jsonDecode(
          viewResponseBody)['results'][0]['geometry']['location']['lat'];
      var viewLng = jsonDecode(
          viewResponseBody)['results'][0]['geometry']['location']['lng'];

      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(responseBody);
      var name, address, lat, lng, support, phone;
      for (int i = 0; i < list.length; i++) {
        name = list[i]['name'];
        address = list[i]['address'];
        support = list[i]['support'];
        phone = list[i]['phone'];
        nursingHomeNameresult.add(name);
        nursingHomeAddressresult.add(address);
        nursingHomeSupportresult.add(support);
        nursingHomePhone.add(phone);
        lat = list[i]['latitude'];
        lng = list[i]['longitude'];
        final MarkerId markerId = MarkerId(name);
        markers[markerId] = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: name,
              onTap: () {
                var index = nursingHomeNameresult.indexOf(markerId.value);
                supportService(context, nursingHomeSupportresult[index], index);
              }
          ),
        );
      }

      setState(() {});

      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(viewLat, viewLng),
          tilt: 0,
          zoom: 13.0,
        ),
      ));
    }
  }

  // 요양원 검색 후 지도에 출력
  Future<void> getSearchInfo(String search) async {
    http.Response response = await http.post(
        Uri.parse(Backend.getUrl() + 'search'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "search_word": search
        })
    );

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(responseBody);
      var name, address, lat, lng, support;
      for (int i = 0; i < list.length; i++) {
        name = list[i]['name'];
        address = list[i]['address'];
        support = list[i]['support'];
        nursingHomeNameresult.add(name);
        nursingHomeAddressresult.add(address);
        nursingHomeSupportresult.add(support);
        lat = list[i]['latitude'];
        lng = list[i]['longitude'];
        final MarkerId markerId = MarkerId(name);
        markers[markerId] = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: name,
              onTap: () {
                var index = nursingHomeNameresult.indexOf(markerId.value);
                supportService(context, nursingHomeSupportresult[index], index);
              }
          ),
        );
      }

      setState(() {});

      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(list[0]['latitude'], list[0]['longitude']),
          tilt: 0,
          zoom: 13.0,
        ),
      ));
    }
  }

  // 현재 위치 구하기
  Future<void> _currentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData? _currentLocation;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // 위치 권한 확인
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.granted) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    curLat = _currentLocation.latitude!;
    curLng = _currentLocation.longitude!;

    getCurAddress(curLat, curLng);
  }

  // 현재 주소 구하기
  Future<void> getCurAddress(double curLat, double curLng) async {
    String gpsUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${curLat},${curLng}&key=${API_KEY}&language=ko';

    http.Response response = await http.get(Uri.parse(gpsUrl));
    String responseBody = utf8.decode(response.bodyBytes);
    String address = jsonDecode(
        responseBody)['results'][0]['formatted_address'];
    var split = address.split(' ');
    String? city = split[1];
    String region = split[2];

    getInfo(city!, region);
  }

  // 구글 지도
  Widget map(BuildContext context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .width,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(37.566678, 126.978411),
            zoom: 15.0
        ),
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
            _currentLocation();
          });
        },
        markers: Set<Marker>.of(markers.values),
        gestureRecognizers: { // 지도 화면 움직이기
          Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()
          )
        },
      ),
    );
  }

  Future<dynamic> supportService(BuildContext context, bool isSupport,
      int index) {
    if (isSupport) {
      return showDialog(
          context: context,
          builder: (BuildContext context1) {
            return AlertDialog(
              content: Text('이미 등록된 시설입니다'),
              insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
              actions: [
                TextButton(
                  child: Text(
                      '확인', style: TextStyle(color: themeColor.getColor())),
                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(
                      themeColor.getColor().withOpacity(0.3))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    }
    else {
      return showDialog(
          context: context,
          barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
          builder: (BuildContext context1) {
            return AlertDialog(
              content: Text('시설 등록을 진행하시겠습니까?'),
              insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
              actions: [
                TextButton(
                  child: Text(
                      '취소', style: TextStyle(color: themeColor.getColor())),
                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(
                      themeColor.getColor().withOpacity(0.3))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                      '확인', style: TextStyle(color: themeColor.getColor())),
                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(
                      themeColor.getColor().withOpacity(0.3))),
                  onPressed: () async {
                    if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                      return;
                    }
                    try {
                      _facilityName = nursingHomeNameresult[index];
                      _location = nursingHomeAddressresult[index];
                      _number = nursingHomePhone[index];
                      _personName =
                          Provider.of<UserProvider>(context, listen: false)
                              .getName();
                      await facilityRequest(_uid);
                      showToast('시설 등록에 성공하였습니다');
                      Provider.of<ResidentProvider>(context, listen: false)
                          .setInfo(
                          _resident_id,
                          _facilityId,
                          _facilityName,
                          '',
                          'MANAGER',
                          '',
                          '');

                      Provider.of<UserProvider>(context, listen: false)
                          .setRole('MANAGER');

                      Provider.of<UserProvider>(context, listen: false)
                          .getData();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } catch (e) {
                      showToast('시설 등록에 실패하였습니다');
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            );
          }
      );
    }
  }

  //리스트
  Widget list() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: nursingHomeNameresult.length,
        shrinkWrap: true,
        itemBuilder: (context, index3) {
          return InkWell(
            onTap: () {
              supportService(context, nursingHomeSupportresult[index3], index3);
            },
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' ' + nursingHomeNameresult[index3],
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                          Text(
                            nursingHomeAddressresult[index3],
                            style: TextStyle(
                                fontSize: 15
                            ),
                            maxLines: 2,
                          ),
                          Text(
                            ' ' + nursingHomePhone[index3],
                            style: TextStyle(
                                fontSize: 15
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        }
    );
  }
}