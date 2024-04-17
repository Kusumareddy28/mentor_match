import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
      ),
      body: Center(
        child: Text(
          'Jobs Screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
