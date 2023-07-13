import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:wg_app/model/household.dart';

import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @Todo: Remove this dummy data and replace with Firebase data
  List<Household> houseHoldData = [
    Household(
      title: 'Beispiel Haushalt',
      description: 'Beschreibung',
    ),
  ];

  void addHousehold(String title, String description) {
    setState(() {
      // @Todo: change to add new Household to Firebase
      houseHoldData.add(Household(
        title: title,
        description: description,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: Center(
        child: Column(
          children: [
            const H1(text: 'Haushalt'),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: houseHoldData.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 200,
                    width: 300,
                    child: Card(
                      child: Column(
                        children: [
                          Text(houseHoldData[index].title),
                          Text(houseHoldData[index].description),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String title = '';
              String description = '';
              return AlertDialog(
                title: const Text('Haushalt erstellen'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Beschreibung',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addHousehold(title, description);
                      Navigator.pop(context); // Schließen des Pop-ups
                    },
                    child: const Text('Hinzufügen'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Schließen des Pop-ups
                    },
                    child: const Text('Abbrechen'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
