import 'package:toml/decoder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

/// store translations per languageCode from a Yaml file used by [TomlLocalizationsDelegate]
class TomlLocalizations {
  final _tomlParser = TomlParser();

  /// map of translations per languageCode
  final Map<String, Map> _localizedValues = {};

  /// path to Yaml translation asset
  final String assetPath;

  /// supported language codes
  final List<String> supportedLanguageCodes;

  /// language code of current locale, set in [load] method
  String _languageCode;

  /// initialize with asset path to Toml files and a list of supported language codes
  TomlLocalizations({
    @required this.assetPath,
    @required this.supportedLanguageCodes,
  });

  /// first time we call load, we read the csv file and initialize translations
  /// next time we just return this
  /// called by [TomlLocalizationsDelegate]
  Future<TomlLocalizations> load(Locale locale) async {
    this._languageCode = locale.languageCode;
    if (_localizedValues.containsKey(_languageCode)) {
      return this;
    }
    final String path = '$assetPath/$_languageCode.toml';
    final String text = await rootBundle.loadString(path);
    final Map<String, dynamic> toml = _tomlParser.parse(text.trim()).value;
    _localizedValues[_languageCode] = toml;
    return this;
  }

  /// get translation given a key
  String string(String key) {
    // find translation map given current locale
    final bool containsLocale = _localizedValues.containsKey(_languageCode);
    assert(containsLocale, 'Missing localization for code: $_languageCode');
    final Map translations = _localizedValues[_languageCode];
    // find translated string given translation key
    final bool containsKey = translations.containsKey(key);
    assert(containsKey, 'Missing localization for translation key: $key');
    final String translatedValue = translations[key];
    return translatedValue;
  }

  /// helper for getting [TomlLocalizations] object
  static TomlLocalizations of(BuildContext context) =>
      Localizations.of<TomlLocalizations>(context, TomlLocalizations);

  // helper for getting supported language codes from YamlLocalizationsDelegate
  bool isSupported(Locale locale) =>
      supportedLanguageCodes.contains(locale.languageCode);
}

/// [TomlLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class TomlLocalizationsDelegate
    extends LocalizationsDelegate<TomlLocalizations> {
  final TomlLocalizations localization;

  const TomlLocalizationsDelegate(this.localization);

  @override
  bool isSupported(Locale locale) => localization.isSupported(locale);

  @override
  Future<TomlLocalizations> load(Locale locale) => localization.load(locale);

  @override
  bool shouldReload(TomlLocalizationsDelegate old) => false;
}
