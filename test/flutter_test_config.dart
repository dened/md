import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadAppFonts();

  await testMain();
}

Future<void> loadAppFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fontManifest = await rootBundle.loadStructuredData<List<Object?>>(
    'FontManifest.json',
    (string) async => json.decode(string) as List<Object?>,
  );

  for (final font in fontManifest) {
    if (font
        case {'family': final String _, 'fonts': final List<Object?> fonts}) {
      final fontLoader =
          FontLoader(derivedFontFamily(font as Map<String, Object?>));
      for (final fontType in fonts) {
        if (fontType case {'asset': final String asset}) {
          fontLoader.addFont(rootBundle.load(asset));
        }
      }
      await fontLoader.load();
    }
  }
}

/// There is no way to easily load the Roboto or Cupertino fonts.
/// To make them available in tests,
/// a package needs to include their own copies of them.
///
/// GoldenToolkit supplies Roboto because it is free to use.
///
/// However, when a downstream package includes a font,
/// the font family will be prefixed with
/// /packages/<package name>/<fontFamily> in order to disambiguate
/// when multiple packages include fonts with the same name.
///
/// Ultimately, the font loader will load whatever we tell it,
/// so if we see a font that looks like
/// a Material or Cupertino font family, let's treat it as the main font family
@visibleForTesting
String derivedFontFamily(Map<String, Object?> fontDefinition) {
  switch (fontDefinition) {
    case {
        'family': final String fontFamily,
        'fonts': final List<Object?> fonts
      }:
      if (_overridableFonts.contains(fontFamily)) {
        return fontFamily;
      }

      if (fontFamily.startsWith('packages/')) {
        final fontFamilyName = fontFamily.split('/').last;
        if (_overridableFonts.any((font) => font == fontFamilyName)) {
          return fontFamilyName;
        }
      } else {
        for (final fontType in fonts) {
          if (fontType case {'asset': final String asset}) {
            if (asset.startsWith('packages')) {
              final packageName = asset.split('/')[1];
              return 'packages/$packageName/$fontFamily';
            }
          }
        }
      }
      return fontFamily;
    default:
      return '';
  }
}

const List<String> _overridableFonts = [
  'Roboto',
  '.SF UI Display',
  '.SF UI Text',
  '.SF Pro Text',
  '.SF Pro Display',
];
