import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF15120D),
        body: Center(
          child: Text(
            'Favorites',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFFDFCE2),
              fontFamily: 'Arial',
            ),
          ),
        ),
      ),
    );
  }
}
