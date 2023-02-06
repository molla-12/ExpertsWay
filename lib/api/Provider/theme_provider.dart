import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  ThemeModel(bool isDark){
      if(isDark){
          _currentTheme = ThemeData.dark();
      }
      else{
        _currentTheme = ThemeData.light();
      }
  }

  void Theme() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    if (_currentTheme == ThemeData.light()) {
      _currentTheme = ThemeData.dark();
      pre.setBool('is_dark', true);
    } else {
      _currentTheme = ThemeData.light();
      pre.setBool('is_dark', false);
    }

    notifyListeners();
  }

  
}
