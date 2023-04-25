import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe - How to Play')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objective:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              'The goal of Tic Tac Toe is to be the first player to get three in a row on a 3x3 grid, either horizontally, vertically, or diagonally.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text('Rules:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              '1. The game is played on a 3x3 grid.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '2. The first player uses "X" and the second player uses "O". Players take turns placing their symbols on an empty cell.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '3. The first player to get three of their symbols in a row (horizontally, vertically, or diagonally) wins the game.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '4. If all cells on the grid are filled and no player has three symbols in a row, the game is a draw.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
