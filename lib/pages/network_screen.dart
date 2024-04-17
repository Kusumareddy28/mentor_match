import 'package:flutter/material.dart';

class NetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network'),
      ),
      body: Center(
        child: Text(
          'Network Screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
