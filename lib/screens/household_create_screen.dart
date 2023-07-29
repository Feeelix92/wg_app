import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';

@RoutePage()
class HouseHoldCreateScreen extends StatefulWidget {
  const HouseHoldCreateScreen({super.key});

  @override
  State<HouseHoldCreateScreen> createState() => _HouseHoldCreateScreenState();
}

class _HouseHoldCreateScreenState extends State<HouseHoldCreateScreen> {
  final TextEditingController _houseHoldNameController = TextEditingController();
  final TextEditingController _houseHoldDescriptionController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  final List<String> _addedMembers = [];

  void addPersonToHousehold(String personName) {
    if (personName.isNotEmpty) {
      setState(() {
        _addedMembers.add(personName);
        _personNameController.clear();
      });
    }
  }

  void _removePersonFromHouseHold(String personName) {
    setState(() {
      _addedMembers.remove(personName);
    });
  }

  void addHousehold(int id, String title, String description, List<String> members) {
    // TODO: Add household to Firebase
    if (title.isNotEmpty && description.isNotEmpty) {
      TestData.houseHoldData.add(
        Household(
          id: id,
          title: title,
          description: description,
          members: members,
        ),
      );
      AutoRouter.of(context).push(const HomeRoute()); // Zurück zum HomeScreen
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
                  AutoRouter.of(context).pop(); // Schließe Popup
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
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: Padding(
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
              // Eingabefeld für Personen hinzufügen,
              TextField(
                controller: _personNameController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                ], // Only
                decoration: InputDecoration(
                  labelText: 'Person hinzufügen',
                  hintText: 'Name der Person',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      addPersonToHousehold(_personNameController.text);
                      _personNameController.clear();
                    },
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: _addedMembers.map((person) {
                  return Chip(
                    label: Text(person),
                    onDeleted: () => _removePersonFromHouseHold(person),
                  );
                }).toList(),
              ),
              // Anzeige der hinzugefügten Personen
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  int id = TestData.houseHoldData.length-1;
                  String title = _houseHoldNameController.text;
                  String description = _houseHoldDescriptionController.text;
                  List<String> members = List.from(_addedMembers);

                  addHousehold(id, title, description, members);
                  AutoRouter.of(context).push(const HomeRoute()); // Zurück zum HomeScreen
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
        ),
      ),
    );
  }
}