import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/widgets/custom_error_dialog.dart';
import '../providers/household_provider.dart';

/// {@category Screens}
/// Ansicht um die Haushaltsinformationen zu bearbeiten.
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
    return Consumer<HouseholdProvider>(builder: (context, houseHoldProvider, child) {
      return Container(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      final success = await houseHoldProvider.updateHouseholdInfo(title, description);
                      final loadAllAccessibleHouseholds = await houseHoldProvider.loadAllAccessibleHouseholds();
                      if (success && loadAllAccessibleHouseholds) {
                        // Die Daten wurden erfolgreich aktualisiert
                        AutoRouter.of(context).popUntilRoot(); // Zurück zur Homeseite
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
