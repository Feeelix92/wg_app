import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../model/shoppingItem.dart';

@RoutePage()
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key, @PathParam('householdId') required this.householdId });
  final int householdId;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedPerson = '';

  void addShoppingItem() {
    String title = _titleController.text;
    String description = _descriptionController.text;
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    double price = double.tryParse(_priceController.text) ?? 0.0;
    String assignedTo = _selectedPerson;

    // Füge das Element der Einkaufsliste hinzu (kann auch Firebase-Speicherung enthalten)
    setState(() {
      Household currentHousehold = TestData.houseHoldData[widget.householdId];
      currentHousehold.shoppingList.add(
        ShoppingItem(
          title: title,
          description: description,
          quantity: quantity,
          price: price,
          assignedTo: assignedTo,
        ),
      );
    });

    Navigator.pop(context); // Gehe zurück zum Detail-Screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einkaufselement hinzufügen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Beschreibung'),
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Menge'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Preis'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedPerson,
              items: TestData.houseHoldData[widget.householdId].members
                  .map((person) => DropdownMenuItem(
                value: person,
                child: Text(person),
              ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPerson = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'Zugewiesen an'),
            ),
            ElevatedButton(
              onPressed: addShoppingItem,
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }
}
