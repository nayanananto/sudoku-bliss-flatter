import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_screen.dart';
import 'DatabaseClass.dart';
import 'game_mode.dart';
import 'game_screen.dart';
import 'instruction.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku Game'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM8Hew8cRa8Gk5FOw5GMbbf1Numi4bWXGx-A&usqp=CAU',
              height: 150,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DatabaseClass()),
                );
              },
              child: Text('Load Game'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Times t = new Times();
                t.setTime(0);
                t.setBoard("[]");
                t.setId(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Menu()),
                );
              },
              child: Text('New Game'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Text('Settings'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InstructionsScreen()),
                );
              },
              child: Text('Instructions'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exit the app
                SystemNavigator.pop();
              },
              child: Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}

