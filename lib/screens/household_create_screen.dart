import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/household_provider.dart';

class HouseHoldCreateScreen extends StatefulWidget {
  const HouseHoldCreateScreen({super.key});

  @override
  State<HouseHoldCreateScreen> createState() => _HouseHoldCreateScreenState();
}

class _HouseHoldCreateScreenState extends State<HouseHoldCreateScreen> {
  final TextEditingController _houseHoldNameController = TextEditingController();
  final TextEditingController _houseHoldDescriptionController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();


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
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0,bottom: MediaQuery.of(context).viewInsets.bottom),
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
              ),
              // Anzeige der hinzugefügten Personen
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String title = _houseHoldNameController.text;
                      String description = _houseHoldDescriptionController.text;
                      householdProvider.createHousehold(title, description);
                      householdProvider.loadAllAccessibleHouseholds();
                      AutoRouter.of(context).popUntilRoot(); // Zurück zur Homeseite
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