import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _localeBoxName = 'secure_plus_settings';
const String _localeKey = 'locale';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSaved();
  }

  void _loadSaved() {
    try {
      final box = Hive.box(_localeBoxName);
      final code = box.get(_localeKey) as String?;
      if (code != null && (code == 'en' || code == 'my')) {
        emit(Locale(code));
      }
    } catch (_) {}
  }

  void setLocale(Locale locale) {
    if (locale.languageCode == 'en' || locale.languageCode == 'my') {
      emit(locale);
      try {
        Hive.box(_localeBoxName).put(_localeKey, locale.languageCode);
      } catch (_) {}
    }
  }

  void setEnglish() => setLocale(const Locale('en'));
  void setMyanmar() => setLocale(const Locale('my'));
}
