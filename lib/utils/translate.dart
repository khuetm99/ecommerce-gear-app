import 'dart:convert';
import 'package:ecommerce_app/app_locale_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Translate {
  final Locale locale;

  Translate(this.locale);

  static Translate? of(BuildContext context) {
    return Localizations.of<Translate>(context, Translate);
  }

  static const LocalizationsDelegate<Translate> delegate = AppLocaleDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String content = await rootBundle.loadString("assets/locale/${locale.languageCode}.json");
    Map<String, dynamic> jsonMap = jsonDecode(content);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
