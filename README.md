# direct_dialer

Allows Flutter applications to directly dial a phone number.

## Setup

### *Android*
1. Add `<uses-permission android:name="android.permission.CALL_PHONE"/>` to your `AndroidManifest.xml
2. Set `minSdkVersion` to `23` in your app-level `build.gradle`

## Usage

```dart
Future<void> dial() async {
  await DirectDialer.dial('123-456-7890');
}
```

## Roadmap
- [ ] Support initiating Facetime video/audio calls for iPad, macOS (maybe web on macOS too)