import 'package:flutter/material.dart';
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0D0E),
      body: Stack(
          children: [Center(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('images/logo.png'),
            ),
          ),
          ]
      ),
    );
  }
}