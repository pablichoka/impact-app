import 'package:flutter/material.dart';
import 'package:impact/screens/init.dart';
import 'package:impact/screens/home.dart';
import 'package:impact/theme_data.dart';
import 'package:intl/date_symbol_data_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact',
      theme: lightThemeData, 
      darkTheme: darkThemeData, 
      themeMode: ThemeMode.system, 
      home: const InitScreen(),
      routes: {
        '/init': (context) => const InitScreen(),
        '/home': (context) => const HomeScreen(),        
      },
    );
  }
}