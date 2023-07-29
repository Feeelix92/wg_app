class Household {
  final int id;
  final String title;
  final String description;
  List<String> members; // Liste der Personen, die dem Haushalt angehören

  Household({
    required this.id,
    required this.title,
    required this.description,
    required this.members,
  });
}