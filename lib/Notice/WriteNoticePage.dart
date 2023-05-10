import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Supplementary/DropdownWidget.dart';
import 'package:test_data/provider/NoticeTempProvider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

String backendUrl = "http://52.78.62.115:8080/v2/";

class WriteNoticePage extends StatefulWidget {
  const WriteNoticePage({Key? key}) : super(key: key);

  @override
  State<WriteNoticePage> createState() => _WriteNoticePageState();
}

class _WriteNoticePageState extends State<WriteNoticePage> {

  final formKey = GlobalKey<FormState>();
  String _title = '';
  String _contents = '';

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];


  // 앨범
  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _pickedImgs.addAll(images);
      });
    }
  }

  // 카메라
  Future<void> _takeImg() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImgs.add(image);
      });
    }
  }

  // 서버에 이미지 업로드
  Future<void> addNotice(userId, facilityId, bool _importantTest) async {
    final List<MultipartFile> _files = _pickedImgs.map((img) => MultipartFile.fromFileSync(img.path,
        contentType: MediaType("image", "jpg"))).toList();

    var formData = FormData.fromMap({
      "allnotice": MultipartFile.fromString(
        jsonEncode({
          "user_id": userId,
          "facility_id": facilityId,
          "title": _title,
          "contents": _contents,
          "important": _importantTest}),
        contentType: MediaType.parse('application/json'),
      ),
      "file": _files
    });




    var dio = Dio();
    dio.options.contentType = 'multipart/form-data';
    final response = await dio.post(backendUrl + 'all-notices', data: formData); // ipConfig -> IPv4 주소, TODO: 실제 주소로 변경해야 함

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ResidentProvider> (
        builder: (context, userProvider, residentProvider, child) {
          return customPage(
              title: '공지사항 작성',
              onPressed: () async {
                print('공지사항 작성 완료버튼 누름');


                if(this.formKey.currentState!.validate()) {
                  this.formKey.currentState!.save();



                  showDialog(
                      context: context,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("공지사항을 업로드하시겠습니까?"),
                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                          actions: [
                            TextButton(
                              child: Text('취소',style: TextStyle(color: themeColor.getColor(),),),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                              onPressed: () async {
                                //_importantTest = NoticeTempProvider().trueTag;

                                try {
                                  bool _importantTest = Provider.of<NoticeTempProvider>(context, listen: false).isImportant;
                                  await addNotice(userProvider.uid, residentProvider.facility_id, _importantTest);
                                  _pickedImgs = [];

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context3) {
                                        return AlertDialog(
                                          content: Text('작성 완료'),
                                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                } catch(e) {

                                  print(e);

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text("공지사항 업로드 실패! 다시 시도해주세요"),
                                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                  );



                }


              },
              body: ListView(
                children: [

                  Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 10, 0),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(Icons.info_rounded, size: 18, color: Colors.grey),
                        Text(' 중요한 공지는 중요 태그를 사용하세요.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  NoticeDropdown(menu: '공지사항'),

                  SizedBox(height: 8),
                  //getTitle(),
                  //SizedBox(height: 8),
                  getBody(),

                  getPicture(context),

                ],
              ),
              buttonName: '완료'
          );
        }
    );
  }

  //제목 및 내용
  Widget getBody() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                validator: (value) {
                  if(value!.isEmpty) { return '제목을 입력하세요'; }
                  else { return null; }
                },
                decoration: const InputDecoration(
                  hintText: '제목',
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onSaved: (value) {
                  _title = value!;
                },
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 430,
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
                onSaved: (value) {
                  _contents = value!;
                },
              ),
            ),
          ],
        )

    );
  }

  //사진
  Widget getPicture(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      height: 115,
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _pickedImgs.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(3, 8, 3, 8),
              width: 100,
              height: 100,
              child: DottedBorder(
                  color: Colors.grey,
                  child: Container(
                    child: (index == 0)? Center(child: addImages(context)) : Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: (index == 0)? null : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(_pickedImgs[index - 1].path))
                            ),
                          ),
                        ),
                        Positioned(
                            top: 3,
                            right: 3,
                            child: GestureDetector(
                              child: Container(
                                child: Icon(Icons.cancel_rounded, color: Colors.black54,),
                              ),
                              onTap: () {
                                _pickedImgs.removeAt(index - 1);
                                setState(() {});
                              },
                            )
                        ),
                      ],
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addImages(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt_rounded, color: Colors.grey), title: const Text('카메라'),
                      onTap: () async {
                        Navigator.pop(context);
                        _takeImg();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_rounded, color: Colors.grey), title: const Text('갤러리'),
                      onTap: () async {
                        Navigator.pop(context);
                        _pickImg();
                      },
                    ),
                  ],
                ),
              );
            }
        );
      },
      icon: Container(
        alignment: Alignment.center,
        child: Icon(CupertinoIcons.plus, color: Colors.grey),
      ),
    );
  }
}