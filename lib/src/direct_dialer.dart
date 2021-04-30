import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:intent_ns/action.dart';
import 'package:intent_ns/intent.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class DirectDialer {
  DirectDialer._();

  static Future<DirectDialer> get instance => _init();

  static Future<DirectDialer> _init() async {
    final directDialer = DirectDialer._();
    if (Platform.isIOS) {
      _iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      onIpad = await DirectDialer._isIpad();
    }
    return directDialer;
  }

  static const MethodChannel _channel = const MethodChannel('direct_dialer');
  static late IosDeviceInfo _iosDeviceInfo;
  static bool onIpad = false;

  /// Dials a phone number directly.
  ///
  /// Uses the Intent package for the Android implementation.
  Future<void> dial(String number, {bool useFaceTimeAudio = false}) async {
    final phonePermission = await Permission.phone.status;

    if (Platform.isAndroid) {
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
        try {
          Intent()
            ..setAction(Action.ACTION_CALL)
            ..setData(Uri.parse('tel:$number'))
            ..startActivity();
        } catch (e) {
          print(e);
        }
      }
    }

    if (Platform.isIOS || onIpad) {
      if (_iosDeviceInfo.isPhysicalDevice) {
        await _channel.invokeMethod(
          'dial',
          <String, Object>{'number': number},
        );
      } else {
        throw 'This action is not available on the iOS simulator.';
      }
    }
  }

  /// Initiates a FaceTime call on iOS and macOS
  Future<void> dialFaceTime(String number, bool videoCall) async {
    if (Platform.isIOS || Platform.isMacOS) {
      if (videoCall) {
        if (await url_launcher.canLaunch('facetime:$number')) {
          await url_launcher.launch('facetime:$number');
        }
      } else {
        if (await url_launcher.canLaunch('facetime-audio:$number')) {
          await url_launcher.launch('facetime-audio:$number');
        }
      }
    } else {
      throw 'This action is only available on iOS and macOS';
    }
  }

  /// Checks if the current iOS device is an iPad
  static Future<bool> _isIpad() async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    if (iosInfo.model!.toLowerCase().contains('ipad')) {
      return true;
    }
    return false;
  }
}
