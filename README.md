# toml_localizations

A minimal [TOML](https://github.com/toml-lang/toml) localization package for Flutter.

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
str1 = "The quick brown fox jumps over the lazy dog."
winpath  = 'C:\Users\nodejs\templates'
regex2 = '''I [dw]on't need \d{2} apples'''
str2 = """\
The quick brown \
fox jumps over \
the lazy dog.\
"""
str3  = '''
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
