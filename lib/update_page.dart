import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'front_page.dart';

class UpdatePage extends StatelessWidget {
  Future<void> updateInventory(BuildContext context) async {
    String apiUrl = 'https://fec0-2601-644-9381-d770-35b1-e3a1-45c2-94be.ngrok-free.app/restaurants/ChIJeQ-ozuLKj4ARMQNfslZXl1c/update-inventory/';

    // Define the inventory data
    List<Map<String, dynamic>> inventoryData = [
      {
        "item_reference_id": "#Fried_Calamari__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "variation_reference_id": "#Fried_Calamari__Regular__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "quantity": 50
      },
      {
        "item_reference_id": "#Fried_Calamari__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "variation_reference_id": "#Fried_Calamari__Large__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "quantity": 40
      },
      {
        "item_reference_id": "#Bruschetta__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "variation_reference_id": "#Bruschetta__Regular__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "quantity": 30
      },
      {
        "item_reference_id": "#Spaghetti_Carbonara__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "variation_reference_id": "#Spaghetti_Carbonara__Regular__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "quantity": 30
      },
      {
        "item_reference_id": "#Margherita_Pizza__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "variation_reference_id": "#Margherita_Pizza__Regular__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "quantity": 70
      },
      {
        "item_reference_id": "#Margherita_Pizza__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "variation_reference_id": "#Margherita_Pizza__Large__ChIJeQ-ozuLKj4ARMQNfslZXl1c",
        "quantity": 20
      }
    ];

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"inventory_data": inventoryData}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inventory updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
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
        title: Text('Update Inventory'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Inventory Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildInventoryItem('Fried Calamari', 'Regular', 50),
                _buildInventoryItem('Fried Calamari', 'Large', 40),
                _buildInventoryItem('Bruschetta', 'Regular', 30),
                _buildInventoryItem('Spaghetti Carbonara', 'Regular', 30),
                _buildInventoryItem('Margherita Pizza', 'Regular', 70),
                _buildInventoryItem('Margherita Pizza', 'Large', 20),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => updateInventory(context),
            child: Text('Update Inventory'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FrontPage()),
              );
            },
            child: Text('Restaurant Front'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(String item, String variation, int quantity) {
    return ListTile(
      title: Text(item),
      subtitle: Text(variation),
      trailing: Text('Quantity: $quantity'),
    );
  }
}
