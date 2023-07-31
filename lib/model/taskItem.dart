class TaskItem {
  String title;
  String description;
  DateTime date;
  bool isDone;
  String? assignedTo; // Person, der die Aufgabe zugewiesen ist

  TaskItem({
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
    required this.assignedTo,
  });
}