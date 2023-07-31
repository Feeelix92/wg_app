import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../routes/app_router.gr.dart';

class HouseHoldEditScreen extends StatefulWidget {
  const HouseHoldEditScreen({super.key, @PathParam('householdId') required this.householdId });
  final int householdId;

  @override
  State<HouseHoldEditScreen> createState() => _HouseHoldEditScreenState();
}

class _HouseHoldEditScreenState extends State<HouseHoldEditScreen> {
  late TextEditingController _houseHoldNameController;
  late TextEditingController _houseHoldDescriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current household data
    Household household = TestData.houseHoldData[widget.householdId];
    _houseHoldNameController = TextEditingController(text: household.title);
    _houseHoldDescriptionController = TextEditingController(text: household.description);
  }

  void updateHousehold(int id, String title, String description) {
    // TODO: Update household data in Firebase
    TestData.houseHoldData[widget.householdId] = Household(
      id: id,
      title: title,
      description: description,
      members: [],
    );
    AutoRouter.of(context).push(HouseHoldDetailRoute(householdId: widget.householdId)); // Zurück zur Detailseite
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _houseHoldNameController,
              maxLength: 20,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'z.B. Muster WG',
              ),
            ),
            TextField(
              controller: _houseHoldDescriptionController,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                hintText: 'z.B. WG in der Bahnhofstraße 13',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                int id = widget.householdId;
                String title = _houseHoldNameController.text;
                String description = _houseHoldDescriptionController.text;
                updateHousehold(id, title, description);
              },
              child: const Text('Speichern'),
            ),
            ElevatedButton(
              onPressed: () {
                AutoRouter.of(context).pop(); // Zurück zur Detailseite ohne Änderungen
              },
              child: const Text('Abbrechen'),
            ),
          ],
        ),
      ),
    );
  }
}
