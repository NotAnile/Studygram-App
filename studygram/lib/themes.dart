import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 151, 115, 156),
  primaryColorLight: const Color.fromARGB(255, 151, 115, 156),
  primaryColorDark: const Color.fromARGB(255, 169, 147, 187),
  hintColor: const Color.fromARGB(255, 229, 200, 243),
  focusColor: Colors.grey,
  highlightColor: const Color.fromARGB(255, 252, 252, 252),
  cardColor: const Color.fromARGB(222, 255, 255, 255),
  colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 151, 115, 156),
      surface: Color.fromARGB(255, 231, 231, 231),
      surfaceContainerHighest: Color.fromARGB(255, 235, 234, 234)),
);

final ThemeData highContrastLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 94, 63, 119),
  primaryColorLight: const Color.fromARGB(255, 162, 116, 200),
  primaryColorDark: const Color.fromARGB(255, 69, 49, 85),
  hintColor: const Color.fromARGB(255, 159, 130, 173),
  focusColor: const Color.fromARGB(255, 83, 83, 83),
  highlightColor: const Color.fromARGB(255, 255, 255, 255),
  cardColor: const Color.fromARGB(222, 211, 211, 211),
  colorScheme: const ColorScheme.highContrastLight(
      primary: Color.fromARGB(255, 94, 63, 119),
      surface: Colors.white,
      surfaceContainerHighest: Color.fromARGB(255, 217, 217, 217)),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 120, 82, 133),
  hintColor: const Color.fromARGB(255, 178, 165, 185),
  primaryColorLight: const Color.fromARGB(255, 122, 85, 151),
  primaryColorDark: const Color.fromARGB(255, 83, 56, 105),
  focusColor: const Color.fromARGB(255, 134, 112, 160),
  highlightColor: const Color.fromARGB(255, 210, 205, 215),
  cardColor: const Color.fromARGB(222, 82, 81, 81),
  colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 151, 113, 181),
      surface: Color.fromARGB(255, 47, 47, 47),
      surfaceContainerHighest: Color.fromARGB(255, 75, 75, 75)),
);

final ThemeData highContrastDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 155, 118, 185),
  primaryColorLight: const Color.fromARGB(255, 190, 149, 221),
  primaryColorDark: const Color.fromARGB(255, 120, 84, 148),
  hintColor: const Color.fromARGB(255, 188, 145, 211),
  focusColor: const Color.fromARGB(255, 204, 204, 204),
  highlightColor: const Color.fromARGB(255, 235, 235, 235),
  cardColor: const Color.fromARGB(222, 126, 126, 126),
  colorScheme: const ColorScheme.highContrastDark(
      primary: Color.fromARGB(255, 185, 153, 209),
      surfaceContainerHighest: Color.fromARGB(255, 75, 75, 75)),
);
