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
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final taskItem = taskList[index];
          return ListTile(
            title: Text(taskItem.title),
            subtitle: Text(taskItem.description),
            trailing: Text(DateFormat('dd.MM.yyyy').format(taskItem.date)),
          );
        },
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
