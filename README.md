# toml_localizations

A minimal [TOML](https://github.com/toml-lang/toml) localization package for
Flutter.

TOML is a minimal, easy to read, configuration file format, which allows you to
represent [strings](https://github.com/toml-lang/toml#user-content-string) (and
other types) as key/value pairs.

## Install

Add `toml_localizations` and `flutter_localizations` as dependencies to your `pubspec.yaml`.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  toml_localizations: <last-version>
```

### Add assets

Add a TOML file per language to a asset path and define it in your `pubspec.yaml`.

```yaml
flutter:
  assets:
    - assets/toml_translations
```

The TOML file name must match exactly the combination of language and country
code described in `supportedLocales`.

That is `Locale('en', 'US')` must have a corresponding `assetPath/en-US.toml` file.

### Add localization delegate and supported locales

Add `TomlLocalizationsDelegate` to `MaterialApp` and set `supportedLocales` to supported language/country codes.

```Dart
MaterialApp(
  localizationsDelegates: [
    // delegate from flutter_localization
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    // toml localizations delegate
    TomlLocalizationsDelegate(path: 'assets/toml_translations')
  ],
  supportedLocales: [
    Locale('en', 'GB'),
    Locale('en', 'US'),
    Locale('en'),
    Locale('nb'),
  ],
}
```

### Note on **iOS**

Add supported languages to `ios/Runner/Info.plist` as described
[here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#specifying-supportedlocales).

Example:

```
<key>CFBundleLocalizations</key>
<array>
	<string>en</string>
	<string>en-GB</string>
	<string>en-US</string>
	<string>nb</string>
</array>
```

## Format

Example TOML file:

```toml
str = "The quick brown fox jumps over the lazy dog."

literal_str = 'C:\Users\nodejs\templates'

multiline_str = """\
The quick brown \
fox jumps over \
the lazy dog.\
"""

literal_multiline_str = '''
The first newline is
trimmed in raw strings.
   All other whitespace
   is preserved.
'''

list = [ 'one', 'two', 'three' ]
```

> Tip: Toml supports several ways of expressing strings. See Toml documentation for more info.

### API

Translate strings or other types using:

```Dart
TomlLocalizations.of(context)!.value(this);
```

We keep the API simple, but you can easily add an extension method to `String` like this:

```Dart
extension LocalizedString on String {
  String tr(BuildContext context) => TomlLocalizations.of(context)!.value(this);
}
```

Se you could translate strings like this:

```Dart
'Hi'.tr(context)
```

## Example

See [example](example)

