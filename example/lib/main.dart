import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toml_localizations/toml_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

extension LocalizedString on String {
  String tr(BuildContext context) => TomlLocalizations.of(context).string(this);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        TomlLocalizationsDelegate(
          TomlLocalizations(
            assetPath: 'assets',
            supportedLanguageCodes: [
              'en',
              'nb',
            ],
          ),
        ),
      ],
      supportedLocales: [
        Locale('en'),
        Locale('nb'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('toml_localizations'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(TomlLocalizations.of(context).string('str')),
          SizedBox(height: 12),
          Text('literal_str'.tr(context)),
          SizedBox(height: 12),
          Text('multiline_str'.tr(context)),
          SizedBox(height: 12),
          Text('literal_multiline_str'.tr(context)),
        ],
      ),
    );
  }
}
