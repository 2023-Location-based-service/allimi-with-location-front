import 'package:flutter/material.dart';
import '/Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

List<String> dateList =['2022.12.23','2022.12.24','2022.12.25'];
List<String> titleList =['요양원 공원 공사 안내', '필요 물품 안내', '방역 실시 안내'];
List<String> imgList = [
  'assets/images/tree.jpg',
  'assets/images/tree.jpg',
  'assets/images/cake.jpg'
];

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지사항')),
      body: ListView(
        children: [
          importantNotice(),
          SizedBox(height: 20),

          noticeList(),
        ],
      ),
      //floatingActionButton: ,
    );
  }

  Widget textNotice(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Text('중요', style: TextStyle(color: themeColor.getColor(), fontWeight: FontWeight.bold)),
          const SizedBox(width: 20),
          Container(child: Text(title, overflow: TextOverflow.ellipsis), width: MediaQuery.of(context).size.width * 0.65),
        ],
      ),
    );
  }

  Widget importantNotice() {
    return Column(
      children: [
        textNotice('5월 방역 일정 안내'),
        textNotice('면회 시 주의 사항'),
      ],
    );
  }

  //공지사항 목록
  Widget noticeList() {
    return ListView.separated(
      itemCount: titleList.length, //면회 목록 출력 개수
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          color: Colors.white,
          child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(titleList[index], overflow: TextOverflow.ellipsis),
                          width: MediaQuery.of(context).size.width * 0.5),
                      Text(dateList[index]),
                    ],
                  ),
                  Container(
                      width: 100,
                      height: 100,
                      child: Container(
                        child: Image.asset(imgList[index], fit: BoxFit.fill,),
                      )
                  ),
                ],
              )
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }









}
