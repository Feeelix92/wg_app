import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wg_app/screens/tasklist_add_screen.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';
import '../data/constants.dart';
import '../model/household.dart';
import '../model/taskItem.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/text/h1.dart';

@RoutePage()
class TaskListScreen extends StatefulWidget {
  const TaskListScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final int householdId;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    Household currentHousehold = TestData.houseHoldData[widget.householdId];
    List<TaskItem> taskList = currentHousehold.taskList;
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
                    title: Text(taskItem.title),
                    subtitle: Text(taskItem.description),
                    trailing: Switch(
                      onChanged: (bool? value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          taskItem.isDone = value!;
                        });
                      },
                      value: taskItem.isDone,
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
            builder: (context) => TaskListAddScreen(householdId: widget.householdId),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
