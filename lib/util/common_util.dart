import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUtil {

  static bool isWeb() {
    bool isWeb = false;
    try {
      isWeb = !(Platform.isAndroid || Platform.isIOS);
    } catch (e) {
      print('# Error - CommonUtil : isWeb\n$e');
      isWeb = true;
    }
    return isWeb;
  }

  // 외부 브라우져 오픈
  static Future<bool> launchURL(String url) async {
    bool result = false;
    if (await canLaunch(url)) {
      result = await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return result;
  }

  // 토스트 메세지
  static void showToast(BuildContext context, String msg, {int duration = 3, int gravity}) {
    SSToast.show(msg, context, duration: duration, gravity: SSToast.CENTER);
  }

  static bool isFull(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static bool isHalf(BuildContext context) {
    return 700 <= MediaQuery.of(context).size.width && MediaQuery.of(context).size.width <= 1200;
  }


}