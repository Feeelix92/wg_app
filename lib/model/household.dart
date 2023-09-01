class Household {
  final String id; // UUID des Users
  String title;
  String description;
  String admin;
  List<String> members; // Liste der Personen, die dem Haushalt angehören
  List<dynamic> shoppingList; // Liste von Einkäufen
  List<dynamic> taskList; // Liste von Aufgaben

  Household({
    required this.admin,
    required this.id,
    required this.title,
    required this.description,
    required this.members,
    List<dynamic>? shoppingList, // Standardmäßig leere Listen
    List<dynamic>? taskList, // Standardmäßig leere Listen
  }) : shoppingList = shoppingList ?? [],
        taskList = taskList ?? [];
}