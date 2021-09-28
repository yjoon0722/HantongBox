import 'package:flutter/material.dart';

class GradientPage extends StatefulWidget {
  @override
  _GradientPageState createState() => _GradientPageState();

}

class _GradientPageState extends State<GradientPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.0,
              0.3,
              0.7,
              1.0
            ],
            colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
      ),
      child: Center(
        child: Text(
          "글라데이션 테스트",
          style: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
