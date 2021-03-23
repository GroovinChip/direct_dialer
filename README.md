# direct_dialer

Allows Flutter applications to directly dial a phone number.

## Setup

### *Android*
1. Add `<uses-permission android:name="android.permission.CALL_PHONE"/>` to your `AndroidManifest.xml
2. Set `minSdkVersion` to `23` in your app-level `build.gradle`

## Usage

For Android/iOS:
```dart
Future<void> dial() async {
  final dialer = await DirectDialer.instance;
  await dialer.dial('123-456-7890');
}
```
For iOS, iPad, macOS:
```dart
Future<void> dial() async {
  final dialer = await DirectDialer.instance;
  // FaceTime video
  await dialer.dialFaceTime('123-456-7890', true);
  // FaceTime audio
  await dialer.dialFaceTime('123-456-7890', false);
}
```
