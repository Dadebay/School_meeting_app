import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum Locales {
  en(Locale('en', 'US'));

  final Locale locale;
  const Locales(this.locale);
}

@immutable
class ProductLocalization extends EasyLocalization {
  ProductLocalization({
    required super.child,
    super.key,
  }) : super(
          supportedLocales: _supportedItems,
          path: _translationPath,
          useOnlyLangCode: true,
        );

  static final List<Locale> _supportedItems = [
    Locales.en.locale,
  ];

  static const String _translationPath = 'assets/translations';

  static Future<void> updateLanguage({
    required BuildContext context,
    required Locales locale,
  }) =>
      context.setLocale(locale.locale);
}
