
import 'dart:async';

import 'package:flutter/services.dart';

class HbMacInterface {
  static const MethodChannel _channel =
      const MethodChannel('hb_mac_interface');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> setLastTime([ dynamic arguments ]) async {
    final bool result = await _channel.invokeMethod('setLastTime', arguments);
    return result;
  }
}
