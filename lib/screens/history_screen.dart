import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int xScore = 0;
  int oScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe - History Match')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Player X: $xScore', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Player O: $oScore', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Future<void> loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      xScore = prefs.getInt('xScore') ?? 0;
      oScore = prefs.getInt('oScore') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadScores();
  }
}
