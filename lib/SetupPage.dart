import 'package:flutter/material.dart';
import 'Supplementary/ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

List<String> textPerson = ['구현진', '권태연', '정혜지', '주효림'];
List<String> imgList = [
  'assets/images/tree.jpg',
  'assets/images/tree.jpg',
  'assets/images/cake.jpg',
  'assets/images/cake.jpg',
  'assets/images/tree.jpg'
];

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [

          //TODO: 위젯 작성
          appProfile(),
          appNotification(),
          Divider(thickness: 7, color: Colors.white),
          appLogout(),
          appTest(),

        ],
      ),
    );
  }


  Widget appProfile() {
    return ListTile(
        title: Text('내 정보'),
        leading: Icon(Icons.person_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myProfile());
        });
  }

  Widget appNotification() {
    return ListTile(
        title: Text('알림 설정'),
        leading: Icon(Icons.notifications_active_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myNotification());
        });
  }

  Widget appLogout() {
    return ListTile(
        title: Text('로그아웃'),
        leading: Icon(Icons.logout_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, myLogout());
        });
  }

  Widget appTest() {
    return ListTile(
        title: Text('알림장 글쓰기'),
        leading: Icon(Icons.logout_rounded, color: Colors.grey),
        onTap: (){
          pageAnimation(context, writePage());
        });
  }


  Widget myProfile() {
    return Scaffold(body: Text('테스트22'));
  }

  Widget myNotification() {
    return Scaffold(body: Text('테스트'));
  }

  Widget myLogout() {
    return Scaffold(body: Text('테스트'));
  }



  /* TODO: 메뉴화면 테스트----------------------------------------------------------------- */

  //알림장 글쓰기 페이지
  Widget writePage() {
    return customPage(
        title: '알림장 작성',
        onPressed: () {
          print('알림장 작성 완료버튼 누름');

          if(this.formKey.currentState!.validate()) {

            //TODO: 알림장 작성 완료버튼 누르면 실행되어야 하는 부분

            Navigator.pop(context);
          }},
        body: writePost(), //TODO: 위젯 작성해서 바꾸기
    );
  }

  Widget writePost() {
    return ListView(

      children: [
        //수급자 선택
        GestureDetector(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_circle_rounded, color: Colors.grey, size: 50),
                    SizedBox(width: 8),

                    //TODO: 수급자 선택하기 글자가 바뀌어야 함
                    // 수급자 선택시 ex. 삼족오 님
                    Text('수급자 선택', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
                  ],
                ),
                Icon(Icons.expand_more_rounded, color: Colors.grey),
              ],
            ),
          ),
          onTap: () {

            print('수급자 선택하기 Tap');

            //TODO: 수급자 선택 화면
            pageAnimation(context, selectedPerson());

          },
        ),
        SizedBox(height: 8),

        //TODO: 텍스트필드
        Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 350,
                child: TextFormField(
                  validator: (value) {
                    if(value!.isEmpty) { return '내용을 입력하세요'; }
                    else { return null; }
                  },
                  maxLines: 1000,
                  decoration: const InputDecoration(
                    hintText: '내용을 입력하세요',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.fromLTRB(12,5,12,5),
                color: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text('data'),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: TextFormField(
                        validator: (value) {
                          if(value!.isEmpty) { return '내용을 입력하세요'; }
                          else { return null; }
                        },
                        maxLines: 1000,
                        decoration: const InputDecoration(
                          hintText: '내용을 입력하세요',
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          )
        ),
        SizedBox(height: 8),

        

        //TODO: 사진
        Container(
          height: 130,
          color: Colors.white,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: imgList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                // width: 100,
                // height: 100,
                margin: EdgeInsets.all(3),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.asset(
                        width: 80,
                        height: 80,
                        imgList[index], //TODO: 사진 리스트
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 3,
                      right: 3,
                      child: Container(
                        child: Icon(Icons.cancel_rounded, color: Colors.black54),
                      ),
                    ),

                  ],
                )
              );
            },
          ),
        ),



      ],
    );
  }




  Widget selectedPerson() {
    return Scaffold(
      appBar: AppBar(title: Text('수급자 선택')),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: Colors.grey),
                SizedBox(width: 5),
                Text('알림장을 전송할 수급자를 선택해주세요.'),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: textPerson.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.person_rounded, color: Colors.grey),
                  title: Row(
                    children: [
                      Text(textPerson[index]), //TODO: 수급자 이름 리스트
                      Text(' 님'),
                    ],
                  ),
                  onTap: () {
                    print('$index 수급자 이름 Tap');

                    // TODO: 수급자 선택 시 처리할 이벤트

                    Navigator.pop(context);

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget personList() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.grey),
              SizedBox(width: 5),
              Text('알림장을 전송할 수급자를 선택해주세요.'),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: textPerson.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.person_rounded, color: Colors.grey),
                title: Row(
                  children: [
                    Text(textPerson[index]), //TODO: 수급자 이름 리스트
                    Text(' 님'),
                  ],
                ),
                onTap: () {
                  print('$index 수급자 이름 Tap');

                  // TODO: 수급자 선택 시 처리할 이벤트

                  Navigator.pop(context);

                },
              );
            },
          ),
        ),


      ],
    );
  }




}