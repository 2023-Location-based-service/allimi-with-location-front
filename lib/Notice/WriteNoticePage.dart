import 'package:flutter/material.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

List<String> imgList = [
  'assets/images/tree.jpg',
  'assets/images/tree.jpg',
  'assets/images/cake.jpg',
  'assets/images/cake.jpg',
  'assets/images/tree.jpg'
];


class WriteNoticePage extends StatefulWidget {
  const WriteNoticePage({Key? key}) : super(key: key);

  @override
  State<WriteNoticePage> createState() => _WriteNoticePageState();
}

class _WriteNoticePageState extends State<WriteNoticePage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return customPage(
        title: '공지사항 작성',
        onPressed: () {
          print('공지사항 작성 완료버튼 누름');
          String titleTemp = titleController.text.replaceAll(' ', '');
          String bodyTemp = bodyController.text.replaceAll(' ', '');
          if(titleTemp.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("제목을 입력해주세요.")));
            return;
          }
          if(bodyTemp.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("내용을 입력해주세요.")));
            return;
          }
          Navigator.pop(context);

          //TODO: 공지 작성 완료버튼 누르면 실행되어야 할 부분
          },
        body: ListView(
          children: [

            getTitle(),
            SizedBox(height: 8),
            getBody(),
            SizedBox(height: 8),
            getPicture(),

          ],
        ),
        buttonName: '완료'
    );
  }

  //제목
  Widget getTitle() {
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(
        hintText: '제목',
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  //내용
  Widget getBody() {
    return SizedBox(
      width: double.infinity,
      height: 430,
      child: TextFormField(
        maxLines: 1000,
        controller: bodyController,
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요',
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }


  //사진
  Widget getPicture() {
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
