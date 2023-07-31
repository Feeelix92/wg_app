import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../model/taskItem.dart';

@RoutePage()
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, @PathParam('householdId') required this.householdId });
  final int householdId;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedPerson = '';


  void addTask() {
    String title = _titleController.text;
    String description = _descriptionController.text;
    DateTime date = _selectedDate;
    String assignedTo = _selectedPerson;

    // Füge die Aufgabe der Aufgabenliste hinzu (kann auch Firebase-Speicherung enthalten)
    setState(() {
      Household currentHousehold = TestData.houseHoldData[widget.householdId];
      currentHousehold.taskList.add(
        TaskItem(
          title: title,
          description: description,
          date: date,
          assignedTo: assignedTo,
        ),
      );
    });

    Navigator.pop(context); // Gehe zurück zum Detail-Screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aufgabe hinzufügen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Beschreibung'),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    'Datum: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
                  ),
                ),
              ],
            ),
            // ToDo: Dropdown-Button für Personen zuweisen
            ElevatedButton(
              onPressed: addTask,
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }
}
