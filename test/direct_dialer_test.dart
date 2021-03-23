import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

//todo: test with mockito
void main() {
  const MethodChannel channel = MethodChannel('direct_dialer');

  TestWidgetsFlutterBinding.ensureInitialized();
  late DirectDialer dialer;

  setUp(() async {
    dialer = await DirectDialer.init();
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return returnsNormally;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('directDial', () async {
    expect(() => dialer.dial('4433793985'), returnsNormally);
  });
}
