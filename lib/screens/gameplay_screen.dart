import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GameplayScreen extends StatefulWidget {
  final String roomID;
  final bool isNewRoom;

  GameplayScreen({required this.roomID, required this.isNewRoom});

  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  DatabaseReference roomRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    if (widget.isNewRoom) {
      createNewRoom(widget.roomID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe - Gameplay')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Room ID: ${widget.roomID}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              buildBoard(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBoard() {
    return StreamBuilder<DataSnapshot>(
      stream: gameRoomStream,
      builder: (context, snapshot) {
        Map<dynamic, dynamic>? data;

        if (snapshot.hasData && snapshot.data!.value != null) {
          data = snapshot.data!.value as Map<dynamic, dynamic>;
          List<String> board =
              List<String>.from(data['board'].map((value) => value ?? ''));
          String? winner = calculateWinner(board);

          if (winner != null) {
            // Update the Realtime Database with winner information
            DatabaseReference roomRef = FirebaseDatabase.instance
                .ref()
                .child('rooms')
                .child(widget.roomID);
            roomRef.update({
              'winner': winner,
              'currentPlayer': '',
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (winner == null)
                AspectRatio(
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
                      itemBuilder: (context, index) => buildCell(index, board),
                      itemCount: board.length,
                    ),
                  ),
                )
              else
                Text(
                  winner == 'Tie' ? 'It\'s a tie!' : '$winner wins!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildCell(int index, List<String> board) {
    return GestureDetector(
      onTap: () => _markSquare(index),
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            board[index] == '5' ? '' : board[index],
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Stream<DataSnapshot> get gameRoomStream {
    return FirebaseDatabase.instance
        .ref()
        .child('rooms')
        .child(widget.roomID)
        .onValue
        .map((event) => event.snapshot);
  }

  Future<void> _markSquare(int index) async {
    DatabaseReference roomRef =
        FirebaseDatabase.instance.ref().child('rooms').child(widget.roomID);

    roomRef.once().then((event) {
      DataSnapshot roomSnapshot = event.snapshot;

      Map<dynamic, dynamic> roomData =
          roomSnapshot.value as Map<dynamic, dynamic>;

      List<String> board = List<String>.from(roomData['board'].cast<String>());
      if (board[index] == '5') {
        board[index] = roomData['currentPlayer'];
        String newCurrentPlayer = roomData['currentPlayer'] == 'X' ? 'O' : 'X';

        // Check for a win
        bool hasWinner = checkForWinner(board);
        if (hasWinner) {
          // Update the Realtime Database with winner information
          roomRef.update({
            'board': board,
            'currentPlayer': '',
            'winner': currentPlayer,
          });
        } else {
          // Update the Realtime Database
          roomRef.update({
            'board': board,
            'currentPlayer': newCurrentPlayer,
          });
        }
      }
    });
  }

  String? calculateWinner(List<String> board) {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (List<int> combination in winningCombinations) {
      String firstValue = board[combination[0]];
      if (firstValue != '5' &&
          board[combination[1]] == firstValue &&
          board[combination[2]] == firstValue) {
        return firstValue;
      }
    }

    if (!board.contains('5')) {
      return 'Tie';
    }

    return null;
  }

  bool checkForWinner(List<String> board) {
    // Check rows
    for (int i = 0; i <= 6; i += 3) {
      if (board[i] != '5' &&
          board[i] == board[i + 1] &&
          board[i + 1] == board[i + 2]) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i <= 2; i++) {
      if (board[i] != '5' &&
          board[i] == board[i + 3] &&
          board[i + 3] == board[i + 6]) {
        return true;
      }
    }

    // Check diagonals
    if (board[0] != '5' && board[0] == board[4] && board[4] == board[8]) {
      return true;
    }
    if (board[2] != '5' && board[2] == board[4] && board[4] == board[6]) {
      return true;
    }

    // No winner found
    return false;
  }

  Future<void> createNewRoom(String roomID) async {
    DatabaseReference roomRef =
        FirebaseDatabase.instance.ref().child('rooms').child(roomID);

    await roomRef.set({
      'currentPlayer': 'X',
      'board': List.filled(9, '5'),
    });
  }
}
