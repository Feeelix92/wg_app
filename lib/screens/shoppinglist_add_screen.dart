import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../model/shoppingItem.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';

@RoutePage()
class ShoppingListAddScreen extends StatefulWidget {
  const ShoppingListAddScreen({super.key, @PathParam('householdId') required this.householdId });
  final int householdId;

  @override
  State<ShoppingListAddScreen> createState() => _ShoppingListAddScreenState();
}

class _ShoppingListAddScreenState extends State<ShoppingListAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final String _selectedPerson = '';

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

    Navigator.pop(context); // Gehe zurück zur Listen Ansicht
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Todo: Dropdown-Liste für Personen zuweisen
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: addShoppingItem,
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }
}
