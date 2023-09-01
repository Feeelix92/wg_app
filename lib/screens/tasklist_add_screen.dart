import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/constants.dart';
import '../model/household.dart';
import '../model/taskItem.dart';
import '../routes/app_router.gr.dart';

class TaskListAddScreen extends StatefulWidget {
  const TaskListAddScreen({super.key, @PathParam('householdId') required this.householdId });
  final String householdId;

  @override
  State<TaskListAddScreen> createState() => _TaskListAddScreenState();
}

class _TaskListAddScreenState extends State<TaskListAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final String _selectedPerson = '';


  void addTask() {
    String title = _titleController.text;
    String description = _descriptionController.text;
    DateTime date = _selectedDate;
    String assignedTo = _selectedPerson;

    if (title.isNotEmpty && description.isNotEmpty) {
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
    }
    AutoRouter.of(context).push(TaskListRoute(householdId: widget.householdId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Titel',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Beschreibung',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            autofocus: false,
            readOnly: true,
            controller: TextEditingController(
                text: DateFormat('dd.MM.yyyy').format(_selectedDate)),
            decoration: InputDecoration(
              labelText: 'Datum',
              helperText: 'Datum auswählen',
              prefixIcon: const Icon(Icons.date_range),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
          // ToDo: Dropdown-Button für Personen zuweisen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: addTask,
                child: const Text('Hinzufügen'),
              ),
              ElevatedButton(
                onPressed: () {
                  AutoRouter.of(context).pop(); // Zurück zum HomeScreen
                },
                child: const Text('Abbrechen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
