import 'package:flutter/material.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class PageRouteWithAnimation {
  final Widget page;

  PageRouteWithAnimation(this.page);

  Route slideRitghtToLeft() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route slideLeftToRight() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

//페이지 이동 함수
void pageAnimation(BuildContext context, Widget page) {
  PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(page);
  Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
}

//커스텀 페이지 위젯
Widget customPage({
  required String title,
  required VoidCallback onPressed,
  required Widget body,
  required String buttonName,
}) {
  return Scaffold(
    //backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text('$title'),
      actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 50,
            height: 10,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.getColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text('$buttonName', style: TextStyle(color: Colors.white), textScaleFactor: 1.0,),
              onPressed: onPressed,
            ),
          ),
        ),
      ],),
    body: body,
  );
}
