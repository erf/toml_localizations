import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:toml/toml.dart';

/// Store translations per languageCode from a TOML file used by [TomlLocalizationsDelegate].
class TomlLocalizations {
  /// Map of translations per language/country code.
  final Map<String, Map> _translations = {};

  /// Path to translation assets.
  final String assetPath;

  /// The asset bundle.
  final AssetBundle assetBundle;

  /// A hash key of language / country code used for [_translationsMap].
  late String _codeKey;

  /// Initialize with asset path to Toml files and a list of supported language codes.
  TomlLocalizations(this.assetPath, [assetBundle])
      : assetBundle = assetBundle ?? rootBundle;

  Future<String?> loadAsset(path) async {
    try {
      return await assetBundle.loadString(path);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// Load and cache a TOML file per language / country code.
  Future<TomlLocalizations> load(Locale locale) async {
    _codeKey = locale.toLanguageTag();

    // in cache
    if (_translations.containsKey(_codeKey)) {
      return this;
    }

    // try to load with with _codeKey
    // could be a combination of language / country code
    final text = await loadAsset('$assetPath/$_codeKey.toml');
    if (text != null) {
      _translations[_codeKey] = TomlDocument.parse(text).toMap();
      return this;
    }

    // if it was a combined key, try to load with only language code
    if (_codeKey != locale.languageCode) {
      _codeKey = locale.languageCode;
      final text = await loadAsset('$assetPath/$_codeKey.toml');
      // asset file should always exist for a supportedLanguageCode
      if (text != null) {
        _translations[_codeKey] = TomlDocument.parse(text).toMap();
      }
    }

    assert(false, 'translation file not found for code \'$_codeKey\'');

    return this;
  }

  /// Get translation given a key.
  dynamic value(String key) {
    final containsLocale = _translations.containsKey(_codeKey);
    assert(containsLocale, 'Missing localization for code: $_codeKey');
    final translations = _translations[_codeKey]!;
    final containsKey = translations.containsKey(key);
    assert(containsKey, 'Missing localization for translation key: $key');
    final translatedValue = translations[key];
    return translatedValue;
  }

  /// Helper for getting [TomlLocalizations] object.
  static TomlLocalizations? of(BuildContext context) =>
      Localizations.of<TomlLocalizations>(context, TomlLocalizations);
}

/// [TomlLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class TomlLocalizationsDelegate
    extends LocalizationsDelegate<TomlLocalizations> {
  final TomlLocalizations localization;

  TomlLocalizationsDelegate(String path, [AssetBundle? assetBundle])
      : localization = TomlLocalizations(path, assetBundle);

  /// We expect supportedLocales to have asset files.
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<TomlLocalizations> load(Locale locale) => localization.load(locale);

  @override
  bool shouldReload(TomlLocalizationsDelegate old) => false;
}
