import 'package:flutter/material.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import '/Supplementary/DropdownWidget.dart';

ThemeColor themeColor = ThemeColor();

List<String> textPerson = ['구현진', '권태연', '정혜지', '주효림'];
List<String> imgList = [
  'assets/images/tree.jpg',
  'assets/images/tree.jpg',
  'assets/images/cake.jpg',
  'assets/images/cake.jpg',
  'assets/images/tree.jpg'
];

class WriteAllimPage extends StatefulWidget {
  const WriteAllimPage({Key? key}) : super(key: key);

  @override
  State<WriteAllimPage> createState() => _WriteAllimPageState();
}

class _WriteAllimPageState extends State<WriteAllimPage> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return customPage(
      title: '알림장 작성',
      onPressed: () {
        print('알림장 작성 완료버튼 누름');

        if(this.formKey.currentState!.validate()) {

          //TODO: 알림장 작성 완료 버튼 누르면 실행되어야 하는 부분

          Navigator.pop(context);
        }},
      body: writePost(),
    );
  }

  Widget writePost() {
    return ListView(
      children: [

        //TODO: 수급자 선택
        createPersonCard(),
        SizedBox(height: 8),

        //TODO: 텍스트필드
        createTextField(),
        SizedBox(height: 8),

        //TODO: 아침, 점심, 저녁, 투약 드롭다운버튼
        createDropdown(),
        SizedBox(height: 8),

        //TODO: 사진
        createPicture(),

      ],
    );
  }


  Widget createPersonCard() {
    return GestureDetector(
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
        pageAnimation(context, selectedPersonPage());

      },
    );
  }

  Widget selectedPersonPage() {
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
                    print('수급자 이름 ${textPerson[index]} Tap');

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

  Widget createTextField() {
    return Form(
      key: formKey,
      child: SizedBox(
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
    );
  }

  Widget dropList(String value, Widget page) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          Text('$value'),
          SizedBox(width: 30),
          page,
        ],
      ),
    );
  }

  Widget createDropdown() {
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, size: 18, color: themeColor.getColor()),
                  Text(' 식사 및 투약 기록 선택', style: TextStyle(color: themeColor.getColor())),
                ],
              ),
            ),
            dropList('아침', FirstDropdown()),
            dropList('점심', FirstDropdown()),
            dropList('저녁', FirstDropdown()),
            dropList('투약', SecondDropdown()),
          ],
        )
    );
  }

  Widget createPicture() {
    return Container(
      height: 130,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //사진 추가하는 버튼
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 3),
              child: Row(
                children: [
                  Icon(Icons.camera_alt_rounded, size: 18, color: themeColor.getColor()),
                  Text(' 사진 추가', style: TextStyle(color: themeColor.getColor())),
                ],
              ),
            ),
            onTap: () {

              //TODO: 사진 추가 기능
              print('사진 추가하기 Tap');

              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(leading: Icon(Icons.camera_alt, color: Colors.grey), title: Text('카메라'),
                          onTap: () {
                            //TODO: 카메라 누르면 실행되어야 할 부분
                          },
                        ),
                        ListTile(leading: Icon(Icons.photo_library, color: Colors.grey), title: Text('갤러리'),
                          onTap: () {
                            //TODO: 갤러리 누르면 실행되어야 할 부분
                          },
                        ),
                      ],
                    );
                  }
              );

            },
          ),


          //사진 리스트 출력
          Container(
            height: 96,
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imgList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.fromLTRB(3,8,3,8),
                      child: Stack(
                        children: [
                          ClipRRect(
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
                            child: GestureDetector(
                              child: Container(
                                child: Icon(Icons.cancel_rounded, color: Colors.black54),
                              ),
                              onTap: () {
                                print('사진 삭제 Tap'); //TODO: 사진 삭제 기능
                              },
                            ),
                          ),
                        ],
                      )
                  );
                }
            ),
          ),
        ],
      ),
    );
  }



}
