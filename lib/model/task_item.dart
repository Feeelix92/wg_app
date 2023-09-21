import 'package:cloud_firestore/cloud_firestore.dart';

/// {@category Models}
/// Eine Klasse, die eine Aufgabe der Aufgabenliste repräsentiert.
class TaskItem {
  final String id;
  String name;
  String? description;
  Timestamp? dateDue;
  String? assignedTo; // UUID des Users
  bool done;
  String? doneBy; // UUID des Users
  Timestamp? doneOn;
  int? points;

  /// Konstruktor
  TaskItem({
    required this.id,
    required this.name,
    this.description,
    this.dateDue,
    this.assignedTo,
    required this.done,
    this.doneBy,
    this.doneOn,
    this.points,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          dateDue == other.dateDue &&
          assignedTo == other.assignedTo &&
          done == other.done &&
          doneBy == other.doneBy &&
          doneOn == other.doneOn &&
          points == other.points);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      dateDue.hashCode ^
      assignedTo.hashCode ^
      done.hashCode ^
      doneBy.hashCode ^
      doneOn.hashCode ^
      points.hashCode;

  @override
  String toString() {
    return 'TaskItem{ id: $id, name: $name, description: $description, dateDue: $dateDue, assignedTo: $assignedTo, done: $done, doneBy: $doneBy, doneOn: $doneOn, points: $points,}';
  }

  /// Erstellt eine neue Aufgabe mit den übergebenen Werten.
  TaskItem copyWith({
    String? id,
    String? name,
    String? description,
    Timestamp? dateDue,
    String? assignedTo,
    bool? done,
    String? doneBy,
    Timestamp? doneOn,
    int? points,
  }) {
    return TaskItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dateDue: dateDue ?? this.dateDue,
      assignedTo: assignedTo ?? this.assignedTo,
      done: done ?? this.done,
      doneBy: doneBy ?? this.doneBy,
      doneOn: doneOn ?? this.doneOn,
      points: points ?? this.points,
    );
  }

/// Erstellt eine Map aus einem TaskItem.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dateDue': dateDue,
      'assignedTo': assignedTo,
      'done': done,
      'doneBy': doneBy,
      'doneOn': doneOn,
      'points': points,
    };
  }

  /// Erstellt ein TaskItem aus einer Map.
  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      dateDue: map['dateDue'] as Timestamp,
      assignedTo: map['assignedTo'] as String,
      done: map['done'] as bool,
      doneBy: map['doneBy'] as String,
      doneOn: map['doneOn'] as Timestamp,
      points: map['points'] as int,
    );
  }
}