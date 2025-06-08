import 'package:flutter/material.dart';

const Color _primaryColor = Color.fromRGBO(0, 0, 0, 1);
const Color _secondaryColor = Color.fromRGBO(226, 168, 61, 1);

final ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: _primaryColor,
    onPrimary: Colors.white, 
    secondary: _secondaryColor,
    onSecondary: Colors.black, 
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.white, 
    onSurface: Colors.black, 
    surfaceContainerHighest: Color.fromARGB(255, 240, 240, 240), 
    onSurfaceVariant: Color.fromARGB(255, 80, 80, 80), 
    tertiary: Colors.black, 
    onTertiary: Colors.black,
    
  ),
  scaffoldBackgroundColor: Colors.white, 
  
);

final ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: _primaryColor, 
    onPrimary: Colors.white,
    secondary: _secondaryColor, 
    onSecondary: Colors.black,
    error: Colors.redAccent,
    onError: Colors.black,
    surface: Color.fromRGBO(0, 0, 0, 1), 
    onSurface: Colors.white, 
    surfaceContainerHighest: Color.fromRGBO(33, 33, 33, 1), 
    onSurfaceVariant: Color.fromARGB(255, 180, 180, 180), 
    tertiary: Color.fromARGB(255, 255, 255, 255),
    onTertiary: Colors.black,
  ),
  scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1), 
  
);