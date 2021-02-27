import 'package:flutter/material.dart';

const kMainColor = Color(0xFF795548);
const kSubColor = Color(0xFF8D6E63);
const kMainTextColor = Color(0xFF424242);
const kSubTextColor = Color(0xFF616161);

const kLabelTextStyle = TextStyle(
  color: kSubColor,
  fontSize: 14.0,
);

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      brightness: Brightness.light,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kSubTextColor,
          fontSize: 18.0,
        ),
      ),
      iconTheme: IconThemeData(
        color: kMainColor,
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: kMainColor,
      ),
      bodyText2: TextStyle(
        color: kMainColor,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
