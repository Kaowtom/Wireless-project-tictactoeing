import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onStartGame(context),
              child: Text('Start'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/history'),
              child: Text('History'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/how-to-play'),
              child: Text('How to Play'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }

  void onStartGame(BuildContext context) async {
    bool shouldResetScore = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Start Game'),
          content: Text(
              'Do you want to reset the score before starting a new game?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldResetScore == null) return;

    if (shouldResetScore) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('playerXScore', 0);
      await prefs.setInt('playerOScore', 0);
    }

    Navigator.pushNamed(context, '/gameplay');
  }
}
