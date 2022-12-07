import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(ThemeMode.light);
  final SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get getCurrentTheme => loadThemeMode();

  void switchTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      saveThemeMode();
      emit(getCurrentTheme);
    } else {
      _themeMode = ThemeMode.light;
      saveThemeMode();
      emit(getCurrentTheme);
    }
  }

  ThemeMode loadThemeMode() {
    if (_prefs.containsKey('themeState')) {
      return _prefs.getString('themeState') == 'light'
          ? ThemeMode.light
          : ThemeMode.dark;
    }
    return _themeMode;
  }

  void saveThemeMode() => _prefs.setString("themeState", _themeMode.name);

}
