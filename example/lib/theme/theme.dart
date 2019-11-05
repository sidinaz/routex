import 'package:flutter/material.dart';

class AppTheme  {

  static ThemeData get instance => ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Color(0xFF2C3E50),
    accentColor: Color(0xFFf4b512),
    scaffoldBackgroundColor: Color(0xFF18BC9C),
    buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFFf4b512)
    ),

    // Define the default font family.
    fontFamily: 'Montserrat',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic, color: Colors.white),
      body1: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
      body2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

}
