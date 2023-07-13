import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../model/household.dart';

@RoutePage()
class HouseHoldFormScreen extends StatefulWidget {
  const HouseHoldFormScreen({super.key});

  @override
  State<HouseHoldFormScreen> createState() => _HouseHoldFormScreenState();
}

class _HouseHoldFormScreenState extends State<HouseHoldFormScreen> {
  final TextEditingController _houseHoldNameController = TextEditingController();
  final TextEditingController _houseHoldDescriptionController = TextEditingController();

  void addHousehold(String title, String description) {
    // TODO: Add household to Firebase
    if (title.isNotEmpty && description.isNotEmpty) {
      AutoRouter.of(context).pop<Household>(Household(
        title: title,
        description: description,
      ));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fehler'),
            content: const Text('Bitte füllen Sie alle Felder aus.'),
            actions: [
              TextButton(
                onPressed: () {
                  AutoRouter.of(context).pop(); // Schließen des Pop-ups
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                String title = _houseHoldNameController.text;
                String description = _houseHoldDescriptionController.text;
                addHousehold(title, description);
                AutoRouter.of(context).pop(); // Schließen des Bildschirms
              },
              child: const Text('Hinzufügen'),
            ),
            ElevatedButton(
              onPressed: () {
                AutoRouter.of(context).pop(); // Schließen des Bildschirms
              },
              child: const Text('Abbrechen'),
            ),
          ],
        ),
      ),
    );
  }
}