import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toml_localizations/toml_localizations.dart';

/// https://flutter.dev/docs/testing
/// https://flutter.dev/docs/cookbook/testing/unit/introduction
/// https://flutter.dev/docs/cookbook/testing/widget/introduction
/// https://stackoverflow.com/questions/49480080/flutter-load-assets-for-tests
/// https://api.flutter.dev/flutter/widgets/DefaultAssetBundle-class.html
/// https://stackoverflow.com/questions/52463714/how-to-test-localized-widgets-in-flutter
/// https://dart.dev/null-safety/migration-guide

ByteData toByteData(String text) {
  return ByteData.view(Uint8List.fromList(utf8.encode(text)).buffer);
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('en.toml')) {
      return toByteData('str = "Hi en"');
    } else if (key.endsWith('en-US.toml')) {
      return toByteData('str = "Hi en-US"');
    } else if (key.endsWith('nb.toml')) {
      return toByteData('str = "Hei nb"');
    } else if (key.endsWith('nb-NO.toml')) {
      return toByteData('str = "Hei nb-NO"');
    } else {
      return toByteData('Error');
    }
  }
}

Widget buildTestWidgetWithLocale(Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: [
      TomlLocalizationsDelegate(
        'assets/toml_translations',
        TestAssetBundle(),
      ),
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('en', 'US'),
      Locale('nb'),
      Locale('nb', 'NO'),
    ],
    home: Scaffold(
      body: Builder(
        builder: (context) =>
            Text(TomlLocalizations.of(context)?.value('str') ?? ''),
      ),
    ),
  );
}

void main() {
  testWidgets('MyTestApp find [en] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('en')));
    await tester.pump();
    final hiFinder = find.text('Hi en');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('MyTestApp find [en-US] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('en', 'US')));
    await tester.pump();
    final hiFinder = find.text('Hi en-US');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('MyTestApp find [nb] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('nb')));
    await tester.pump();
    final hiFinder = find.text('Hei nb');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('MyTestApp find [nb-NO] text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(Locale('nb', 'NO')));
    await tester.pump();
    final hiFinder = find.text('Hei nb-NO');
    expect(hiFinder, findsOneWidget);
  });
}
