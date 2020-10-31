# toml_localizations

[TOML](https://github.com/toml-lang/toml) localization for Flutter.

TOML is a minimal, easy to read, configuration file format, which allows you to represent [strings](https://github.com/toml-lang/toml#user-content-string) as key/value pairs. That is, as basic, literal or multi-line strings. I believe TOML has the best format to represent a set of strings. Compared to [YAML](https://yaml.org/), strings does not have to be indented, which is an advantage when working with text. 

Consider [csv_localizations](https://github.com/erf/csv_localizations) if you want to support multiple languages in a single file. 

## Usage

See [example](example).

### Install

Add to your `pubspec.yaml`

```yaml
dependencies:
  toml_localizations:
```

### Add a TOML file per language

Add a TOML file per language you support in an asset `path` and describe it in your `pubspec.yaml`

```yaml
flutter:
  assets:
    - {path}/{languageCode}.toml
```

##### Example TOML file

```yaml
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
```

> Tip: Toml supports several ways of expressing strings.  See Toml documentation for more info.

### MaterialApp

Add `TomlLocalizationsDelegate` to `MaterialApp` and set `supportedLocales` using language codes.

```
MaterialApp(
  localizationsDelegates: [
    ... // global delegates
    TomlLocalizationsDelegate(
      TomlLocalizations(
        assetPath: 'toml_translations',
        supportedLanguageCodes: [ 'en', 'nb', ],
      ),
    ),
  ],
  supportedLocales: [ Locale('en'), Locale('nb'), ],
}

```

### API

Translate strings using

```dart
TomlLocalizations.of(context).string('Hi')
```

We keep the API simple, but you can easily add an extension method to `String` like this:

```dart
extension LocalizedString on String {
  String tr(BuildContext context) => TomlLocalizations.of(context).string(this);
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
	<string>nb</string>
</array>
```
