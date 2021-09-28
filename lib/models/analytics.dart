import 'package:hantong_cal/util/common_util.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:io';


FirebaseAnalytics analytics = FirebaseAnalytics();

void analytics_test(String name){
  if(CommonUtil.isWeb()){
    analytics.logEvent(name: name,parameters: {name:'WEB used'});
  } else if(Platform.isAndroid){
    analytics.logEvent(name: name,parameters: {name:'Android used'});
  } else if(Platform.isIOS) {
    analytics.logEvent(name: name,parameters: {name:'IOS used'});
  }
}
