import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:intent/action.dart';
import 'package:intent/intent.dart';
import 'package:permission_handler/permission_handler.dart';

class DirectDialer {
  static const MethodChannel _channel = const MethodChannel('direct_dialer');
  static final _deviceInfo = DeviceInfoPlugin();

  /// Dials a phone number directly.
  ///
  /// Uses the Intent package for the Android implementation.
  static Future<void> dial(String number) async {
    if (Platform.isAndroid) {
      final phonePermission = await Permission.phone.status;
      if (phonePermission.isDenied) {
        Permission.phone.request().then((status) {
          if (status.isGranted) {
            Intent()
              ..setAction(Action.ACTION_CALL)
              ..setData(Uri.parse('tel:$number'))
              ..startActivity();
          }
        });
      }
      if (phonePermission.isGranted) {
        Intent()
          ..setAction(Action.ACTION_CALL)
          ..setData(Uri.parse('tel:$number'))
          ..startActivity();
      }
    }
    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        await _channel.invokeMethod(
          'dial',
          <String, Object>{'number': number},
        );
      } else {
        throw 'This action is not available on the iOS simulator.';
      }
    }
  }
}
