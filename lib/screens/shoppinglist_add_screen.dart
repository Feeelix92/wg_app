import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wg_app/widgets/my_snackbars.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../model/shoppingItem.dart';
import '../routes/app_router.gr.dart';

class ShoppingListAddScreen extends StatefulWidget {
  const ShoppingListAddScreen({
    super.key,
    @PathParam('householdId') required this.householdId,
    @PathParam('edit') required this.edit,
    @PathParam('title') this.title,
    @PathParam('description') this.description,
    @PathParam('price') this.price,
    @PathParam('quantity') this.quantity,
  });
  final int householdId;
  final bool edit;
  final String? title;
  final String? description;
  final String? price;
  final String? quantity;

  @override
  State<ShoppingListAddScreen> createState() => _ShoppingListAddScreenState();
}

class _ShoppingListAddScreenState extends State<ShoppingListAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final String _selectedPerson = '';


  void editPrefillValues() {
    _titleController.text = widget.title!;
    _descriptionController.text = widget.description!;
    _priceController.text = widget.price!;
    _quantityController.text = widget.quantity!;
  }

  void addShoppingItem() {
    String title = _titleController.text;
    String description = _descriptionController.text;
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    double price = double.tryParse(_priceController.text.replaceAll(',','.')) ?? 0.0;
    String assignedTo = _selectedPerson;

    if(title.isNotEmpty && description.isNotEmpty) {
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
      if(widget.edit) {showAwesomeSnackbar(context, "Eintrag bearbeitet.", Colors.green, Icons.check_circle);}
    } else {
      showAwesomeSnackbar(context, "Bitte gib einen Titel und eine Beschreibung an", Colors.redAccent, Icons.warning_amber_outlined);
    }
    AutoRouter.of(context).push(ShoppingListRoute(householdId: widget.householdId));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.edit) {editPrefillValues();}
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Titel',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Beschreibung',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Menge',
              prefixIcon: const Icon(Icons.shopping_cart),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Preis',
              prefixIcon: const Icon(Icons.euro),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          // Todo: Dropdown-Liste für Personen zuweisen
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: addShoppingItem,
                child: const Text('Hinzufügen'),
              ),
              ElevatedButton(
                onPressed: () {
                  AutoRouter.of(context).pop(); // Zurück zum HomeScreen
                },
                child: const Text('Abbrechen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
