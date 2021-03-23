# direct_dialer

Allows Flutter applications to directly dial a phone number.

## Usage



```dart
Future<void> dial() async {
  await DirectDialer.dial('123-456-7890');
}
```

## Roadmap
- [ ] Support initiating Facetime video/audio calls for iPad, macOS (maybe web on macOS too)