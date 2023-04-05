import 'package:flutter/material.dart';

class AddHomePage extends StatefulWidget {
  const AddHomePage({Key? key}) : super(key: key);

  @override
  State<AddHomePage> createState() => _AddHomePageState();
}

class _AddHomePageState extends State<AddHomePage> {
  final _valueList=['서울특별시','부산광역시','대구광역시','인천광역시','광주광역시','대전광역시'
      ,'울산광역시','세종특별자치시','경기도','강원도','충청북도','충청남도','전라북도','전라남도'
      ,'경상북도','경상남도','제주특별자치도'];
  var _selectedValue = '시/도 선택';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('요양원 검색'),
      ),
      body: findhome(),
    );
  }
  Widget findhome(){
    return ListView(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text('하이'),
                Text('하이'),
                //selectbox(),
                //selectbox(),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                  decoration: InputDecoration(
                      helperText: '요양원 이름, 주소, 전화번호로 검색 가능',
                      hintText: '입력해주세요.',  //글자를 입력하면 사라진다.
                      icon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(3)
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  //시/도 선택
  // Widget selectbox(){
  //   return DropdownButton(
  //       value: _selectedValue,
  //       items: _valueList.map(
  //           (value){
  //             return DropdownMenuItem(
  //                 value: value,
  //                 child: Text(value),
  //             );
  //           }
  //       ).toList(),
  //       onChanged: (value){
  //         setState(() {
  //           _selectedValue = value!;
  //         });
  //       }
  //   );
  //}

}
