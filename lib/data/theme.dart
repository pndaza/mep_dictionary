import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class MyTheme {
  
  static final white = AppTheme(
      id: "white",
      description: "အဖြူရောင်",
      data: ThemeData(
        accentColor: Colors.blue,
        primaryColor: Colors.grey[50],
        scaffoldBackgroundColor: Colors.grey[50],
        buttonColor: Colors.grey[400],
        dialogBackgroundColor: Colors.grey[200],
        cardColor: Colors.white,
        fontFamily: 'NotoSansMyanmar'
      ));

  static final black = AppTheme(
    id: "black",
    description: "အမဲရောင်",
    data: ThemeData(
        accentColor: Colors.orange,
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[900],
        buttonColor: Colors.grey[400],
        dialogBackgroundColor: Colors.grey,
        cardColor: Colors.grey[800],
        fontFamily: 'NotoSansMyanmar',
        textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.white),
            subtitle1: TextStyle(color: Colors.white))),
  );

  static List<AppTheme> fetchAll() {
    return [white, black, ];
  }
}
