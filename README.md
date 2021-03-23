# direct_dialer

Allows Flutter applications to directly dial a phone number.

## Setup

### *Android*
1. Add `<uses-permission android:name="android.permission.CALL_PHONE"/>` to your `AndroidManifest.xml
2. Set `minSdkVersion` to `23` in your app-level `build.gradle`

## Usage

1. Configure your main method as follows:
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directDialer = await DirectDialer.init();
}
```
2. Pass your instance of `DirectDialer` through your widget tree however you prefer (Provider, Riverpod, etc.)
3a. For Android/iOS:
```dart
Future<void> dial() async {
  await directDialer.dial('123-456-7890');
}
```
3b. For iOS, iPad, macOS:
```dart
Future<void> dial() async {
  // FaceTime video
  await directDialer.dialFaceTime('123-456-7890', true);
  // FaceTime audio
  await directDialer.dialFaceTime('123-456-7890', false);
}
```
