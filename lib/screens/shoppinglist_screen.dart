import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wg_app/model/shoppingItem.dart';
import 'package:wg_app/routes/app_router.gr.dart';
import 'package:wg_app/screens/shoppinglist_add_screen.dart';
import 'package:wg_app/widgets/my_snackbars.dart';
import '../data/constants.dart';
import '../model/household.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/h1.dart';

@RoutePage()
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final int householdId;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Household currentHousehold = TestData.houseHoldData[widget.householdId];
    List<ShoppingItem> shoppingList = currentHousehold.shoppingList;
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
                var priceDisplay = shoppingItem.price == 0.0 ? "          " : '${shoppingItem.price.toStringAsFixed(2)} €';
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      shoppingList.removeAt(index);
                    });
                    showAwesomeSnackbar(context, "Eintrag gelöscht", Colors.red, Icons.delete);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  child: ListTile(
                  title: Text(shoppingItem.title),
                  subtitle: Text(shoppingItem.description),
                  trailing: Wrap(
                    spacing: 12,
                    children: <Widget>[
                      _buildMemberCircle("Joey"),
                      Text('${shoppingItem.quantity.toStringAsFixed(0)} x', style: const TextStyle(height: 4.5),),
                      Text(priceDisplay, style: const TextStyle(height: 4.5),),
                      Checkbox(
                        value: isChecked, //shoppingItem.erledigt eigentlich
                        onChanged: (value) {
                          setState(() {
                            isChecked = !isChecked;
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
                                          title: shoppingItem.title,
                                          description: shoppingItem.description,
                                          price: shoppingItem.price.toStringAsFixed(2),
                                          quantity: shoppingItem.quantity.toString()
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
          ElevatedButton(
            onPressed: () {
              AutoRouter.of(context).replace(HouseHoldDetailRoute(householdId: widget.householdId)); // Zurück zum HomeScreen
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
  }

  Widget _buildMemberCircle(String name) {
    Color circleColor = _getRandomColor();
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

  Color _getRandomColor() {
    Random random = Random();
    int r = random.nextInt(256); // Zufälliger Rot-Wert (0-255)
    int g = random.nextInt(256); // Zufälliger Grün-Wert (0-255)
    int b = random.nextInt(256); // Zufälliger Blau-Wert (0-255)
    return Color.fromARGB(255, r, g, b); // ARGB-Format, Alpha auf 255 gesetzt (vollständig sichtbar)
  }
}
