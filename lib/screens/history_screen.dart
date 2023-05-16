import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Room History'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child('rooms').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            // Get the map of game rooms from the snapshot
            Map<dynamic, dynamic> roomsData =
                (snapshot.data?.snapshot.value as Map<dynamic, dynamic>?) ?? {};

            // Create a list of game rooms
            List<Widget> gameRooms = [];
            roomsData.forEach((key, value) {
              // Get the room data with default values for nulls
              String result = value['winner'] ?? 'game is not finished';
              // Create a widget to display the room data
              Widget roomWidget = ListTile(
                title: Text('Room $key'),
                subtitle: Text(result),
              );

              // Add the widget to the list of game rooms
              gameRooms.add(roomWidget);
            });

            // Create a ListView with the list of game rooms
            return ListView(
              children: gameRooms,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
