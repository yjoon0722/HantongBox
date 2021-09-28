import 'package:flutter/material.dart';

Future<T> showTextDialog<T>(BuildContext context, {String title, String value,}) => showDialog<T>(
  context: context,
  builder: (context) => TextDialogWidget(
    title: title,
    value: value,
  ),
);

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;

  const TextDialogWidget({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    title: Center(
      child: Text(widget.title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black,),
      ),
    ),
    content: TextField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    ),
    actions: [
      ElevatedButton(
        child: Text('확인'),
        onPressed: () {
          Navigator.of(context).pop(controller.text);
        },
      ),
    ],
  );
}
