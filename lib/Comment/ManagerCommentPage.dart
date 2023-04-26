import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(title: Text('한마디')),
      body: commentList(),
    );
  }

  List<String> date =['2022.12.23','2022.12.24','2022.12.25','2022.12.23','2022.12.24','2022.12.25'];
  List<String> com =['택배로 간식을 보냈으니 어머니께 드려주세요.','보호사님 오늘도 잘 부탁드립니다.','필요 물품을 택배로 보냈습니다.','택배로 간식을 보냈으니 어머니께 드려주세요.','보호사님 오늘도 잘 부탁드립니다.','필요 물품을 택배로 보냈습니다.'];

  // 한마디 목록
  Widget commentList(){
    return Container(
      child: ListView.separated(
            itemCount: com.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  print(index);
                  showPopup();
                },
                child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      height: 130,
                      padding: EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(date[index]),
                                Icon(Icons.check_box_outline_blank_outlined),
                              ],
                            ),
                            Text(
                              com[index],
                              style: TextStyle(fontSize: 15,),
                            ),
                          ],
                      ),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) => const Divider(height: 9, color: Color(0xfff8f8f8),),  //구분선(height로 상자 사이 간격을 조절)
        ),
    );
  }
  void showPopup(){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              width: 450,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '읽음',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 500,height: 20,),
                    Text(
                      '읽음 표시로 바꾸시겠습니까?',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 120,),
                        TextButton(
                          child: Text(
                            "취소",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                            print('취소가 눌렸습니다.');
                          }
                        ),
                        TextButton(
                            child: Text(
                              "확인",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: (){
                              Navigator.of(context).pop();
                              print('확인이 눌렸습니다.');
                            }
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}