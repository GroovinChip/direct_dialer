import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('direct_dialer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return returnsNormally;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('directDial', () async {
    final dialer = await DirectDialer.instance;
    expect(() => dialer.dial('4433793985'), returnsNormally);
  });
}
