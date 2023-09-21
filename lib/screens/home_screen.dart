import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/providers/household_provider.dart';

import '../color_functions.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';
import 'household_create_screen.dart';

/// Startseite der App
/// {@category Screens}
@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State der Startseite
class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true; // Starte mit dem Ladezustand
  DateTime? lastLoadTime; // Zeitpunkt des letzten erfolgreichen Datenladens

  @override
  void initState() {
    super.initState();
    _loadData(); // Starte den Ladevorgang beim Initialisieren des Widgets
  }

  /// Lädt die Daten der verfügbaren Haushalte
  Future<void> _loadData() async {
    try {
      // Prüfen, ob genügend Zeit seit dem letzten Laden vergangen ist
      if (lastLoadTime == null ||
          DateTime.now().difference(lastLoadTime!) >
              const Duration(minutes: 5)) {
        // Laden der Daten
        final householdProvider = Provider.of<HouseholdProvider>(context, listen: false);
        final success = await householdProvider.loadAllAccessibleHouseholds();

        if (success) {
          // Zeitpunkt des letzten erfolgreichen Datenladens aktualisieren
          setState(() {
            lastLoadTime = DateTime.now();
            isLoading = false;
          });
        } else {
          // Fehler beim Laden der Daten
          setState(() {
            // Ladezustand beenden
            isLoading = false;
          });
          // Fehlermeldung anzeigen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fehler beim Laden der Haushalte.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Handle andere Fehler hier
      print(e);
      setState(() {
        // Ladezustand beenden
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// UI der Startseite
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: isLoading
          // Ladekreis anzeigen, wenn die Daten noch geladen werden
          ? const Center(
              child: CircularProgressIndicator(), // Ladekreis anzeigen
            )
          // Ansonsten prüfe, verwende die Daten aus dem Provider...
          : Consumer<HouseholdProvider>(
              builder: (context, householdProvider, child) {
                // ... und baue die Hauptansicht
                return Center(
                  child: Column(
                    children: [
                      const H1(text: 'Haushalt'),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount:
                              householdProvider.accessibleHouseholds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                AutoRouter.of(context).push(
                                  HouseHoldDetailRoute(
                                      householdId: householdProvider
                                          .accessibleHouseholds[index].id),
                                );
                              },
                              child: SizedBox(
                                height: 150,
                                width: 300,
                                child: Card(
                                  color: increaseBrightness(
                                      convertToColor(householdProvider
                                          .accessibleHouseholds[index].title),
                                      0.3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        householdProvider
                                            .accessibleHouseholds[index].title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        householdProvider
                                            .accessibleHouseholds[index]
                                            .description,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      // Button zum Erstellen eines neuen Haushalts
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) => const HouseHoldCreateScreen(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
