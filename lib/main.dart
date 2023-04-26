import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:test_data/AddHomePage.dart';
import 'package:test_data/ApprovedPage.dart';
import 'package:test_data/LoginPage.dart';
import 'package:test_data/domain/ResidentInfo.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'Supplementary/ThemeColor.dart';
import 'MainPage.dart';
import 'NotificationPage.dart';
import 'SetupPage.dart';


ThemeColor themeColor = ThemeColor();

void main() {
  runApp(
    //Provider 등록
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ResidentProvider())
      ],
          child: const MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child){
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(data: data.copyWith(textScaleFactor: 1.05), child: child!);
      },
      title: '요양원 알리미',
      theme: ThemeData(
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: Color(0xfff8f8f8), //기본 배경색
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'NotoSans', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.5), //앱바 텍스트 색상
          backgroundColor: Colors.white, //앱바 배경색
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer2<UserProvider, ResidentProvider> (
          builder: (context, userProvider,residentProvider, child) {
            if (userProvider.uid == 0) {
              return LoginPage();
              // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              //   return LoginPage();
              //
              // })
            } else{
              return FutureBuilder(
                //입소자 정보 다 주세요
                  future: fetchResidentInfo(userProvider.uid, context),
                  builder: (context, snap) {
                    if (residentProvider.approved == 2) {
                      print('승인이 안돼ㅌㅌㅌㅌ');
                      return ApprovedPage();
                    } else if (residentProvider.approved == 1){
                      print('메인가자ㅌㅌㅌㅌ');
                      return Scaffold(
                        body: getPage(),
                        bottomNavigationBar: Container(
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12, width: 0.5))),
                          child: BottomNavigationBar(
                            onTap: (index) {
                              setState(() {
                                _curIndex = index;
                              });
                            },
                            currentIndex: _curIndex,
                            unselectedItemColor: Colors.grey,
                            selectedItemColor: themeColor.getColor(),
                            elevation: 0,
                            backgroundColor: Colors.white,
                            selectedFontSize: 12,
                            items: [
                              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '홈'),
                              BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: '내 소식'),
                              BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: '설정'),
                            ],
                          ),
                        ),
                      );
                    } else{
                      return LoginPage();
                    }
              });
            }
            }
      ),
    );
  }

  Widget getPage() {
    Widget page;
    switch(_curIndex) {
      case 0: page = MainPage(); break;
      case 1: page = NotificationPage(); break;
      case 2: page = SetupPage(); break;
      default: page = MainPage(); break;
    }
    return page;
  }
}


Future<ResidentInfo> fetchResidentInfo(int user_id, context) async {
  // final response = await http.get(
  //     Uri.parse('http://43.201.27.95:8080/v1/users/1'),
  //     headers: {'Accept-Charset': 'utf-8'});
  // final jsonResponse = jsonDecode(Utf8Decoder().convert(response.bodyBytes));

  // if (response.statusCode == 200) {
  //   return UserInfo.fromJson(jsonResponse);
  // } else {
  //   throw Exception('Failed to load UserInfo');
  // }

  //더미 데이터
  String response = jsonEncode({
    "count": 2,
    "userListDTO": [
      {
        "resident_id": 1,
        "facility_id": 1,
        "facility_name": "금오요양원",
        "resident_name": "할머니",
        "userRole": "PROTECTOR",
        "is_approved": 2, //2=falise
      },
      {
        "resident_id": 3,
        "facility_id": 1,
        "facility_name": "금오요양원",
        "resident_name": "권태연",
        "userRole": "MANAGER",
        "is_approved": 1,
      }
    ]
  });

  final jsonResponse = jsonDecode(response);

  ResidentInfo residentInfo = new ResidentInfo(resident_id: 0, facility_id: 0, facility_name: '', resident_name: '', userRole: '', approved: 0);
  // print(jsonResponse['count']);
  // print(jsonResponse['count'].toString());
  // print(jsonResponse['count'].runtimeType);

  if(jsonResponse['count']==0){
    //시설 선택화면으로 이동
    print('시설 선택화면으로 이동');

    return residentInfo;
  }
  else if(jsonResponse['count']>0){
    for(int i=0;i<jsonResponse['count'];i++){
      // print("@@@@@@@@@@@@@");
      // print(jsonResponse['userListDTO'][i]['is_approved']);
      // print(jsonResponse['userListDTO'][i]['is_approved'].toString());
      // print(jsonResponse['userListDTO'][i]['is_approved'].runtimeType);

      //승인된 입소자가 존재
      if(jsonResponse['userListDTO'][i]['is_approved']==1){
        residentInfo = ResidentInfo.fromJson(jsonResponse['userListDTO'][i]);
        await setResidentProvider(context, residentInfo);
        //print('메인화면으로 이동');
        return residentInfo;
      }
    }
  }
  //승인 대기 화면으로 이동
  print(residentInfo.approved);

  residentInfo = ResidentInfo.fromJson(jsonResponse['userListDTO'][0]);

  print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  //print(jsonResponse['userListDTO'][0]['is_approved']);
  print(residentInfo.approved);
  await setResidentProvider(context, residentInfo);
  print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  return residentInfo;
}

Future<void> setResidentProvider(context, ResidentInfo residentInfo) async{
  Provider.of<ResidentProvider>(context, listen:false)
      .setInfo(residentInfo.resident_id, residentInfo.facility_id, residentInfo.facility_name, residentInfo.resident_name, residentInfo.userRole,residentInfo.approved);

}

