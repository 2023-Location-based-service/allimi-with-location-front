import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Supplementary/CustomWidget.dart';
import 'package:test_data/provider/NoticeTempProvider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import '/Supplementary/DropdownWidget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as ppp;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:test_data/Backend.dart';
import '../Supplementary/CustomClick.dart';

String backendUrl = Backend.getUrl();
ThemeColor themeColor = ThemeColor();

class ModificationNoticePage extends StatefulWidget {
  const ModificationNoticePage({Key? key,
    required this.noticeId,
    required this.facility_id,
    required this.noticeList,
    required this.imageUrls,
  }) : super(key: key);

  final int noticeId;
  final int facility_id;
  final List<String> imageUrls;
  final Map<String, dynamic> noticeList;

  @override
  State<ModificationNoticePage> createState() => _ModificationNoticePageState();
}

class _ModificationNoticePageState extends State<ModificationNoticePage> {
  CheckClick checkClick = new CheckClick();
  final formKey = GlobalKey<FormState>();
  late int _noticeId;
  late int _facility_id;
  late List<String> _imageUrls;
  String _title = '';
  String _contents = '';
  //List<Map<String, dynamic>> _noticeList = [];
  late Map<String, dynamic> _noticeList;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  void initState() {
    _noticeId = widget.noticeId;
    _noticeList = widget.noticeList;
    _imageUrls = widget.imageUrls;
    _facility_id = widget.facility_id;
    _title = _noticeList['title'];
    _contents = _noticeList['content'];
    //getFacilityResident(_facility_id);
    getFile();
  }

  Future<void> getFile() async {
    List<XFile> filesList= await _fileFromImageUrl(_imageUrls);

    if (filesList != null) {
      setState(() {
        _pickedImgs.addAll(filesList);
      });
    }
  }

  Future<List<XFile>> _fileFromImageUrl(List<String> imageUrls) async {
    List<XFile> xfileList  = [];

    for (int i = 0; i<imageUrls.length; i++) {
      final response = await http.get(Uri.parse(imageUrls[i]));
      final documentDirectory = await pp.getApplicationDocumentsDirectory();
      final file = File(ppp.join(documentDirectory.path, i.toString() + ".jpg"));
      file.writeAsBytesSync(response.bodyBytes);

      final xfile = new XFile(file.path);
      xfileList.add(xfile);
    }

    return xfileList;
  }

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


  // 서버에 공지사항 업로드 + 사진 업로드
  Future<void> editAllim(userId, facilityId, importantTest) async {
    debugPrint("@@@@ 공지사항 수정 백엔드 요청 보냄");
    List<MultipartFile> _files = [];
    var formData = null;

    if (_pickedImgs.length != 0 ) {
      _files = _pickedImgs.map((img) => MultipartFile.fromFileSync(img.path, contentType: MediaType("image", "jpg"))).toList();

      formData = FormData.fromMap({
        "allnotice": MultipartFile.fromString(
          jsonEncode(
              {"allnotice_id": _noticeId,
                "user_id": userId,
                "title": _title,
                "contents": _contents,
                "important": importantTest}),
          contentType: MediaType.parse('application/json'),
        ),
        "file": _files
      });
    } else {
      formData = FormData.fromMap({
        "allnotice": MultipartFile.fromString(
          jsonEncode(
              {"allnotice_id": _noticeId,
                "user_id": userId,
                "title": _title,
                "contents": _contents,
                "important": importantTest}),
          contentType: MediaType.parse('application/json'),
        ),
        "file": _files
      });
    }

    var dio = Dio();
    dio.options.contentType = 'multipart/form-data';

    var response = null;
    try {
      response = await dio.patch(backendUrl + 'all-notices', data: formData); // ipConfig -> IPv4 주소, TODO: 실제 주소로 변경해야 함
    }catch(e) {
      debugPrint("@@response .. : " + e.toString());
      throw new Exception();
    }
    debugPrint("@@StatusCode: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("@@성공");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<UserProvider, ResidentProvider, NoticeTempProvider> (
        builder: (context, userProvider, residentProvider, noticeTempProvider, child) {
          return customPage(
              title: '공지사항 수정',
              onPressed: () async {
                if(this.formKey.currentState!.validate()) {
                  this.formKey.currentState!.save();

                  try {
                    if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                      return ;
                    }
                    await editAllim(userProvider.uid, residentProvider.facility_id, noticeTempProvider.isImportant);
                    _pickedImgs = [];
                    setState(() {});
                    Navigator.pop(context);
                  } catch(e) {

                    showToast('공지사항 업로드 실패! 다시 시도해주세요');
                  }

                }
              },
              body: writePost(),
              buttonName: '완료');
        }
    );
  }


  Widget writePost() {
    //bool important = _noticeList['important']; //TODO: 드롭다운
    return ListView(
      children: [

        Container(
          padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.info_rounded, size: 18, color: themeColor.getColor()),
              Text(' 중요한 공지는 중요 태그를 사용해보세요', style: TextStyle(color: themeColor.getColor())),
            ],
          ),
        ),
        NoticeDropdown(menu: '공지사항', selected: _noticeList['important'] ? '중요' : '공지사항',),

        SizedBox(height: 8),
        getBody(),
        SizedBox(height: 8),
        getPicture(context),
        SizedBox(height: 20),
      ],
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
                initialValue: _title,
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
                initialValue: _contents,
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
          if (index != 0)
            debugPrint("@@img: " + _pickedImgs[index-1].path.toString());

          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(3, 8, 3, 8),
              width: 100,
              height: 100,
              child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(5),
                  color: Colors.grey.shade300,
                  child: Container(
                    child: (index == 0)? Center(child: addImages(context)) : Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.cancel_rounded, color: Colors.black54, size: 20,),
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
