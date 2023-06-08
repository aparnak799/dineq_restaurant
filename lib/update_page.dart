import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UpdatePage(),
    );
  }
}

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  List<Map<String, dynamic>> inventoryData = [];

  @override
  void initState() {
    super.initState();
    fetchMenuData();
  }

  Future<void> fetchMenuData() async {
    String apiUrl =
        'http://50.16.17.103:8000/restaurants/ChIJeQ-ozuLKj4ARMQNfslZXl1c/get-menu/';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var menuData = jsonDecode(response.body) as List<dynamic>;
        List<Map<String, dynamic>> newInventoryData = [];

        for (var category in menuData) {
          var items = category['items'] as List<dynamic>;
          for (var item in items) {
            var variations = item['variations'] as List<dynamic>;
            for (var variation in variations) {
              var itemReferenceId = variation['item_reference_id'] as String;
              var variationReferenceId = variation['variation_reference_id'] as String;

              var itemName = itemReferenceId.split('__')[0].substring(1).replaceAll('_', ' ');
              var variationName = variationReferenceId.split('__')[1].replaceAll('_', ' ');

              newInventoryData.add({
                'item_name': itemName,
                'variation_name': variationName,
                'quantity': variation['quantity'],
              });
            }
          }
        }

        setState(() {
          inventoryData = newInventoryData;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch menu data. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching menu data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateInventoryData() async {
    // Prepare the inventory data to be updated
    List<Map<String, dynamic>> updatedInventoryData = [];

    for (var inventoryItem in inventoryData) {
      updatedInventoryData.add({
        'item_reference_id': inventoryItem['item_reference_id'],
        'variation_reference_id': inventoryItem['variation_reference_id'],
        'quantity': inventoryItem['quantity'],
      });
    }

    // Prepare the request body
    var requestBody = {
      'inventory_data': updatedInventoryData,
    };

    // Make the API call to update the inventory
    var apiUrl =
        'http://50.16.17.103:8000/restaurants/ChIJeQ-ozuLKj4ARMQNfslZXl1c/update-inventory/';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successfully updated the inventory
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inventory updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Failed to update the inventory
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update inventory. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating inventory: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: ListView.builder(
        itemCount: inventoryData.length,
        itemBuilder: (context, index) {
          var inventoryItem = inventoryData[index];
          return ListTile(
            title: Text('Item: ${inventoryItem['item_name']}'),
            subtitle: Text('Variation: ${inventoryItem['variation_name']}'),
            trailing: Text('Quantity: ${inventoryItem['quantity']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          updateInventoryData();
        },
        label: Text('Update Inventory'),
        icon: Icon(Icons.update),
      ),
    );
  }
}
