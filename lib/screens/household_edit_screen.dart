import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/widgets/customErrorDialog.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../providers/household_provider.dart';
import '../routes/app_router.gr.dart';

class HouseHoldEditScreen extends StatefulWidget {
  const HouseHoldEditScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<HouseHoldEditScreen> createState() => _HouseHoldEditScreenState();
}

class _HouseHoldEditScreenState extends State<HouseHoldEditScreen> {
  late TextEditingController _houseHoldNameController;
  late TextEditingController _houseHoldDescriptionController;

  @override
  void initState() {
    super.initState();
    _houseHoldNameController = TextEditingController();
    _houseHoldDescriptionController = TextEditingController();
    loadHouseholdData();
  }

  void loadHouseholdData() {
    final householdProvider = Provider.of<HouseholdProvider>(context, listen: false);
    householdProvider.loadHousehold(widget.householdId);
    _houseHoldNameController.text = householdProvider.household.title;
    _houseHoldDescriptionController.text = householdProvider.household.description;
  }

  @override
  void dispose() {
    _houseHoldNameController.dispose();
    _houseHoldDescriptionController.dispose();
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
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final title = _houseHoldNameController.text;
                      final description = _houseHoldDescriptionController.text;
                      final success = await householdProvider.updateHouseholdInfo(title, description);
                      if (success) {
                        // Die Daten wurden erfolgreich aktualisiert
                        AutoRouter.of(context).push(HouseHoldDetailRoute(
                            householdId: widget.householdId)); // Zurück zur Detailseite
                      } else {
                        // Zeige eine Fehlermeldung an, wenn das Aktualisieren fehlschlägt.
                        customErrorDialog(context, 'Fehler', 'Fehler beim Aktualisieren der Haushaltsinformationen.');
                      }
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
            ],
          ),
        ),
      );
    });
  }
}
