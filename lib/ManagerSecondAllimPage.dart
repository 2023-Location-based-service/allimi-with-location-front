import 'package:flutter/material.dart';
import 'NoticeModel.dart';
import 'UserAllimPage.dart';

class ManagerSecondAllimPage extends StatefulWidget {
  const ManagerSecondAllimPage({Key? key}) : super(key: key);

  @override
  State<ManagerSecondAllimPage> createState() => _ManagerSecondAllimPageState();
}

class _ManagerSecondAllimPageState extends State<ManagerSecondAllimPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('개인알림장'),
      ),
      body: eachmanager(),

    );
  }

  //시설장 및 직원 알림장(각 목록)
  Widget eachmanager() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '구미요양원 요양보호사',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '2023.03.24',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],

                    ),
                    Spacer(),
                    Container(
                      child: OutlinedButton(
                          onPressed: (){
                            //수정 화면으로 넘어가기
                          },
                          child: Text('수정')
                      ),

                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      //alignment: Alignment.centerRight,
                      child: OutlinedButton(
                          onPressed: (){
                            //삭제 화면으로 넘어가기
                          },
                          child: Text('삭제')
                      ),
                    ),
                  ],
                ),

                //알림장 사진
                Container(
                    margin: EdgeInsets.fromLTRB(0,10,0,20),
                    width: double.infinity,
                    height: 300,
                    child: Container(
                      child: Image.asset('assets/images/tree.jpg', fit: BoxFit.fill,),
                    )
                ),

                //알림장 세부 내용
                Container(
                  margin: EdgeInsets.fromLTRB(0,0,0,40),
                  child: Text(
                    '오늘은 날씨가 좋아서 걷기 운동을 하였습니다.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                //알림장 안에 있는 어르신의 일일정보
                informdata()
              ],
            )
          ],
        )
    );
  }

  //알림장 안에 있는 어르신의 일일정보 함수
  Widget informdata(){
    return Row(
      children: [
        inform('아침','점심','저녁','투약','특이사항'),
        VerticalDivider(),
        inform('전량섭취','전량섭취','전량섭취','진통제','걷기 운동'),
      ],
    );
  }

  Widget inform(String text1, String text2,String text3, String text4,String text5){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$text1'),
        Text('$text2'),
        Text('$text3'),
        Text('$text4'),
        Text('$text5'),

      ],
    );
  }

}




