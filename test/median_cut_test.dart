import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:median_cut/median_cut.dart';

void main() {
  const MethodChannel channel = MethodChannel('median_cut');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MedianCut.platformVersion, '42');
  });
}
