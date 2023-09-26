import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/screens/shoppinglist_add_screen.dart';
import '../providers/household_provider.dart';
import '../widgets/build_member_circle.dart';
import '../widgets/custom_snackbars.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/h1.dart';

/// {@category Screens}
/// Ansicht für die Einkaufsliste eines Haushalts
@RoutePage()
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({
    super.key,
    @PathParam('householdId') required this.householdId
  });

  final String householdId;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, householdProvider, child) {
      final shoppingList = householdProvider.household.shoppingList;
      return Scaffold(
        appBar: const CustomAppBar(),
        endDrawer: const AppDrawer(),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: H1(text: 'Einkaufsliste'),
            ),
            Expanded(
              child: shoppingList.isNotEmpty
                  ? FutureBuilder<Map<String, Map<String, dynamic>>>(
                      future: householdProvider.getHouseholdMembersData(householdProvider.household.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator()); // Zeige einen Ladekreis während des Ladens an
                        } else if (snapshot.hasError) {
                          return Text('Fehler: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('Keine Mitglieder gefunden');
                        } else {
                          final members = snapshot.data;
                          return ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              height: 20,
                              thickness: 0,
                            ),
                            itemCount: shoppingList.length,
                            itemBuilder: (context, index) {
                              final shoppingItem = shoppingList[index];
                              var priceDisplay = shoppingItem['price'] == 0.0 ? "          " : '${shoppingItem['price'].toStringAsFixed(2)} €';
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  setState(() {
                                    householdProvider.removeShoppingItem(shoppingItem['id']);
                                    householdProvider.loadHousehold(widget.householdId);
                                  });
                                  showAwesomeSnackbar(context, "Eintrag gelöscht", Colors.red, Icons.delete);
                                },
                                background: Container(
                                  color: Colors.red,
                                  child: const Icon(Icons.delete),
                                ),
                                child: ListTile(
                                  title: Text(shoppingItem['name']),
                                  subtitle: Text(shoppingItem['description']),
                                  trailing:
                                      Wrap(spacing: 12, children: <Widget>[
                                        Text('${shoppingItem['points']} P.', style: const TextStyle(height: 4.5),),
                                        Text('${shoppingItem['amount']} x', style: const TextStyle(height: 4.5),),
                                        Text(priceDisplay, style: const TextStyle(height: 4.5),),
                                        buildMemberCircle(members?[shoppingItem['assignedTo']]?['username'], 40, 0.2),
                                        Checkbox(
                                          value: shoppingItem['done'],
                                          onChanged: (value) {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('${shoppingItem['name']} Status umschalten?'),
                                                  actions: [
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                                        householdProvider.toggleShoppingItemDoneStatus(shoppingItem['id'], householdProvider.auth.currentUser!.uid);
                                                      },
                                                      icon: const Icon(Icons.check),
                                                    )
                                                  ],
                                                ));
                                        setState(() {
                                          householdProvider.loadHousehold(widget.householdId);
                                        });
                                      },
                                    )
                                  ]),
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            title: const Text("Eintrag bearbeiten?"),
                                            actions: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (context) =>
                                                          Padding(
                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                              child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: <Widget>[
                                                                    ShoppingListAddScreen(
                                                                      householdId: widget.householdId,
                                                                      edit: true,
                                                                      id: shoppingItem['id'],
                                                                      title: shoppingItem['name'],
                                                                      description: shoppingItem['description'],
                                                                      price: shoppingItem['price'].toStringAsFixed(2),
                                                                      points: shoppingItem['points'].toString(),
                                                                      amount: shoppingItem['amount'].toString(),
                                                                      assignedTo: shoppingItem['assignedTo'],
                                                                    )
                                                                  ]
                                                              )
                                                          ),
                                                    );},
                                                  icon: const Icon(Icons.check))
                                            ]
                                        )
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      }) : const Center(child: Text("Die Einkaufsliste ist momentan leer.")),
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Erledigte Items entfernen?'),
                        actions: [
                          IconButton(
                            onPressed: () {Navigator.of(context, rootNavigator: true).pop('dialog');
                                  householdProvider.removeDoneShoppingItems();
                                  householdProvider.loadHousehold(widget.householdId);
                            },
                            icon: const Icon(Icons.check),
                          )
                        ],
                      ));
                },
                child: const Text('Alle erledigten Items Löschen')),
            const SizedBox(height: 20.0)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ShoppingListAddScreen(householdId: widget.householdId, edit: false)
                    ],
                  ),
                )
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
