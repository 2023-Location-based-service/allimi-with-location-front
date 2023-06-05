import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'changeCity.dart';

import 'localData.dart';
import 'package:http/http.dart' as http;

const API_KEY = 'AIzaSyAMGh5-F_doU_fTq0DpFFdqz4rKKKy8to8';
const backURI = 'http://15.164.219.215:8080/';

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
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AddHomePage(),
    );
  }
}

localData data = localData();

class AddHomePage extends StatefulWidget {
  const AddHomePage({Key? key}) : super(key: key);

  @override
  State<AddHomePage> createState() => _AddHomePageState();
}

class _AddHomePageState extends State<AddHomePage> {
  late GoogleMapController _controller;
  TextEditingController _textController = TextEditingController();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  List<String> result = [];

  List<String> nursingHomeNameresult = [];
  List<String> nursingHomeAddressresult = [];
  List<bool> nursingHomeSupportresult = [];

  int check = 0; //시/도가 선택되었는지 확인하는 변수
  int city_id = 0;
  String text1 = '시/도 선택';
  String text2 = '지역 선택';
  String searchText = "";
  late var curLat, curLng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('요양원 둘러보기'),
        backgroundColor: Color(0xff5BB193),
      ),
      body: findhome(),
    );
  }

  Widget findhome() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: OutlinedButton(
                    onPressed: () {
                      _showDialog(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white)),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      //버튼 테두리와 텍스트 사이에 공백
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //텍스트와 아이콘 배치
                        children: [
                          Text(
                            // '시/도 선택',
                            text1,
                            textScaleFactor: 1.1,
                            style: TextStyle(color: Colors.black,),
                          ),
                          Icon(Icons.keyboard_arrow_down_sharp, size: 18,
                            color: Colors.black,)
                        ],
                      ),
                    ),

                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 10,
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
                                        child: Text("확인"),
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
                        _showDialog2(context);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white)),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // '지역 선택',
                            text2,
                            textScaleFactor: 1.1,
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(Icons.keyboard_arrow_down_sharp, size: 18,
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
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(5)
                    ),
                    controller: _textController,
                    // onSubmitted: _handleSubmitted,
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // _handleSubmitted(_textController.text);
                      setState(() {
                        nursingHomeNameresult = [];
                        nursingHomeAddressresult = [];
                        nursingHomeSupportresult = [];
                        markers = {};
                        searchText = _textController.text;
                        // _textController.clear();
                      });
                      getSearchInfo(searchText);
                    },
                  ),
                )

              ],
            ),
            // child: TextField(
            //   decoration: InputDecoration(
            //       hintText: '요양원 이름, 주소로 검색', //글자를 입력하면 사라진다.
            //       // icon: Icon(Icons.search),
            //       border: OutlineInputBorder(),
            //       contentPadding: EdgeInsets.all(5)
            //   ),
            //   // controller: _textController,
            //   // onChanged: (text) {
            //   //   searchText = text;
            //   // },
            // ),
          ),
          map(context),
          Divider(),
          list()
        ],
      ),
    );
  }

  Widget setupAlertDiaload() {
    return Container(
      height: 400,
      width: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.placedata.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              place1(index),
            ],
          );
        },
      ),
    );
  }

  Future _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('시/도 선택'),
            content: setupAlertDiaload(),
          );
        }
    );
  }

  Widget place1(int index) {
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
            city_id = index;
            text1 = data.placedata[index];
            text2 = '지역 선택';
          });
        });
  }

  //result에 눌린 시/도에 해당되는 지역들 넣어주기
  void onWhereTap(int index) {
    switch (index) {
      case 0:
        result = data.p1; break;
      case 1:
        result = data.p2; break;
      case 2:
        result = data.p3; break;
      case 3:
        result = data.p4; break;
      case 4:
        result = data.p5; break;
      case 5:
        result = data.p6; break;
      case 6:
        result = data.p7; break;
      case 7:
        result = data.p8; break;
      case 8:
        result = data.p9; break;
      case 9:
        result = data.p10; break;
      case 10:
        result = data.p11; break;
      case 11:
        result = data.p12; break;
      case 12:
        result = data.p13; break;
      case 13:
        result = data.p14; break;
      case 14:
        result = data.p15; break;
      case 15:
        result = data.p16; break;
      case 16:
        result = data.p17; break;
      default:
        break;
    }
  }

  //지역 선택에 관한 함수
  Widget setupAlertDiaload2() {
    return Container(
      height: result.length >= 8? 400: (50 * result.length).toDouble(),
      width: 300,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: result.length,
          itemBuilder: (BuildContext context, int index2) {
            return Column(
                children: [
                  place2(index2),
                ]
            );
          },
        ),
      ),
    );
  }

  Future _showDialog2(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('지역 선택'),
            content: setupAlertDiaload2(),
          );
        }
    );
  }

  Widget place2(int index2) {
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
            markers = {};
          });
          var city = changeCity().change(city_id);
          getInfo(city!, result[index2]);
    });
  }

  Future<void> getCurAddress(double curLat, double curLng) async {
    String gpsUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${curLat},${curLng}&key=${API_KEY}&language=ko';

    http.Response response = await http.get(Uri.parse(gpsUrl));
    String responseBody = utf8.decode(response.bodyBytes);
    String address = jsonDecode(responseBody)['results'][0]['formatted_address'];
    var split = address.split(' ');
    String? city = split[1];
    String region = split[2];

    getInfo(city!, region);

  }

  Future<void> getInfo(String city, String region) async {
    print(city);
    print(region);
    http.Response response = await http.post(
      Uri.parse(backURI + 'find'),
      headers: <String, String> {
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
        headers:  <String, String> {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    if (response.statusCode == 200) {
      var viewResponseBody = utf8.decode(viewResponse.bodyBytes);
      var viewLat = jsonDecode(viewResponseBody)['results'][0]['geometry']['location']['lat'];
      var viewLng = jsonDecode(viewResponseBody)['results'][0]['geometry']['location']['lng'];

      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(responseBody);
      var name, address, lat, lng, support;
      for (int i=0; i< list.length; i++) {
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: name,
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


  Future<void> getSearchInfo(String search) async {
    http.Response response = await http.post(
        Uri.parse(backURI + 'search'),
        headers: <String, String> {
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
      for (int i=0; i< list.length; i++) {
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: name,
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
      // getDetailInfo(response, 36.1461382, 128.3934882);
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

  // 구글 지도
  Widget map(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(36.1461382, 128.3934882),
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

  //리스트
  Widget list() {
    return ListView.builder(
        // physics: const NeverScrollableScrollPhysics(), //스크롤바 없애기
        physics: const NeverScrollableScrollPhysics(),
        itemCount: nursingHomeNameresult.length,
        shrinkWrap: true,
        itemBuilder: (context, index3) {
          return InkWell(
            onTap: () {
              print(index3);
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
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          nursingHomeSupportresult[index3]? '지원함' : '지원안함',
                          style: TextStyle(
                              fontSize: 14,
                              height: 1,
                              color: Colors.red
                          ),
                        ),
                      ),
                    )

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