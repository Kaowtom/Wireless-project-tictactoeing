import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/gameplay_screen.dart';
import 'screens/history_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/setting_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatefulWidget {
  @override
  _TicTacToeAppState createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp> {
  ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  );

  ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color.fromARGB(255, 141, 216, 146),
  );

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: isDarkMode ? darkTheme : lightTheme,
      home: HomeScreen(),
      routes: {
        '/gameplay': (context) => GameplayScreen(),
        '/history': (context) => HistoryScreen(),
        '/how-to-play': (context) => HowToPlayScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }

  Future<void> loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDarkMode();
  }
}
