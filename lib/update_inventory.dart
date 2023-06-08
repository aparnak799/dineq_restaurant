import 'package:flutter/material.dart';

class UpdateInventoryDialog extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onSubmit;
  final List<dynamic> menuData;
  final String placeId;
  final List<Map<String, dynamic>> inventoryData = [];

  UpdateInventoryDialog(
      {required this.onSubmit, required this.menuData, required this.placeId});

  @override
  _UpdateInventoryDialogState createState() => _UpdateInventoryDialogState();
}

class _UpdateInventoryDialogState extends State<UpdateInventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _variationNameController = TextEditingController();
  final _quantityController = TextEditingController();

  List<String> generateReferenceId(
    String itemName, String variationName, String placeId) {
  String itemReferenceId = "#${itemName.replaceAll(' ', '_')}__$placeId";
  print('Item Name: $itemName'); 
  print('Item Reference Id: $itemReferenceId'); 

  String variationReferenceId =
      "#${itemName.replaceAll(' ', '_')}__${variationName.replaceAll(' ', '_')}__$placeId";
  print('Variation Name: $variationName'); 
  print('Variation Reference Id: $variationReferenceId'); 

  return [itemReferenceId, variationReferenceId];
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Inventory'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _itemNameController,
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
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
                TextButton(
                    onPressed: () {
                        if (_formKey.currentState!.validate()) {
                            List<String> ids = generateReferenceId(_itemNameController.text,
                                _variationNameController.text, widget.placeId);

                            widget.inventoryData.add({
                                'item_reference_id': ids[0],
                                'variation_reference_id': ids[1],
                                'quantity': int.parse(_quantityController.text),
                            });
                            print(widget.inventoryData);

                            _itemNameController.clear();
                            _variationNameController.clear();
                            _quantityController.clear();
                            setState(() {});

                            widget.onSubmit(widget.inventoryData);
                            Navigator.of(context).pop();
                        }
                    },
                    child: Text('Update'),
                ),
            ],
        );
    }
}
