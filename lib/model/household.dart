/// {@category Models}
/// Eine Klasse, die einen Haushalt repräsentiert.
class Household {
  final String id; // UUID des Users
  String title;
  String description;
  String admin;
  List<String> members; // Liste der Personen, die dem Haushalt angehören
  List<dynamic> shoppingList; // Liste von Einkäufen
  List<dynamic> taskList; // Liste von Aufgaben
  Map<String, num> expenses; // Map mit allen Mitgliedern des Haushalts und ihren gesammelten Ausgaben
  Map<String, num> scoreboard; // Map mit allen Mitgliedern des Haushalts und ihren gesammelten Punkten

  /// Konstruktor
  Household({
    required this.admin,
    required this.id,
    required this.title,
    required this.description,
    required this.members,
    List<dynamic>? shoppingList, // Standardmäßig leere Listen
    List<dynamic>? taskList, // Standardmäßig leere Listen
    Map<String, num>? expenses,
    Map<String, num>? scoreboard,
  }) : shoppingList = shoppingList ?? [],
        taskList = taskList ?? [],
        expenses = expenses ?? {},
        scoreboard = scoreboard ?? {};
}