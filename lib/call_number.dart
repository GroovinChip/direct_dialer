import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intent/action.dart';
import 'package:intent/intent.dart';

class CallNumber {
  static const MethodChannel _channel = const MethodChannel('call_number');

  static Future<void> callNumber(String number) async {
    if (Platform.isAndroid) {
      Intent()
        ..setAction(Action.ACTION_CALL)
        ..setData(Uri.parse('tel:$number'))
        ..startActivity();
    }
    if (Platform.isIOS) {
      await _channel.invokeMethod(
        'callNumber',
        <String, Object>{'number': number},
      );
    }
  }
}
