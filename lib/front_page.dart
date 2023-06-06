import 'package:flutter/material.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Front'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Restaurant Front Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
