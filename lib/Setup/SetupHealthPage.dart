import 'package:flutter/material.dart';

class SetupHealthPage extends StatefulWidget {
  final List<String> healthList;
  final List<bool> isCheckedList;

  const SetupHealthPage({Key? key, required this.healthList, required this.isCheckedList}) : super(key: key);

  @override
  State<SetupHealthPage> createState() => _SetupHealthPageState();
}

class _SetupHealthPageState extends State<SetupHealthPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.healthList.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            title: Text(widget.healthList[index]),
            value: widget.isCheckedList[index],
            onChanged: (bool? value) {
              setState(() {
                widget.isCheckedList[index] = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }
}