import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/providers/household_provider.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';
import 'household_create_screen.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true; // Starte mit dem Ladezustand

  @override
  void initState() {
    super.initState();
    _loadData(); // Starte den Ladevorgang beim Initialisieren des Widgets
  }

  Future<void> _loadData() async {
    try {
      // Laden der Daten
      final householdProvider =
          Provider.of<HouseholdProvider>(context, listen: false);
      final success = await householdProvider.loadAllAccessibleHouseholds();

      if (success) {
        // Ladevorgang erfolgreich abgeschlossen
        setState(() {
          isLoading = false;
        });
      } else {
        // Fehler beim Laden der Daten
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Laden der Haushalte.'),
            duration: Duration(seconds: 3),
          ),
        );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Ladekreis anzeigen
            )
          : Consumer<HouseholdProvider>(
              builder: (context, householdProvider, child) {
                // Ansonsten baue die Hauptansicht
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
                                      householdId: index.toString()),
                                );
                              },
                              child: SizedBox(
                                height: 200,
                                width: 300,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      H2(
                                          text: householdProvider
                                              .accessibleHouseholds[index]
                                              .title),
                                      H3(
                                          text: householdProvider
                                              .accessibleHouseholds[index]
                                              .description),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const SingleChildScrollView(
              child: HouseHoldCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
