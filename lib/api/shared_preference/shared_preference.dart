import 'package:flutter/material.dart';
import 'package:learncoding/api/shared_preference/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:learncoding/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<bool> setuser(String image, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("image", image);
    prefs.setString("name", name);

    return true;
  }


  static Future<bool> settheme(bool theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('true',theme);
  

    return true;
  }

  

  ThemeData _darktheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.dark
  );

  ThemeData _lighttheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light
  );

  static Future<User> getuser(String image, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    // Image? image = prefs.getString("image");
    return User(name: name, image: image);
  }

}
