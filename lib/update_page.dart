import 'package:flutter/material.dart';

class UpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Page'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            // Add your logic here for updating the inventory
          },
          child: Text('Update Inventory'),
        ),
      ),
    );
  }
}
