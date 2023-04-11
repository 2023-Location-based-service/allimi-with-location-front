import 'package:flutter/material.dart';

class FirstDropdown extends StatefulWidget {
  const FirstDropdown({Key? key}) : super(key: key);

  @override
  State<FirstDropdown> createState() => _FirstDropdownState();
}

class _FirstDropdownState extends State<FirstDropdown> {
  final items = ['금식', '전량섭취', '반량섭취'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = items[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      DropdownButton<String>(
        value: selectedValue,
        items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e))).toList(),
        onChanged: (value) {setState(() => selectedValue = value!);},
      ),
    );
  }
}


/* ---------------------------------------------------------------------------------- */


class SecondDropdown extends StatefulWidget {
  const SecondDropdown({Key? key}) : super(key: key);

  @override
  State<SecondDropdown> createState() => _SecondDropdownState();
}

class _SecondDropdownState extends State<SecondDropdown> {
  final items = ['해당 사항 없음','아침', '점심', '저녁', '아침&점심', '아침&저녁', '점심&저녁', '아침&점심&저녁'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = items[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      DropdownButton<String>(
        value: selectedValue,
        items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e))).toList(),
        onChanged: (value) {setState(() => selectedValue = value!);},
      ),
    );
  }
}


/* ---------------------------------------------------------------------------------- */

