import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/household_provider.dart';
import '../routes/app_router.gr.dart';

class HouseHoldCreateScreen extends StatefulWidget {
  const HouseHoldCreateScreen({super.key});

  @override
  State<HouseHoldCreateScreen> createState() => _HouseHoldCreateScreenState();
}

class _HouseHoldCreateScreenState extends State<HouseHoldCreateScreen> {
  final TextEditingController _houseHoldNameController = TextEditingController();
  final TextEditingController _houseHoldDescriptionController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();

  Future<void> _loadData() async {
    try {
        // Laden der Daten
        final householdProvider =
        Provider.of<HouseholdProvider>(context, listen: false);
        await householdProvider.loadAllAccessibleHouseholds();

    } catch (e) {
      // Handle andere Fehler hier
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _houseHoldNameController.dispose();
    _houseHoldDescriptionController.dispose();
    _personNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, householdProvider, child) {
      return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _houseHoldNameController,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'z.B. Muster WG',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            TextField(
              controller: _houseHoldDescriptionController,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Beschreibung',
                hintText: 'z.B. WG in der Bahnhofstraße 13',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ), // Eingabefeld für Personen hinzufügen,
            // TextField(
            //   controller: _personNameController,
            //   inputFormatters: <TextInputFormatter>[
            //     FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
            //   ], // Only
            //   decoration: InputDecoration(
            //     labelText: 'Person hinzufügen',
            //     hintText: 'Email der Person',
            //     prefixIcon: const Icon(Icons.email),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     suffixIcon: IconButton(
            //       icon: const Icon(Icons.add),
            //       onPressed: () {
            //         householdProvider.addUserToHousehold(_personNameController.text);
            //         _personNameController.clear();
            //       },
            //     ),
            //   ),
            // ),
            // Wrap(
            //   spacing: 8,
            //   children: addedMembers.map((person) {
            //     return Chip(
            //       label: Text(person),
            //       onDeleted: () => _removePersonFromHouseHold(person),
            //     );
            //   }).toList(),
            // ),
            // // Anzeige der hinzugefügten Personen
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String title = _houseHoldNameController.text;
                    String description = _houseHoldDescriptionController.text;
                    householdProvider.createHousehold(title, description);
                    _loadData();
                    AutoRouter.of(context).pop(); // Pop Up schließen
                    AutoRouter.of(context).replace(const HomeRoute()); // Zurück zum HomeScreen
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
      ),
    );
  });
  }
}