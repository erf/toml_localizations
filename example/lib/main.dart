import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toml_localizations/toml_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
              'da',
            ],
          ),
        ),
      ],
      supportedLocales: [
        Locale('en'),
        Locale('nb'),
        Locale('da'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(TomlLocalizations.of(context).string('str1')),
            SizedBox(height: 12),
            Text(TomlLocalizations.of(context).string('str2')),
            SizedBox(height: 12),
            Text(TomlLocalizations.of(context).string('str3')),
            SizedBox(height: 12),
            Text(TomlLocalizations.of(context).string('str4')),
            SizedBox(height: 12),
            Text(TomlLocalizations.of(context).string('str5')),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
