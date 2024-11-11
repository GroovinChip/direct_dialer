import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:android_intent_plus/android_intent.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
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

    if (onIpad) {
      _dialIOS(number, retryWithFaceTime, useFaceTimeAudio);
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          await _dialAndroid(number, phonePermission);
        case TargetPlatform.iOS:
          _dialIOS(number, retryWithFaceTime, useFaceTimeAudio);
        case TargetPlatform.macOS:
          await dialFaceTime(number, useFaceTimeAudio);
        default:
          throw PlatformException(
            code: 'direct_dialer',
            message: 'This action is not supported on $defaultTargetPlatform',
          );
      }
    }
  }

  Future<void> _dialAndroid(
    String number,
    PermissionStatus phonePermission,
  ) async {
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

  void _dialIOS(
    String number,
    bool retryWithFaceTime,
    bool useFaceTimeAudio,
  ) {
    _onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        try {
          _channel.invokeMethod(
            'dial',
            <String, Object>{'number': number},
          );
        } catch (error, stackTrace) {
          if (retryWithFaceTime) {
            developer.log(
              'Error: $error, retrying with FaceTime',
              error: error,
              stackTrace: stackTrace,
            );
            dialFaceTime(number, useFaceTimeAudio);
          } else {
            developer.log(
              'Error: $error',
              error: error,
              stackTrace: stackTrace,
            );
          }
        }
      } else if (_iosDeviceInfo.isPhysicalDevice &&
          connectivityResult.contains(ConnectivityResult.wifi)) {
        dialFaceTime(number, useFaceTimeAudio);
      }
    });
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

  Stream<List<ConnectivityResult>> get _onConnectivityChanged {
    return Connectivity().onConnectivityChanged;
  }

  /// Checks if the current iOS device is an iPad
  static Future<bool> _isIpad() async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    if (iosInfo.model.toLowerCase().contains('ipad')) {
      return true;
    }
    return false;
  }
}
