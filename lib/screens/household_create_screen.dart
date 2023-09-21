import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/household_provider.dart';


/// {@category Screens}
/// Screen zum Erstellen eines neuen Haushalts
class HouseHoldCreateScreen extends StatefulWidget {
  const HouseHoldCreateScreen({super.key});

  @override
  State<HouseHoldCreateScreen> createState() => _HouseHoldCreateScreenState();
}

class _HouseHoldCreateScreenState extends State<HouseHoldCreateScreen> {
  /// Dieser Controller für liest den Namen des Haushalts aus dem Textfeld
  final TextEditingController _houseHoldNameController = TextEditingController();
  /// Dieser Controller für liest die Beschreibung des Haushalts aus dem Textfeld
  final TextEditingController _houseHoldDescriptionController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /// Controller müssen manuell entsorgt werden, um Speicherlecks zu vermeiden
    _houseHoldNameController.dispose();
    _houseHoldDescriptionController.dispose();
    super.dispose();
  }

  @override
  /// Erstellt den Screen
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, householdProvider, child) {
      return Container(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0,bottom: MediaQuery.of(context).viewInsets.bottom),
        /// SingleChildScrollView ermöglicht das Scrollen der Seite
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