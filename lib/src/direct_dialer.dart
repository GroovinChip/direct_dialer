import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class DirectDialer {
  DirectDialer._();

  static Future<DirectDialer> get instance => _init();

  static Future<DirectDialer> _init() async {
    final directDialer = DirectDialer._();
    if (Platform.isIOS) {
      _iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      onIpad = await _isIpad();
    }
    return directDialer;
  }

  static const MethodChannel _channel = MethodChannel('direct_dialer');
  static late IosDeviceInfo _iosDeviceInfo;
  static bool onIpad = false;

  /// Dials a phone number directly.
  ///
  /// Uses the Intent package for the Android implementation.
  Future<void> dial(
    String number, {
    bool retryWithFaceTime = false,
    bool useFaceTimeAudio = false,
  }) async {
    final phonePermission = await Permission.phone.status;

    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.CALL',
        data: 'tel:$number',
      );
      if (phonePermission.isDenied) {
        Permission.phone.request().then((status) {
          if (status.isGranted) {
            intent.launch();
          }
        });
      }
      if (phonePermission.isGranted) {
        try {
          await intent.launch();
        } catch (e) {
          print(e);
        }
      }
    }

    if (Platform.isIOS || onIpad) {
      // Check cellular or wifi
      final connectivityResult = await _connectivityCheck();
      // Check if physical device - emulators can't make calls
      if (_iosDeviceInfo.isPhysicalDevice) {
        // If cellular, make a call as normal
        try {
          if (connectivityResult == ConnectivityResult.mobile) {
            await _channel.invokeMethod(
              'dial',
              <String, Object>{'number': number},
            );
          }
        } catch (e) {
          if (retryWithFaceTime) {
            await dialFaceTime(number, useFaceTimeAudio);
          }
        }
      } else if (_iosDeviceInfo.isPhysicalDevice &&
          connectivityResult == ConnectivityResult.wifi) {
        await dialFaceTime(number, useFaceTimeAudio);
      } else {
        throw 'This action is not available on the iOS simulator.';
      }
    }

    if (Platform.isMacOS) {
      await dialFaceTime(number, useFaceTimeAudio);
    }
  }

  /// Initiates a FaceTime call on iOS and macOS
  Future<void> dialFaceTime(String number, bool videoCall) async {
    if (Platform.isIOS || Platform.isMacOS) {
      if (videoCall) {
        if (await url_launcher.canLaunchUrl(Uri.parse('facetime:$number'))) {
          await url_launcher.launchUrl(Uri.parse('facetime:$number'));
        }
      } else {
        if (await url_launcher.canLaunchUrl(
          Uri.parse('facetime-audio:$number'),
        )) {
          await url_launcher.launchUrl(Uri.parse('facetime-audio:$number'));
        }
      }
    } else {
      throw PlatformException(
        code: 'direct_dialer',
        message: 'This action is only available on iOS and macOS',
      );
    }
  }

  Future<ConnectivityResult> _connectivityCheck() async {
    return await (Connectivity().checkConnectivity());
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
