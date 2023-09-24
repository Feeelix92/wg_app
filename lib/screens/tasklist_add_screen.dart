import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/household_provider.dart';
import '../widgets/my_snackbars.dart';

/// {@category Screens}
/// Ansicht für das Hinzufügen einer neuen AUfgabe bzw. TaskItems auf die Aufgabenliste
class TaskListAddScreen extends StatefulWidget {
  const TaskListAddScreen({
    super.key,
    @PathParam('householdId') required this.householdId,
    @PathParam('edit') required this.edit,
    @PathParam('id') this.id,
    @PathParam('title') this.title,
    @PathParam('description') this.description,
    @PathParam('points') this.points,
    @PathParam('assignedTo') this.assignedTo,
    @PathParam('dateDue') this.dateDue,
  });

  final String householdId;
  final bool edit;
  final String? id;
  final String? title;
  final String? description;
  final String? points;
  final String? assignedTo;
  final Timestamp? dateDue;


  @override
  State<TaskListAddScreen> createState() => _TaskListAddScreenState();
}

class _TaskListAddScreenState extends State<TaskListAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  String _selectedPerson = 'Alle';
  DateTime _selectedDate = DateTime.now();

  void editPrefillValues() {
    _titleController.text = widget.title!;
    _descriptionController.text = widget.description!;
    _pointsController.text = widget.points!;
    _selectedPerson = widget.assignedTo!;
    _selectedDate = widget.dateDue!.toDate();
  }

  @override
  void initState() {
    if (widget.edit) {editPrefillValues();}
    return super.initState();
  }

  bool validateTaskItemData() {
    if(_titleController.text.isNotEmpty) {
      if(widget.edit) {showAwesomeSnackbar(context, "Aufgabe bearbeitet.", Colors.green, Icons.check_circle);}
      return true;
    } else {
      showAwesomeSnackbar(context, "Bitte gib einen Titel an", Colors.redAccent, Icons.warning_amber_outlined);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, householdProvider, child) {
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
          const SizedBox(height: 10.0),
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
          const SizedBox(height: 10.0),
          TextField(
            controller: _pointsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Punkte',
              prefixIcon: const Icon(Icons.scoreboard),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            autofocus: false,
            readOnly: true,
            controller: TextEditingController(
                text: DateFormat('dd.MM.yyyy').format(_selectedDate)),
            decoration: InputDecoration(
              labelText: 'Datum auswählen',
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
                lastDate: DateTime(2200),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
          const SizedBox(height: 10.0),
          FutureBuilder<List<String>>(
              future: householdProvider.getHouseholdMembersNames(householdProvider.household.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Zeige einen Ladekreis während des Ladens an
                } else if (snapshot.hasError) {
                  return Text('Fehler: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Keine Mitglieder gefunden');
                } else {
                  final members = snapshot.data;
                  members!.add("Alle");
                  return DropdownButtonFormField<String>(
                    value: _selectedPerson,
                    items: members.map((String person) {
                      return DropdownMenuItem<String>(
                        value: person,
                        child: Text(person),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPerson = newValue ?? 'Alle'; // Aktualisiere die ausgewählte Person
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Person zuweisen',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                }
              }
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (validateTaskItemData()) {
                    String itemId;
                    if(widget.id != null) {
                      itemId = widget.id!;
                    } else {
                      itemId = DateTime.now().toString();
                    }
                    TaskItem task = TaskItem(
                        id: itemId,
                        name: _titleController.text,
                        description: _descriptionController.text,
                        assignedTo: _selectedPerson,
                        points: int.tryParse(_pointsController.text) ?? 0,
                        dateDue: Timestamp.fromDate(_selectedDate),
                        done: false);
                    if(widget.edit) {
                      householdProvider.updateTaskItem(task);
                    } else {
                      householdProvider.addTaskItem(task);
                    }
                    householdProvider.loadHousehold(widget.householdId);
                    AutoRouter.of(context).pop();
                  }
                },
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
    });
  }
}