import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:call_number/call_number.dart';

void main() {
  const MethodChannel channel = MethodChannel('call_number');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return returnsNormally;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('callNumber', () async {
    expect(() => CallNumber.callNumber('4433793985'), returnsNormally);
  });
}
