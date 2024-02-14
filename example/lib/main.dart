import 'package:flutter/material.dart';
import 'package:toml_localizations/toml_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

extension LocalizedString on String {
  String tr(BuildContext context) => TomlLocalizations.of(context)!.value(this);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        TomlLocalizationsDelegate(path: 'assets'),
      ],
      supportedLocales: const [
        Locale('nb'),
        Locale('en', 'GB'),
        Locale('en', 'US'),
        Locale('en'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final List<String> list =
        TomlLocalizations.of(context)!.value('list').cast<String>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('toml_localizations'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('str'.tr(context)),
          const SizedBox(height: 12),
          Text('literal_str'.tr(context)),
          const SizedBox(height: 12),
          Text('multiline_str'.tr(context)),
          const SizedBox(height: 12),
          Text('literal_multiline_str'.tr(context)),
          for (final str in list) Text(str)
        ],
      ),
    );
  }
}
