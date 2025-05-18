import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 151, 115, 156),
  hintColor: const Color.fromARGB(255, 229, 200, 243),
  focusColor: Colors.grey,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 151, 115, 156),
  ),
);

final ThemeData highContrastLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 94, 63, 119),
  hintColor: const Color.fromARGB(255, 172, 135, 190),
  focusColor: const Color.fromARGB(255, 83, 83, 83),
  colorScheme: const ColorScheme.highContrastLight(),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 88, 55, 114),
  hintColor: const Color.fromARGB(255, 122, 90, 139),
  focusColor: const Color.fromARGB(255, 49, 49, 49),
  colorScheme: const ColorScheme.dark(surface: Color.fromARGB(255, 63, 63, 63)),
);

final ThemeData highContrastDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 84, 45, 114),
  hintColor: const Color.fromARGB(255, 150, 114, 170),
  focusColor: const Color.fromARGB(255, 204, 204, 204),
  colorScheme: const ColorScheme.highContrastDark(),
);
