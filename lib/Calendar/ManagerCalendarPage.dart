import 'package:flutter/material.dart';
import '/Supplementary/ThemeColor.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

ThemeColor themeColor = ThemeColor();
List<String> temp = ['단체 여행', '건강검진'];

class ManagerCalendarPage extends StatefulWidget {
  const ManagerCalendarPage({Key? key}) : super(key: key);

  @override
  State<ManagerCalendarPage> createState() => _ManagerCalendarPageState();
}

class _ManagerCalendarPageState extends State<ManagerCalendarPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일정표')),
      body: ListView(
        children: [

          test(),
          SizedBox(height: 20),
          list()

        ],
      ),
    );
  }



  Widget test() {
    return Container(
      height: 400,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: CalendarCarousel<Event>(
        isScrollable: true,
        weekendTextStyle: const TextStyle(color: Colors.red),
        todayButtonColor: themeColor.getColor(),
        todayBorderColor: Colors.transparent,
        daysHaveCircularBorder: true,
        selectedDayButtonColor: Colors.cyan,
      ),
    );
  }

  Widget list() {
    return ListView.separated(
      itemCount: temp.length, //공지 목록 출력 개수
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(13),
          color: Colors.white,
          child: Text(temp[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }


}
