import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "update_page.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Menu',
      theme: ThemeData(
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class MenuItem {
  String name;
  String description;
  List<Map<String, dynamic>> variations;

  MenuItem({required this.name, required this.description, required this.variations});
}

class MenuSection {
  String name;
  List<MenuItem> items;

  MenuSection({required this.name, required this.items});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String restaurantName = "Smoking Pig BBQ - San Jose 4th";
  final TextEditingController sectionNameController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();
  final TextEditingController itemVariationNameController = TextEditingController();
  final TextEditingController itemVariationPriceController = TextEditingController();
  final List<MenuSection> menuSections = [];

  void addMenuItem() {
    setState(() {
      final String sectionName = sectionNameController.text;
      final String itemName = itemNameController.text;
      final String itemDescription = itemDescriptionController.text;
      final String itemVariationName = itemVariationNameController.text;
      final int itemVariationPrice = int.parse(itemVariationPriceController.text);

      // Create a new MenuItem
      MenuItem newItem = MenuItem(
        name: itemName,
        description: itemDescription,
        variations: [
          {
            'name': itemVariationName,
            'price': itemVariationPrice,
          }
        ],
      );

      // Check if the section already exists in the menuSections list
      int sectionIndex = menuSections.indexWhere((section) => section.name == sectionName);
      if (sectionIndex != -1) {
        // Section already exists, add the new item to the existing section
        menuSections[sectionIndex].items.add(newItem);
      } else {
        // Section does not exist, create a new section and add the item
        MenuSection newSection = MenuSection(
          name: sectionName,
          items: [newItem],
        );
        menuSections.add(newSection);
      }

      // Clear the input fields
      itemNameController.clear();
      itemDescriptionController.clear();
      itemVariationNameController.clear();
      itemVariationPriceController.clear();
    });
  }

  void createMenu(BuildContext context) async {
    String apiUrl =
        'https://f15d-50-232-161-119.ngrok-free.app/restaurants/ChIJeQ-ozuLKj4ARMQNfslZXl1c/upsert-menu/';

    // Build the request body using the collected menu data
    Map<String, dynamic> requestBody = {
      "menu_data": menuSections.map((section) {
        return {
          'name': section.name,
          'items': section.items.map((item) {
            return {
              'name': item.name,
              'description': item.description,
              'variations': item.variations,
            };
          }).toList(),
        };
      }).toList(),
    };

    try {
    var response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menu created successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to UpdatePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdatePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create menu. Status code: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error creating menu: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
  }

  @override
  void dispose() {
    sectionNameController.dispose();
    itemNameController.dispose();
    itemDescriptionController.dispose();
    itemVariationNameController.dispose();
    itemVariationPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Menu Item',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: sectionNameController,
                decoration: InputDecoration(labelText: 'Section Name'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: itemDescriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: itemVariationNameController,
                decoration: InputDecoration(labelText: 'Variation Name'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: itemVariationPriceController,
                decoration: InputDecoration(labelText: 'Variation Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: addMenuItem,
                child: Text('Add Item'),
              ),
              SizedBox(height: 32.0),
              Text(
                'Menu Preview',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: menuSections.length,
                itemBuilder: (context, index) {
                  MenuSection section = menuSections[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.name,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: section.items.length,
                        itemBuilder: (context, itemIndex) {
                          MenuItem item = section.items[itemIndex];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(item.description),
                            trailing: Text('\$${item.variations[0]['price']}'),
                          );
                        },
                      ),
                      SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createMenu(context),
        child: Icon(Icons.check),
      ),
    );
  }
}
