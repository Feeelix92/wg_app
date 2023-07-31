import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wg_app/screens/shoppinglist_add_screen.dart';
import '../data/constants.dart';
import '../model/household.dart';
import '../model/taskItem.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';

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
    List<TaskItem> taskList = currentHousehold.taskList;
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final taskItem = taskList[index];
          return ListTile(
            title: Text(taskItem.title),
            subtitle: Text(taskItem.description),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => ShoppingListAddScreen(householdId: widget.householdId),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
