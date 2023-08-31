import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String Id;
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
    required this.Id,
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
          Id == other.Id &&
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
      Id.hashCode ^
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
    return 'ShoppingItem{ Id: $Id, name: $name, description: $description, amount: $amount, price: $price, date_due: $dateDue, assignedTo: $assignedTo, done: $done, doneBy: $doneBy, doneOn: $doneOn, points: $points,}';
  }

  ShoppingItem copyWith({
    String? Id,
    String? name,
    String? description,
    int? amount,
    double? price,
    Timestamp? date_due,
    String? assignedTo,
    bool? done,
    String? doneBy,
    Timestamp? doneOn,
    int? points,
  }) {
    return ShoppingItem(
      Id: Id ?? this.Id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      dateDue: date_due ?? this.dateDue,
      assignedTo: assignedTo ?? this.assignedTo,
      done: done ?? this.done,
      doneBy: doneBy ?? this.doneBy,
      doneOn: doneOn ?? this.doneOn,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
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
      Id: map['Id'] as String,
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
