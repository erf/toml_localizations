# toml_localizations

A minimal [TOML](https://github.com/toml-lang/toml) localization package for
Flutter.

TOML is a minimal, easy to read, configuration file format, which allows you to
represent [strings](https://github.com/toml-lang/toml#user-content-string) (and
other types) as key/value pairs.

## Usage

See [example](example).

### Install

Add to your `pubspec.yaml`

```yaml
dependencies:
  toml_localizations:
```

### Add a TOML file per language

Add a TOML file per language you support in an asset `path` and describe it in
your `pubspec.yaml`

```yaml
flutter:
  assets:
    - assets/toml_translations
```

The TOML file name must match exactly the combination of language and country
code described in `supportedLocales`.

That is `Locale('en', 'US')` must have a corresponding `assetPath/en-US.toml`
file.

##### Example TOML file

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

> Tip: Toml supports several ways of expressing strings. See Toml documentation
> for more info.

### MaterialApp

Add `TomlLocalizationsDelegate` to `MaterialApp` and set `supportedLocales`
using language/country codes.

```
MaterialApp(
  localizationsDelegates: [
    ... // global delegates
    TomlLocalizationsDelegate('assets/toml_translations')
  ],
  supportedLocales: [
    Locale('en', 'GB'),
    Locale('en', 'US'),
    Locale('en'),
    Locale('nb'),
  ],
}
```

### API

Translate strings or other types using

```Dart
TomlLocalizations.of(context)!.value('Hi')
```

We keep the API simple, but you can easily add an extension method to `String`
like this:

```Dart
extension LocalizedString on String {
  String tr(BuildContext context) => TomlLocalizations.of(context)!.value(this);
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
