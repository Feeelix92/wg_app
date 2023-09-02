import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/screens/household_edit_screen.dart';
import 'package:wg_app/widgets/customErrorDialog.dart';

import '../data/constants.dart';
import '../providers/household_provider.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';

@RoutePage()
class HouseHoldDetailScreen extends StatefulWidget {
  const HouseHoldDetailScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<HouseHoldDetailScreen> createState() => _HouseHoldDetailScreenState();
}

class _HouseHoldDetailScreenState extends State<HouseHoldDetailScreen> {
  bool isLoading = true; // Starte mit dem Ladezustand

  @override
  void initState() {
    super.initState();
    _loadData(); // Starte den Ladevorgang beim Initialisieren des Widgets
  }

  Future<void> _loadData() async {
    try {
      // Lade deine Daten hier, z.B. mit deinem Provider
      final householdProvider =
          Provider.of<HouseholdProvider>(context, listen: false);
      final loadHousehold = await householdProvider.loadHousehold(widget.householdId);
      final loadAllAccessibleHouseholds = await householdProvider.loadAllAccessibleHouseholds();

      if (loadHousehold && loadAllAccessibleHouseholds) {
        // Ladevorgang erfolgreich abgeschlossen
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Laden des Haushalts.'),
            duration: Duration(seconds: 3),
          ),
        );
        // Fehler beim Laden der Daten
        setState(() {
          isLoading = true;
        });
      }
    } catch (e) {
      // Handle andere Fehler hier
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Ladekreis anzeigen
            )
          : Consumer<HouseholdProvider>(
              builder: (context, houseHoldProvider, child) {
                // Ansonsten baue die Hauptansicht
                return Center(
                  child: Column(
                    children: [
                      H1(text: houseHoldProvider.household.title),
                      Text(houseHoldProvider.household.description),
                      // Anzeige der Personen-Kreise
                      if (houseHoldProvider.household.members.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: FutureBuilder<List<String>>(
                            future: houseHoldProvider.getHouseholdMembersNames(houseHoldProvider.household.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Zeige einen Ladekreis während des Ladens an
                              } else if (snapshot.hasError) {
                                return Text('Fehler: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('Keine Mitglieder gefunden');
                              } else {
                                final members = snapshot.data;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: members!.map((member) => _buildMemberCircle(member)).toList(),
                                );
                              }
                            },
                          ),
                        ),
                      // ShoppingList Card
                      Card(
                        child: ListTile(
                          title: const Text('Einkaufsliste'),
                          onTap: () {
                            // Navigiere zur ShoppingListScreen
                            AutoRouter.of(context).push(ShoppingListRoute(
                                householdId: widget.householdId));
                          },
                        ),
                      ),
                      // TaskList Card
                      Card(
                        child: ListTile(
                          title: const Text('Aufgabenliste'),
                          onTap: () {
                            // Navigiere zur TaskListScreen
                            AutoRouter.of(context).push(
                                TaskListRoute(householdId: widget.householdId));
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Löschen'),
                                content: const Text('Möchten Sie diesen Haushalt wirklich löschen?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      // Setzen Sie isLoading auf true, um die Ladeanzeige anzuzeigen
                                      setState(() {
                                        isLoading = true;
                                      });
                                      bool deleted = await houseHoldProvider.deleteHousehold(widget.householdId);

                                      if (deleted) {
                                        // Lade die Daten neu
                                        _loadData();
                                        AutoRouter.of(context).popUntilRoot();
                                        AutoRouter.of(context).replace(const HomeRoute());
                                      } else {
                                        customErrorDialog(context, "Fehler","Haushalt konnte nicht gelöscht werden!");
                                      }
                                      // Nach dem Löschen des Haushalts
                                      setState(() {
                                        isLoading = false; // Setzen Sie isLoading auf false, um die Ladeanzeige auszublenden
                                      });
                                    },
                                    child: const Text('Löschen'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AutoRouter.of(context).pop();
                                    },
                                    child: const Text('Abbrechen'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red[900],
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text("Haushalt Löschen"),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) =>
                HouseHoldEditScreen(householdId: widget.householdId),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

Widget _buildMemberCircle(String name) {
  Color circleColor = convertToColor(name);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
      ),
      child: Center(
        child: Text(
          name[0],
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

