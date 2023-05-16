import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'gameplay_screen.dart';
import 'fixed_size_button.dart';

class GameRoomSelectionScreen extends StatefulWidget {
  @override
  GameRoomSelectionScreenState createState() => GameRoomSelectionScreenState();
}

class GameRoomSelectionScreenState extends State<GameRoomSelectionScreen> {
  final _roomIDController = TextEditingController();

  Future<void> _createGameRoom(BuildContext context) async {
    int roomNumber = 10000 + Random().nextInt(90000);
    DatabaseReference roomRef = FirebaseDatabase.instance
        .ref()
        .child('rooms')
        .child(roomNumber.toString());

    List<String> board = List.filled(9, '');

    try {
      await roomRef.set({
        'player1': 'Player 1',
        'player2': '',
        'board': board,
        'isPlayerOneTurn': true,
        'gameOver': false,
        'winner': '',
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GameplayScreen(roomID: roomNumber.toString(), isNewRoom: true),
        ),
      );
    } catch (e) {
      debugPrint('Error setting data in Realtime Database: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating game room. Please try again.'),
        ),
      );
    }
  }

  Future<void> _joinGameRoom(String roomNumber) async {
    DatabaseReference roomRef =
        FirebaseDatabase.instance.ref().child('rooms').child(roomNumber);

    DataSnapshot roomSnapshot =
        await roomRef.once().then((event) => event.snapshot);

    if (roomSnapshot.value != null) {
      roomRef.update({'player2': 'Player 2'});

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GameplayScreen(roomID: roomNumber, isNewRoom: false),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Game room not found. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Room Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FixedSizeButton(
              onPressed: () async {
                await _createGameRoom(context);
              },
              child: Text('Create Game Room'),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: TextField(
                controller: _roomIDController,
                decoration: InputDecoration(
                  labelText: 'Enter Room Number',
                ),
              ),
            ),
            FixedSizeButton(
              onPressed: _joinGameRoomButtonPressed,
              child: Text('Join Game Room'),
            ),
          ],
        ),
      ),
    );
  }

  void _joinGameRoomButtonPressed() {
    _joinGameRoom(_roomIDController.text);
  }

  @override
  void dispose() {
    _roomIDController.dispose();
    super.dispose();
  }
}
