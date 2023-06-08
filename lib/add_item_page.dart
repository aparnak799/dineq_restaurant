import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

const String place_id = "ChIJeQ-ozuLKj4ARMQNfslZXl1c";
class AddItemPage extends StatefulWidget {
  final Function refreshCallback;

  AddItemPage(this.refreshCallback);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}


class _AddItemPageState extends State<AddItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _variationNameController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> addMenuItem() async {
    String apiUrl =
        'http://50.16.17.103:8000/restaurants/$place_id/upsert-menu/';

    Map<String, dynamic> requestBody = {
      "menu_data": [
        {
          "name": "Appetizers",
          "items": [
            {
              "name": _nameController.text,
              "description": _descriptionController.text,
              "variations": [
                {
                  "name": _variationNameController.text,
                  "price": int.parse(_priceController.text),
                },
              ],
            },
          ],
        },
      ],
    };

    try {
      print('API URL: $apiUrl');
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        widget.refreshCallback();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add item. Status code: ${response.statusCode}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Menu Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an item name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _variationNameController,
              decoration: InputDecoration(
                labelText: 'Variation Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a variation name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            ElevatedButton(
              child: Text('Add Item'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  addMenuItem();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
