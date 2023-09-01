import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/household_provider.dart';

class ShoppingListAddScreen extends StatefulWidget {
  const ShoppingListAddScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<ShoppingListAddScreen> createState() => _ShoppingListAddScreenState();
}

class _ShoppingListAddScreenState extends State<ShoppingListAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String selectedPerson = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, householdProvider, child) {
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
            // DropdownButtonFormField<String>(
            //   value: selectedPerson,
            //   items: memberNames.map((String person) {
            //     return DropdownMenuItem<String>(
            //       value: person,
            //       child: Text(person),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedPerson = newValue ?? ''; // Aktualisiere die ausgewählte Person
            //     });
            //   },
            //   decoration: InputDecoration(
            //     labelText: 'Person zuweisen',
            //     prefixIcon: const Icon(Icons.person),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  // onPressed: addShoppingItem,
                  onPressed: () {
                    // @ToDo ShoppingItem erstellen und in die ShoppingListe einfügen
                  },
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
    });
  }
}
