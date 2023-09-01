import 'package:wg_app/model/shoppingItem.dart';
import 'package:wg_app/model/taskItem.dart';
import 'package:wg_app/model/user_model.dart';

class Household {
  final String id;
  String title;
  String description;
  String admin; // UUID des Users
  List<String> members; // Liste der Personen, die dem Haushalt angehören
  List<ShoppingItem> shoppingList; // Liste von Einkäufen
  List<TaskItem> taskList; // Liste von Aufgaben

  Household({
    required this.admin,
    required this.id,
    required this.title,
    required this.description,
    required this.members,
    List<ShoppingItem>? shoppingList, // Standardmäßig leere Listen
    List<TaskItem>? taskList, // Standardmäßig leere Listen
  }) : shoppingList = shoppingList ?? [],
        taskList = taskList ?? [];
}