import 'package:wg_app/model/shoppingItem.dart';
import 'package:wg_app/model/taskItem.dart';

class Household {
  final int id;
  final String title;
  final String description;
  List<String> members; // Liste der Personen, die dem Haushalt angehören
  List<ShoppingItem> shoppingList; // Liste von Einkäufen
  List<TaskItem> taskList; // Liste von Aufgaben

  Household({
    required this.id,
    required this.title,
    required this.description,
    required this.members,
    this.shoppingList = const [], // Standardmäßig leere Listen
    this.taskList = const [], // Standardmäßig leere Listen
  });
}