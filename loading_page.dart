import 'package:flutter/material.dart';

import 'home_page.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    // Add a delay to navigate to the Homepage after 2 seconds
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the Homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SUDOKU',
              style: TextStyle(
                fontSize: 40, // adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM8Hew8cRa8Gk5FOw5GMbbf1Numi4bWXGx-A&usqp=CAU',
              height: 150,
            ),
            SizedBox(height: 15),
            Text(
              'Keep your mind sharp',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),

    );
  }
}
