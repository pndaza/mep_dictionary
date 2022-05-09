import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();
  static ThemeData get light => ThemeData.from(
      colorScheme: const ColorScheme.light(
          primary: Color(0xffc62828), secondary: Color(0xffc62828)));
  static ThemeData get dark => ThemeData.from(
      colorScheme: const ColorScheme.dark(
          primary: Color(0xff004d40), onPrimary: Color(0xffffffff)));
}
