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

  /// A language / country code key used for translations.
  late String _langTag;

  /// Initialize with asset path to TOML files and a list of supported language codes.
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
    _langTag = locale.toLanguageTag();

    // in cache
    if (_translations.containsKey(_langTag)) {
      return this;
    }

    // try to load with with _codeKey
    // could be a combination of language / country code
    final text = await loadAsset('$assetPath/$_langTag.toml');
    if (text != null) {
      _translations[_langTag] = TomlDocument.parse(text).toMap();
      return this;
    }

    // if it was a combined key, try to load with only language code
    if (_langTag != locale.languageCode) {
      _langTag = locale.languageCode;
      final text = await loadAsset('$assetPath/$_langTag.toml');
      // asset file should always exist for a supportedLanguageCode
      if (text != null) {
        _translations[_langTag] = TomlDocument.parse(text).toMap();
      }
    }

    assert(false, 'translation file not found for code \'$_langTag\'');

    return this;
  }

  /// Get translation given a [key].
  dynamic value(String key) => _translations[_langTag]![key];

  /// Helper for getting [TomlLocalizations] object.
  static TomlLocalizations? of(BuildContext context) =>
      Localizations.of<TomlLocalizations>(context, TomlLocalizations);
}

/// [TomlLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class TomlLocalizationsDelegate
    extends LocalizationsDelegate<TomlLocalizations> {
  final TomlLocalizations localization;

  TomlLocalizationsDelegate({required String path, AssetBundle? assetBundle})
      : localization = TomlLocalizations(path, assetBundle);

  /// We expect supportedLocales to have asset files.
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<TomlLocalizations> load(Locale locale) => localization.load(locale);

  @override
  bool shouldReload(TomlLocalizationsDelegate old) => false;
}
