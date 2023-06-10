import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Supplementary/CustomClick.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../Backend.dart';
import '../Supplementary/ThemeColor.dart';
import 'ChangeCity.dart';
import 'LocalData.dart';
import 'package:http/http.dart' as http;

const API_KEY = 'AIzaSyAMGh5-F_doU_fTq0DpFFdqz4rKKKy8to8';

ThemeColor themeColor = ThemeColor();
localData data = localData();

class SearchFacility extends StatefulWidget {
  const SearchFacility({Key? key}) : super(key: key);

  @override
  State<SearchFacility> createState() => _SearchFacilityState();
}

class _SearchFacilityState extends State<SearchFacility> {
  final GlobalKey scrollKey = GlobalKey(); // 스크롤 키 생성
  final formKey = new GlobalKey<FormState>();
  CheckClick checkClick = new CheckClick();
  late GoogleMapController _controller;
  TextEditingController _textController = TextEditingController();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('요양원 둘러보기', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: themeColor.getColor()),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              key: scrollKey,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  pickButton(), // 시도, 지역 선택 버튼
                  SizedBox(height: 5,),
                  textSearch(), // 검색
                ],
              ),
            ),

            map(context), // 지도
            SizedBox(height: 10),
            list() // 리스트 출력

          ],
        ),
      ),
      floatingActionButton: upButton(),
    );
  }

  //시·도 선택, 지역 선택 버튼
  Widget pickButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 15,
            child: OutlinedButton(
              onPressed: () {
                _searchCity(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.transparent)
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10), //버튼 테두리와 텍스트 사이에 공백
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(text1, textScaleFactor: 1.1, style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis),
                    ), // 시/도 선택
                    Icon(Icons.keyboard_arrow_down_sharp, size: 18, color: Colors.black,),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 15,
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
                            TextButton(
                                child: Text("확인", style: TextStyle(color: themeColor.getMaterialColor())),
                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }
                            ),
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
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.transparent)
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text2, textScaleFactor: 1.1, style: TextStyle(color: Colors.black)), // '지역 선택'
                    Icon(Icons.keyboard_arrow_down_sharp, size: 18, color: Colors.black,)
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }

  //검색
  Widget textSearch() {
    return Form(
      key: formKey,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: '요양원 이름, 주소로 검색',
          hintStyle: TextStyle(fontSize: 15),
          contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          suffixIcon: IconButton(
            icon: Icon(Icons.search_rounded, size: 30, color: Colors.grey),
            onPressed: () {
              if (checkClick.isRedundentClick(DateTime.now())) {
                return;
              }


              if(this.formKey.currentState!.validate()) {

                setState(() {
                  nursingHomeNameresult = [];
                  nursingHomeAddressresult = [];
                  nursingHomeSupportresult = [];
                  markers = {};
                  searchText = _textController.text;
                });
                getSearchInfo(searchText);
              }

            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        controller: _textController,
        validator: (value) => value!.isEmpty ? '내용을 입력하세요' : null,
      ),
    );
  }

  void onWhereTap(int index) {
    switch (index) {
      case 0: result = data.p1; break;
      case 1: result = data.p2; break;
      case 2: result = data.p3; break;
      case 3: result = data.p4; break;
      case 4: result = data.p5; break;
      case 5: result = data.p6; break;
      case 6: result = data.p7; break;
      case 7: result = data.p8; break;
      case 8: result = data.p9; break;
      case 9: result = data.p10; break;
      case 10: result = data.p11; break;
      case 11: result = data.p12; break;
      case 12: result = data.p13; break;
      case 13: result = data.p14; break;
      case 14: result = data.p15; break;
      case 15: result = data.p16; break;
      case 16: result = data.p17; break;
      default: break;
    }
  }

  // 시·도 선택
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
              height: result.length >= 8? 400: (50 * result.length).toDouble(),
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

  // 선택한 지역의 요양원을 지도에 출력 / 청: 시청이나 군청 기준
  Future<void> getInfo(String city, String region) async {
    http.Response response = await http.post(
      Uri.parse(Backend.getUrl() + 'find'),
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
      var name, address, lat, lng, support, phone;
      for (int i=0; i< list.length; i++) {
        support = list[i]['support'];
        if (!support)
          continue;
        name = list[i]['name'];
        address = list[i]['address'];
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

  // 요양원 검색 후 지도에 출력
  Future<void> getSearchInfo(String search) async {
    http.Response response = await http.post(
        Uri.parse(Backend.getUrl() + 'search'),
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
    String address = jsonDecode(responseBody)['results'][0]['formatted_address'];
    var split = address.split(' ');
    String? city = split[1];
    String region = split[2];

    getInfo(city!, region);
  }

  // 구글 지도
  Widget map(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(37.566678, 126.978411),
            zoom: 15.0
        ),
        myLocationButtonEnabled: true,
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

  //리스트 TODO: 지역 선택 후 주소 검색하면 빈 컨테이너가 나옴;
  Widget list() {
    if (nursingHomeNameresult.length == 0) {
      return Container();

      //   Column(
      //   children: [
      //     Icon(Icons.error_outline_rounded, color: Colors.grey, size: 40,),
      //     Text('검색된 결과가 없습니다', style: TextStyle(color: Colors.grey),),
      //   ],
      // );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: 5, left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_rounded, size: 18, color: themeColor.getColor()),
                SizedBox(width: 5,),
                Flexible(
                    child: Text('현재 요양원 알리미를 이용 중인 곳만 표시됩니다', style: TextStyle(color: themeColor.getColor(), fontWeight: FontWeight.w500))
                ),
              ],
            ),
            SizedBox(height: 3),
            Divider(thickness: 0.5),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: nursingHomeNameresult.length,
                shrinkWrap: true,
                itemBuilder: (context, index3) {
                  return nursingHomeSupportresult[index3]
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 5,),
                          Flexible(child: Text(nursingHomeNameresult[index3], style: TextStyle(fontWeight: FontWeight.w500), maxLines: 2)) //요양원 이름
                        ],
                      ),
                      Text(nursingHomeAddressresult[index3],maxLines: 2), //요양원 주소
                      Row(
                        children: [
                          SizedBox(width: 5,),
                          Flexible(child: Text(nursingHomePhone[index3], maxLines: 2)) //요양원 전화번호
                        ],
                      ),
                      Divider(thickness: 0.5,)

                    ],
                  )
                      : Container();
                }
            ),
          ],
        ),
      );
    }
  }

  // 상단으로 가는 버튼
  Widget upButton() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1)
                ),
                child: FloatingActionButton(
                  heroTag: "upper",
                  tooltip: "맨 위로",
                  onPressed: () {
                    Scrollable.ensureVisible(
                        scrollKey.currentContext!,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  focusColor: Colors.white54,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  child: const Icon(Icons.arrow_upward_rounded, color: Colors.black,),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}