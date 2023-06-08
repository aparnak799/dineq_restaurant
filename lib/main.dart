import 'package:dineq_restaurant/add_item_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "update_page.dart";
import "add_item_page.dart";
import "update_inventory.dart";

const String place_id = "ChIJeQ-ozuLKj4ARMQNfslZXl1c";
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class MenuSection {
  final String name;
  final List<MenuItem> items;

  MenuSection({required this.name, required this.items});
}

class MenuItem {
  final String name;
  final List<MenuVariation> variations;

  MenuItem({required this.name, required this.variations});
}

class MenuVariation {
  final String name;
  final int quantity;
  final int price;

  MenuVariation(
      {required this.name, required this.quantity, required this.price});
}

class _HomePageState extends State<HomePage> {
  final String restaurantName = "Smoking Pig BBQ - San Jose 4th";
  List<MenuSection> menuSections = [];
  List<dynamic> menuData = [];

  @override
  void initState() {
    super.initState();
    getMenuData();
  }

  Future<void> updateInventory(List<Map<String, dynamic>> inventoryData) async {
    String apiUrl =
        'http://50.16.17.103:8000/restaurants/$place_id/update-inventory/';

    try {
      print('Sending inventory data: ${jsonEncode({
            "inventory_data": inventoryData
          })}');
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({"inventory_data": inventoryData}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        getMenuData();
        print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inventory updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update inventory. Status code: ${response.statusCode}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating inventory: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getMenuData() async {
    String apiUrl = 'http://50.16.17.103:8000/restaurants/$place_id/get-menu/';
    print('the url is $apiUrl');
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> menuData = jsonDecode(response.body);
        List<MenuSection> newMenuSections = menuData.map((sectionData) {
          List<MenuItem> items = sectionData['items'].map<MenuItem>((itemData) {
            return MenuItem(
              name: itemData['name'],
              variations: List<MenuVariation>.from(itemData['variations'].map(
                  (variationData) => MenuVariation(
                      name: variationData['name'],
                      quantity: variationData['quantity'],
                      price: (double.parse(variationData['price'].toString()) *
                              100)
                          .round()))),
            );
          }).toList();

          return MenuSection(name: sectionData['name'], items: items);
        }).toList();

        setState(() {
          setState(() {
            menuSections.clear();
            menuSections.addAll(newMenuSections);
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to fetch menu. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching menu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showReleaseSeatsDialog() async {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Release Seats'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter number of seats'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () async {
                if (controller.text.isNotEmpty &&
                    int.tryParse(controller.text) != null) {
                  var response = await releaseSeats(int.parse(controller.text));
                  if (response) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Seats released successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to release seats'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid number'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> releaseSeats(int seats) async {
    String apiUrl =
        'http://50.16.17.103:8000/restaurants/$place_id/release-seats/';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'seats_released': seats}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _showCheckoutDialog() {
    TextEditingController _uoiController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Checkout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _uoiController,
                decoration: InputDecoration(
                  labelText: 'Enter UOI',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String uoi = _uoiController.text.trim();
                if (uoi.isNotEmpty) {
                  Navigator.pop(context);
                  _checkout(uoi);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid UOI'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  void _checkout(String uoi) async {
    String apiUrl = 'http://50.16.17.103:8000/restaurants/$place_id/checkout/';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'uoi': uoi}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Payment Successful'),
              content: Text('Thank you for your payment!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to process payment. Status code: ${response.statusCode}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> refreshMenuData() async {
    await getMenuData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
      ),
      body: Column(
        children: [
          SizedBox(height: 20), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    _showReleaseSeatsDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Release Seats'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    _showCheckoutDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Checkout'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: menuSections.length,
              itemBuilder: (context, index) {
                MenuSection section = menuSections[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey[200],
                      child: Text(
                        section.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: section.items.length,
                      itemBuilder: (context, itemIndex) {
                        MenuItem item = section.items[itemIndex];
                        int totalQuantity = item.variations.fold(
                          0,
                          (previousValue, variation) =>
                              previousValue + variation.quantity,
                        );
                        return ListTile(
                          title: Text(item.name),
                          subtitle:
                              Text('Total Inventory Count: $totalQuantity'),
                          trailing: Text(
                            '\$${(item.variations[0].price / 100).toStringAsFixed(2)}',
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Item'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddItemPage(refreshMenuData),
                        ),
                      ).then((_) {
                        getMenuData();
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.update),
                    title: Text('Update Inventory'),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UpdateInventoryDialog(
                            onSubmit: updateInventory,
                            menuData: menuData,
                            placeId: place_id,
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
