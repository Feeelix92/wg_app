import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String id;
  final String name;
  String? description;
  final int amount;
  final double price;
  Timestamp? dateDue;
  String? assignedTo; // UUID des Users
  final bool done;
  String? doneBy; // UUID des Users
  Timestamp? doneOn;
  int? points;

//<editor-fold desc="Data Methods">
  ShoppingItem({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.price,
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
      (other is ShoppingItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          amount == other.amount &&
          price == other.price &&
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
      amount.hashCode ^
      price.hashCode ^
      dateDue.hashCode ^
      assignedTo.hashCode ^
      done.hashCode ^
      doneBy.hashCode ^
      doneOn.hashCode ^
      points.hashCode;

  @override
  String toString() {
    return 'ShoppingItem{ id: $id, name: $name, description: $description, amount: $amount, price: $price, date_due: $dateDue, assignedTo: $assignedTo, done: $done, doneBy: $doneBy, doneOn: $doneOn, points: $points,}';
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? description,
    int? amount,
    double? price,
    Timestamp? dateDue,
    String? assignedTo,
    bool? done,
    String? doneBy,
    Timestamp? doneOn,
    int? points,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      dateDue: dateDue ?? this.dateDue,
      assignedTo: assignedTo ?? this.assignedTo,
      done: done ?? this.done,
      doneBy: doneBy ?? this.doneBy,
      doneOn: doneOn ?? this.doneOn,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'price': price,
      'date_due': dateDue,
      'assignedTo': assignedTo,
      'done': done,
      'doneBy': doneBy,
      'doneOn': doneOn,
      'points': points,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      amount: map['amount'] as int,
      price: map['price'] as double,
      dateDue: map['date_due'] as Timestamp,
      assignedTo: map['assignedTo'] as String,
      done: map['done'] as bool,
      doneBy: map['doneBy'] as String,
      doneOn: map['doneOn'] as Timestamp,
      points: map['points'] as int,
    );
  }

//</editor-fold>
}
