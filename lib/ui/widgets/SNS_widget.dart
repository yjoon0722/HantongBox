import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/keypad.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'SSToast.dart';

class SNSWidget extends StatefulWidget {
  @override
  _SNSWidgetState createState() => _SNSWidgetState();
}

class _SNSWidgetState extends State<SNSWidget> {

  final double keypad_crossAxisSpacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
      const EdgeInsets.fromLTRB(20.0, 20, 20.0, 55.0),
      sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
              _buildKeypadItem,
              childCount: 3),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.6,
              crossAxisSpacing: keypad_crossAxisSpacing,
              mainAxisSpacing: 10.0)),
    );
  }

  Widget _buildKeypadItem(BuildContext context, int index) {
    Keypad keypad = null;
    switch (index) {
      case 0:
        keypad = Keypad(id: 0,
          title: "홈페이지",
          detail: "http://zangzip.com/",
          imagePath: 'assets/img_btn/button_bg_zangzip.png',
          backgroundColor: Colors.red,
          textColor: Colors.white,);
        break;
      case 1:
        keypad = Keypad(id: 1,
          title: "지도분포도",
          detail:"https://www.google.com/maps/d/u/0/edit?mid=1xGMLSzOY2im1T7hGAT0VSP6aPpM&ll=37.170501904964965%2C127.29979399251863&z=8",
          imagePath: 'assets/img_btn/button_bg_map.png',);
        break;
      case 2:
        keypad = Keypad(id: 2,
            title: "Delivery Tracker",
            detail: "https://hantondeliverytrack.web.app/",
            imagePath: "assets/img_btn/button_bg_deliverytracker.png");
        break;
      default:
        break;
    }

    if (keypad == null) { return null; }

    return _buildImageKeypad(context, keypad);
  }

  _buildImageKeypad(BuildContext context, Keypad keypad) {
    return Container(
      decoration: BoxDecoration(
        color: MyApp.btnBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        String imagePath = keypad.imagePath;

        if (imagePath.isEmpty) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                child: MaterialButton(
                  onLongPress: () => _keypadLongPressed(context, keypad),
                  onPressed: () => _keypadPressed(context, keypad, false),
                  textColor: keypad.textColor,
                  child: Text(keypad.title,textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
                ),
              )
            ],
          );
        } else {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0, width: width * 0.45, height: height * 0.8,
                child: Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.fitWidth, image:AssetImage(imagePath),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 0, height: height * 0.28,
                child: Container(
                  child: Text(keypad.title,textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
                ),
              ),
              Positioned.fill(
                child: MaterialButton(
                  onLongPress: () => _keypadLongPressed(context, keypad),
                  onPressed: () => _keypadPressed(context, keypad, false),
                  textColor: keypad.textColor,
                ),
              )
            ],
          );
        }
      }),
    );
  }

  // Action - 키패드 롱터치
  _keypadLongPressed(BuildContext context, Keypad keypad) {
    if (keypad.detail.isEmpty) { return; }
    _launchURL(keypad.detail);
  }

  // Action - 키패드 터치
  _keypadPressed(BuildContext context, Keypad keypad, bool isDoublePressed) {
    if (keypad.detail.isEmpty) { return; }
    showToast("${keypad.title}\n주소가 복사되었습니다.", context);
    Clipboard.setData(ClipboardData(text: keypad.detail));
  }

  // 웹화면
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 토스트 메세지
  void showToast(String msg, BuildContext context,{int duration, int gravity}) {
    SSToast.show(msg, context,
        duration: SSToast.LENGTH_SHORT, gravity: SSToast.CENTER);
  }
}