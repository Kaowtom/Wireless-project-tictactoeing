import 'package:flutter/material.dart';
import 'game_room_selection_screen.dart';
import 'fixed_size_button.dart';

class HomeScreen extends StatelessWidget {
  void _navigateToGameRoomSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameRoomSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FixedSizeButton(
              onPressed: () => _navigateToGameRoomSelection(context),
              child: Text('Start Game'),
            ),
            SizedBox(height: 20),
            FixedSizeButton(
              onPressed: () => Navigator.pushNamed(context, '/history'),
              child: Text('History'),
            ),
            SizedBox(height: 20),
            FixedSizeButton(
              onPressed: () => Navigator.pushNamed(context, '/how-to-play'),
              child: Text('How to Play'),
            ),
            SizedBox(height: 20),
            FixedSizeButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
