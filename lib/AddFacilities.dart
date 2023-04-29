import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddFacilities extends StatefulWidget {
  const AddFacilities({Key? key}) : super(key: key);

  @override
  State<AddFacilities> createState() => _AddFacilitiesState();
}

class _AddFacilitiesState extends State<AddFacilities> {

  List<String> personList = ['시설명', '주소', '전화번호', '시설장 이름'];

  @override
  Widget build(BuildContext context) {
    return addFacilities();
  }

  Widget addFacilities() {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Text('시설 정보를 입력해주세요.'),


            //TODO: 시설명, 주소, 전번, 이름

            getTextFormField(
                textInputType: TextInputType.text,
                icon: Icons.home_rounded,
                hintText: '시설명'
            ),
            getTextFormField(
                textInputType: TextInputType.text,
                icon: Icons.place_rounded,
                hintText: '주소'
            ),
            getTextFormField(
                textInputType: TextInputType.number,
                icon: Icons.call_rounded,
                hintText: '전화번호'
            ),
            getTextFormField(
                textInputType: TextInputType.text,
                icon: Icons.person_rounded,
                hintText: '시설장 이름'
            ),


            OutlinedButton(
              child: Text('확인'),
              onPressed: (){
                print('시설 추가 확인 Tap');

                //TODO: 시설 추가 확인 버튼 누르면 실행되어야 할 부분

              },
            ),
          ],
        )
      ),
    );
  }


  Widget getTextFormField({
    required TextInputType textInputType,
    required IconData? icon,
    required String? hintText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.black54),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.transparent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.transparent),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          filled: true,
          fillColor: Color(0xfff2f3f6),
        ),
      ),
    );
  }
}
