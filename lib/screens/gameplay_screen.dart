import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameplayScreen extends StatefulWidget {
  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  int xScore = 0;
  int oScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe - Gameplay')),
      body: Center(
        child: SingleChildScrollView(
          // Add this SingleChildScrollView widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildScoreBoard(),
              SizedBox(height: 20),
              buildBoard(),
              SizedBox(height: 20),
              buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => buildCell(index),
          itemCount: board.length,
        ),
      ),
    );
  }

  Widget buildCell(int index) {
    return GestureDetector(
      onTap: () => onCellTap(index),
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildResetButton() {
    return ElevatedButton(
      onPressed: () => resetBoard(),
      child: Text('Reset Board'),
    );
  }

  onCellTap(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = currentPlayer;
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      });

      if (checkWinner()) {
        if (currentPlayer == 'X') {
          oScore++;
        } else {
          xScore++;
        }
        saveScores();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Winner"),
              content: Text("Player ${currentPlayer == 'X' ? 'O' : 'X'} won!"),
              actions: [
                TextButton(
                  onPressed: () {
                    resetBoard();
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                )
              ],
            );
          },
        );
      }
    }
  }

  bool checkWinner() {
    // Horizontal and vertical checks
    for (int i = 0; i < 3; i++) {
      if ((board[i * 3] == board[i * 3 + 1]) &&
          (board[i * 3 + 1] == board[i * 3 + 2]) &&
          (board[i * 3] != '')) {
        return true;
      }
      if ((board[i] == board[i + 3]) &&
          (board[i + 3] == board[i + 6]) &&
          (board[i] != '')) {
        return true;
      }
    }

    // Diagonal checks
    if ((board[0] == board[4]) && (board[4] == board[8]) && (board[0] != '')) {
      return true;
    }
    if ((board[2] == board[4]) && (board[4] == board[6]) && (board[2] != '')) {
      return true;
    }

    return false;
  }

  void resetBoard() {
    setState(() {
      board = List.filled(9, '');
    });
  }

  Widget buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('X: $xScore', style: TextStyle(fontSize: 20)),
        SizedBox(width: 20),
        Text('O: $oScore', style: TextStyle(fontSize: 20)),
      ],
    );
  }

  Future<void> saveScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xScore', xScore);
    await prefs.setInt('oScore', oScore);
  }

  Future<void> loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      xScore = prefs.getInt('playerXScore') ?? 0;
      oScore = prefs.getInt('playerOScore') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    resetBoard();
    loadScores();
  }
}
