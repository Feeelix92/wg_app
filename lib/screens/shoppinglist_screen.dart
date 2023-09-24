import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/model/shoppingItem.dart';
import 'package:wg_app/screens/shoppinglist_add_screen.dart';
import '../data/constants.dart';
import '../model/household.dart';
import '../providers/household_provider.dart';
import '../widgets/my_snackbars.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/h1.dart';

@RoutePage()
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, houseHoldData, child) {
      //houseHoldData.loadHousehold(widget.householdId);
      final shoppingList = houseHoldData.household.shoppingList;
      //final members = houseHoldData.getHouseholdMembersNames(widget.householdId);
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
              child: shoppingList.isNotEmpty ? ListView.separated(
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
                        houseHoldData.removeShoppingItem(shoppingItem['id']);
                        houseHoldData.loadHousehold(widget.householdId);
                      });
                      showAwesomeSnackbar(context, "Eintrag gelöscht", Colors.red, Icons.delete);
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: Text(shoppingItem['name']),
                      subtitle: Text(shoppingItem['description']), // ??"" = wenn null, dann ""
                      trailing: Wrap(
                        spacing: 12,
                        children: <Widget>[
                          Text('${shoppingItem['points']} P.', style: const TextStyle(height: 4.5),),
                          Text('${shoppingItem['amount']} x', style: const TextStyle(height: 4.5),),
                          Text(priceDisplay, style: const TextStyle(height: 4.5),),
                          _buildMemberCircle(shoppingItem["assignedTo"].toString()),
                          Checkbox(
                            value: shoppingItem['done'],
                            onChanged: (value) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('${shoppingItem['name']} Status umschalten?'),
                                    actions: [
                                      IconButton(onPressed: () {
                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                          houseHoldData.toggleShoppingItemDoneStatus(shoppingItem['id'], houseHoldData.auth.currentUser!.uid);
                                        }, icon: const Icon(Icons.check),
                                      )
                                    ],
                                  ));
                              setState(() {
                                houseHoldData.loadHousehold(widget.householdId);
                              });
                            },
                          )
                        ]
                      ),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Eintrag bearbeiten?"),
                              actions: [
                                IconButton(onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget> [ShoppingListAddScreen(
                                              householdId: widget.householdId,
                                              edit: true,
                                              id: shoppingItem['id'],
                                              title: shoppingItem['name'],
                                              description: shoppingItem['description'],
                                              price: shoppingItem['price'].toStringAsFixed(2),
                                              points: shoppingItem['points'].toString(),
                                              amount: shoppingItem['amount'].toString(),
                                              assignedTo: shoppingItem['assignedTo'],
                                          )]
                                        )
                                      ),
                                  );
                                }, icon: const Icon(Icons.check))
                              ]
                            )
                        );
                      },
                    ),
                  );
                },
              ) : const Center(child: Text("Die Einkaufsliste ist momentan leer.")),
            ),
            ElevatedButton(onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Erledigte Items entfernen?'),
                    actions: [
                      IconButton(onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        houseHoldData.removeDoneShoppingItems();
                        houseHoldData.loadHousehold(widget.householdId);
                      }, icon: const Icon(Icons.check),
                      )
                    ],
                  ));
            }, child: const Text('Alle erledigten Items Löschen')
            ),
            ElevatedButton(
              onPressed: () {
                AutoRouter.of(context).pop(); // Zurück zum HomeScreen
              },
              child: const Text('Zurück'),
            ),
            const SizedBox(height: 20.0)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [ShoppingListAddScreen(householdId: widget.householdId, edit: false)]
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