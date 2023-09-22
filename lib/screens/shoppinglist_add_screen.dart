import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wg_app/widgets/my_snackbars.dart';
import 'package:provider/provider.dart';
import '../data/constants.dart';
import '../providers/household_provider.dart';
import '../model/shoppingItem.dart';

class ShoppingListAddScreen extends StatefulWidget {
  const ShoppingListAddScreen({
    super.key,
    @PathParam('householdId') required this.householdId,
    @PathParam('edit') required this.edit,
    @PathParam('id') this.id,
    @PathParam('title') this.title,
    @PathParam('description') this.description,
    @PathParam('price') this.price,
    @PathParam('amount') this.amount,
    @PathParam('points') this.points,
    @PathParam('assignedTo') this.assignedTo,
  });

  final String householdId;
  final bool edit;
  final String? id;
  final String? title;
  final String? description;
  final String? price;
  final String? amount;
  final String? points;
  final String? assignedTo;

  @override
  State<ShoppingListAddScreen> createState() => _ShoppingListAddScreenState();
}

class _ShoppingListAddScreenState extends State<ShoppingListAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  String selectedPerson = 'Alle';

  void editPrefillValues() {
    _titleController.text = widget.title!;
    _descriptionController.text = widget.description!;
    _priceController.text = widget.price!;
    _amountController.text = widget.amount!;
    _pointsController.text = widget.points!;
    selectedPerson = widget.assignedTo!;
  }

  @override
  void initState() {
    if (widget.edit) {editPrefillValues();}
    return super.initState();
  }

  bool validateShoppingItemData() {
    if(_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      if(widget.edit) {showAwesomeSnackbar(context, "Eintrag bearbeitet.", Colors.green, Icons.check_circle);}
      return true;
    } else {
      showAwesomeSnackbar(context, "Bitte gib einen Titel und eine Beschreibung an", Colors.redAccent, Icons.warning_amber_outlined);
      return false;
    }
  }

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
            const SizedBox(height: 10.0),
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
            const SizedBox(height: 10.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Menge',
                prefixIcon: const Icon(Icons.shopping_cart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
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
            const SizedBox(height: 10.0),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Punkte',
                prefixIcon: const Icon(Icons.scoreboard),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<List<String>>(
              future: householdProvider.getHouseholdMembersNames(householdProvider.household.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Zeige einen Ladekreis während des Ladens an
                } else if (snapshot.hasError) {
                  return Text('Fehler: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Keine Mitglieder gefunden');
                } else {
                  final members = snapshot.data;
                  members!.add("Alle");
                  return DropdownButtonFormField<String>(
                    value: selectedPerson,
                    items: members.map((String person) {
                      return DropdownMenuItem<String>(
                        value: person,
                        child: Text(person),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPerson = newValue ?? 'Alle'; // Aktualisiere die ausgewählte Person
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Person zuweisen',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                }
              }
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (validateShoppingItemData()) {
                      String itemId;
                      if(widget.id != null) {
                        itemId = widget.id!;
                      } else {
                        itemId = DateTime.now().toString();
                      }
                      ShoppingItem item = ShoppingItem(
                          id: itemId,
                          name: _titleController.text,
                          description: _descriptionController.text,
                          amount: int.tryParse(_amountController.text) ?? 0,
                          price: double.tryParse(_priceController.text.replaceAll(',','.')) ?? 0.0,
                          assignedTo: selectedPerson,
                          points: int.tryParse(_pointsController.text) ?? 0,
                          done: false);
                      if(widget.edit) {
                        householdProvider.updateShoppingItem(item);
                      } else {
                        householdProvider.addShoppingItem(item);
                      }
                      householdProvider.loadHousehold(widget.householdId);
                      AutoRouter.of(context).pop();
                    }
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