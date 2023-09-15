import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/screens/household_edit_screen.dart';
import 'package:wg_app/widgets/custom_error_dialog.dart';

import '../data/constants.dart';
import '../providers/household_provider.dart';
import '../routes/app_router.gr.dart';
import '../widgets/build_member_circle.dart';
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
      final loadHousehold =
          await householdProvider.loadHousehold(widget.householdId);

      if (loadHousehold) {
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
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        H1(text: houseHoldProvider.household.title),
                        Text(houseHoldProvider.household.description),
                        // Anzeige der Personen-Kreise
                        if (houseHoldProvider.household.members.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: FutureBuilder<List<String>>(
                              future: houseHoldProvider.getHouseholdMembersNames(
                                  houseHoldProvider.household.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Zeige einen Ladekreis während des Ladens an
                                } else if (snapshot.hasError) {
                                  return Text('Fehler: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text('Keine Mitglieder gefunden');
                                } else {
                                  final members = snapshot.data;
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: members!.map((member) => buildMemberCircle(member, 40.0, 0.1)).toList(),
                                      ),
                                      if (houseHoldProvider.household.admin ==
                                          houseHoldProvider.auth.currentUser!.uid)
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Öffne das Dialogfeld zum Hinzufügen von Mitgliedern per E-Mail
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return inviteMembersDialog();
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text('Mitglieder hinzufügen'),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        // Anzeige der Karten
                        buildCard(context, 'Einkaufsliste', Icons.shopping_basket,
                            ShoppingListRoute(householdId: widget.householdId)),
                        buildCard(context, 'Aufgabenliste', Icons.work,
                            TaskListRoute(householdId: widget.householdId)),
                        buildCard(context, 'Ausgaben', Icons.euro,
                            FinanceRoute(householdId: widget.householdId)),
                        buildCard(context, 'Ranking', Icons.emoji_events,
                            RankingRoute(householdId: widget.householdId)),
                        const SizedBox(height: 20),
                        if (houseHoldProvider.household.admin ==
                            houseHoldProvider.auth.currentUser!.uid)
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return deleteHouseholdDialog(houseHoldProvider, context);
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

  AlertDialog inviteMembersDialog() {
    return AlertDialog(
      title: const Text('Mitglieder hinzufügen'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hier Eingabefelder für E-Mail-Adressen hinzufügen
          TextField(
            decoration: InputDecoration(labelText: 'E-Mail-Adresse'),
          ),
          // Hier weitere Eingabefelder hinzufügen, falls erforderlich
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Hier die Logik zum Senden der Einladungen implementieren
            // Du kannst eine Funktion aufrufen, die die Einladungen verschickt
          },
          child: const Text('Einladen'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Schließe das Dialogfeld
          },
          child: const Text('Abbrechen'),
        ),
      ],
    );
  }


  AlertDialog deleteHouseholdDialog(
      HouseholdProvider houseHoldProvider, BuildContext context) {
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
            final deleted =
                await houseHoldProvider.deleteHousehold(widget.householdId);
            final loadAllAccessibleHouseholds =
                await houseHoldProvider.loadAllAccessibleHouseholds();
            if (deleted && loadAllAccessibleHouseholds) {
              AutoRouter.of(context).popUntilRoot(); // Zurück zur Homeseite
            } else {
              customErrorDialog(context, "Fehler", "Haushalt konnte nicht gelöscht werden!");
            }
            // Nach dem Löschen des Haushalts
            if (mounted) {
              setState(() {
                isLoading =
                    false; // Setzen Sie isLoading auf false, um die Ladeanzeige auszublenden
              });
            }
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
  }

  Card buildCard(BuildContext context, String title, IconData icon, route) {
    return Card(
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        onTap: () {
          AutoRouter.of(context).push(route);
        },
      ),
    );
  }
}
