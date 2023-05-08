import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '/Supplementary/ThemeColor.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";

ThemeColor themeColor = ThemeColor();

class ManagerCalendarPage extends StatefulWidget {
  const ManagerCalendarPage({Key? key, required this.userId, required this.facility_id}) : super(key: key);

  final int facility_id;
  final int userId;

  @override
  State<ManagerCalendarPage> createState() => _ManagerCalendarPageState();
}

class Schedule {
  late int scheduleId;
  late String eventName; 

  Schedule(this.scheduleId, this.eventName);
}

class _ManagerCalendarPageState extends State<ManagerCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List<Schedule>> mySelectedEvents = {};

  late int _facility_id;
  late int _userId;

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  List<Map<String, dynamic>> _scheduleList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = _focusedDay;
    _facility_id = widget.facility_id;
    _userId = widget.userId;
    loadPreviousEvents();
    getSchedules();
  }

  Future<void> deleteSchedule(int scheduleId) async {
    debugPrint("@@@스케줄 삭제 요청 보냄");
    http.Response response = await http.delete(
      Uri.parse(backendUrl+ 'schedule'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "schedule_id": scheduleId,
        "user_id": _userId
      })
    );

    if (response.statusCode != 200) {

      throw Exception();
    } else {
      debugPrint("asdf@@@@");
    }
  }

  Future<void> getSchedules() async {
    debugPrint("일정표 목록 요청 보냄");
    http.Response response = await http.get(
        Uri.parse(backendUrl + "schedule/" + _facility_id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    if (response.statusCode == 200) {
      var data =  utf8.decode(response.bodyBytes);
      dynamic decodedJson = json.decode(data);
      List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

      for (Map<String, dynamic> schedule in parsedJson) {
        List<String> result = schedule['date'].split('-');//"2023-05-08",

        DateTime date = DateTime.utc(int.parse(result[0]), int.parse(result[1]), int.parse(result[2]));

        if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(date!)] != null) {
          mySelectedEvents[DateFormat('yyyy-MM-dd').format(date!)]!.add(
            new Schedule(schedule['schedule_id'], schedule['texts'])
          );
        } else {
          mySelectedEvents[DateFormat('yyyy-MM-dd').format(date!)] = [
            new Schedule(schedule['schedule_id'], schedule['texts'])
          ];
        }
      }     

      setState(() {
        _scheduleList = parsedJson;
      });
    } else {
      debugPrint("노노@@@");
    }
  }

  // 서버에 스케줄 업로드
  Future<void> addSchedule(date, texts) async {
    var url = Uri.parse(backendUrl + 'schedule');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": _userId,
      "facility_id": _facility_id,
      "date": DateFormat('yyyy-MM-dd').format(date),
      "texts": texts,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일정표')),
      body: ListView(
        children: [
          TableCalendar(
            locale: 'ko_KR', // 한국어
            firstDay: DateTime(2023),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (date, locale) => DateFormat.yMMMMd(locale).format(date),
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
              headerPadding: const EdgeInsets.symmetric(vertical: 4),
              leftChevronIcon: const Icon(Icons.arrow_left, size: 40),
              rightChevronIcon: const Icon(Icons.arrow_right, size: 40),
            ),
            calendarStyle: CalendarStyle(
              markerDecoration : const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            eventLoader: _listOfDayEvents,
          ),
          for (Schedule sc in _listOfDayEvents(_selectedDate!)) ...[
            ListTile(
              leading: const Icon(Icons.done_rounded, color: Colors.teal),
              title: Text('${sc.eventName}'),
                trailing: OutlinedButton(
                  child: Text('삭제'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("정말 삭제하시겠습니까?"),
                          insetPadding:
                              const EdgeInsets.fromLTRB(0, 80, 0, 80),
                          actions: [
                            TextButton(
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  color: themeColor.getColor(),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                '삭제',
                                style: TextStyle(
                                  color: themeColor.getColor(),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  
                                  await deleteSchedule(sc.scheduleId);
                                  setState(() {
                                    mySelectedEvents = {};
                                    getSchedules();
                                  });
                                  

                                  showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // 바깥 영역 터치시 닫을지 여부
                                    builder: (BuildContext context3) {

                                      return AlertDialog(
                                        content: Text('삭제되었습니다'),
                                        insetPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 80, 0, 80),
                                        actions: [
                                          TextButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                } catch (e) {
                                  debugPrint("@@@@@ososfdo");
                                }
                              },
                            ),
                          ],
                        );
                      });
                  },
                ),
              //subtitle: Text('Description:   ${myEvents['eventDescp']}'),
            )
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.white54,
        backgroundColor: themeColor.getColor(),
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        onPressed: () { _showAddEventDialog(); },
        child: Icon(Icons.create_rounded, color: Colors.white),
      )
    );
  }


  loadPreviousEvents() {
    mySelectedEvents = {};
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 추가'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: '내용',
              ),
            ),
            // TextField(
            //   controller: descpController,
            //   textCapitalization: TextCapitalization.words,
            //   decoration: const InputDecoration(labelText: 'Description'),
            // ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            child: const Text('추가'),
            onPressed: () async {
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('내용을 입력하세요'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                await addSchedule(_selectedDate, titleController.text);

                setState(() {
                  mySelectedEvents = {};
                  getSchedules();
                });

                titleController.clear();
                Navigator.pop(context);
                return;
              }
            },
          )
        ],
      ),
    );
  }
}
