import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wg_app/model/shoppingItem.dart';
import 'package:wg_app/screens/shoppinglist_add_screen.dart';
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
                //color: Colors.white,
              ),
              itemCount: shoppingList.length,
              itemBuilder: (context, index) {
                final shoppingItem = shoppingList[index];
                return ListTile(
                  /*
                   shape: const RoundedRectangleBorder(
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(25),
                       topRight: Radius.circular(25),
                       bottomRight: Radius.circular(25),
                       bottomLeft: Radius.circular(25)),
                   ),
                   */
                  title: Text(shoppingItem.title),
                  subtitle: Text(shoppingItem.description),
                  trailing: Text('${shoppingItem.price} €'),
                  //tileColor: Colors.indigoAccent,
                );
              },
            ) : const Text("Die Einkaufsliste ist momentan leer."),
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
                  children: <Widget> [ShoppingListAddScreen(householdId: widget.householdId)]
                )
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
