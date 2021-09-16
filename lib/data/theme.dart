import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();
  static ThemeData get light => ThemeData.from(
      colorScheme: ColorScheme.light(
          primary: const Color(0xffc62828),
          secondary: const Color(0xffc62828)));
  static ThemeData get dark => ThemeData.from(
      colorScheme: ColorScheme.dark(
          primary: const Color(0xff004d40),
          onPrimary: const Color(0xffffffff)));
}
