import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/screens/tasklist_add_screen.dart';
import 'package:wg_app/widgets/my_snackbars.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';
import '../data/constants.dart';
import '../model/taskItem.dart';
import '../providers/household_provider.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/text/h1.dart';

/// {@category Screens}
/// Ansicht für die Aufgabenliste eines Haushalts
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
      //householdProvider.loadHousehold(widget.householdId); // Lade den aktuellen Haushalt
      final taskList = householdProvider.household.taskList;
      //List<dynamic> taskList = householdProvider.household.taskList;
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
              child: taskList.isNotEmpty ? ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 20,
                  thickness: 0,
                ),
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final taskItem = taskList[index];
                  final dateDueDisplay = taskItem['dateDue'].toDate().isAfter(DateTime.now()) ? Colors.green : Colors.red;
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        householdProvider.removeTaskItem(taskItem['id']);
                        householdProvider.loadHousehold(widget.householdId);
                      });
                      showAwesomeSnackbar(context, "Eintrag gelöscht", Colors.red, Icons.delete);
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: Text(taskItem['name']),
                      subtitle: Text(taskItem['description']??""), // ??"" = wenn null, dann ""
                      trailing: Wrap(
                        spacing: 12,
                        children: <Widget>[
                          Text(formatter.format(taskItem['dateDue'].toDate()), style: TextStyle(height: 4, fontSize: 14, color: dateDueDisplay)),
                          Text('${taskItem['points']} P.', style: const TextStyle(height: 4, fontSize: 14),),
                          _buildMemberCircle(taskItem["assignedTo"].toString()),
                          Checkbox(
                            value: taskItem['done'],
                            onChanged: (value) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('${taskItem['name']} Status umschalten?'),
                                    actions: [
                                      IconButton(onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                        householdProvider.toggleTaskItemDoneStatus(taskItem['id'], householdProvider.auth.currentUser!.uid);
                                      }, icon: const Icon(Icons.check),
                                      )
                                    ],
                                  ));
                              setState(() {
                                householdProvider.loadHousehold(widget.householdId);
                              });
                            },
                          ),
                          // Switch(
                          //   value: taskItem['done'],
                          //   onChanged: (bool? value) {
                          //     householdProvider.toggleTaskItemDoneStatus(taskItem['id']);
                          //     setState(() {
                          //       householdProvider.loadHousehold(widget.householdId);
                          //     });
                          //   },
                          // ),
                        ],
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
                                            children: <Widget> [TaskListAddScreen(
                                              householdId: widget.householdId,
                                              edit: true,
                                              id: taskItem['id'],
                                              title: taskItem['name'],
                                              description: taskItem['description'],
                                              points: taskItem['points'].toString(),
                                              assignedTo: taskItem['assignedTo'],
                                              dateDue: taskItem['dateDue'],
                                            )]
                                        )
                                    ),
                                  );
                                }, icon: const Icon(Icons.check))
                              ],
                            )
                        );
                      },
                    ),
                  );
                },
              ) : const Center(child: Text("Die Aufgabenliste ist momentan leer.")),
            ),
            ElevatedButton(onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Erledigte Tasks entfernen?'),
                    actions: [
                      IconButton(onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        householdProvider.removeDoneTaskItems();
                        householdProvider.loadHousehold(widget.householdId);
                      }, icon: const Icon(Icons.check),
                      )
                    ],
                  ));
            }, child: const Text('Alle erledigten Tasks Löschen')
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
                    children: <Widget> [TaskListAddScreen(householdId: widget.householdId, edit: false)],
                  ),
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
