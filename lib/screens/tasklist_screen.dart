import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/screens/tasklist_add_screen.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';
import '../providers/household_provider.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/text/h1.dart';

@RoutePage()
class TaskListScreen extends StatefulWidget {
  const TaskListScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, householdProvider, child) {
      householdProvider.loadHousehold(widget.householdId); // Lade den aktuellen Haushalt
      List<dynamic> taskList = householdProvider.household.taskList;
      return Scaffold(
        appBar: const CustomAppBar(),
        endDrawer: const AppDrawer(),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: H1(text: 'Aufgabenliste'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final taskItem = taskList[index];
                  return ListTile(
                    title: Text(taskItem.name),
                    subtitle: Text(taskItem.description??""), // ??"" = wenn null, dann ""
                    trailing: Switch(
                      onChanged: (bool? value) {
                        setState(() {
                          taskItem.done = value!;
                        });
                      },
                      value: taskItem.done,
                    ),
                  );
                },
              ),
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
              builder: (context) => SingleChildScrollView(
                  child: TaskListAddScreen(householdId: widget.householdId)),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
