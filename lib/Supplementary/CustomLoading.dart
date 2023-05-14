import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatefulWidget {
  final Duration duration;

  CustomLoadingWidget({required this.duration});

  @override
  _CustomLoadingWidgetState createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: _animation.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
