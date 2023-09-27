import 'package:test/test.dart';
import 'package:wg_app/model/shopping_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {

  final dateDueTime = Timestamp.now();
  final dateDoneTime = Timestamp.now();

  group('ShoppingItem Model Tests', () {
    test('ShoppingItem erstellen', () {
      final shoppingItem = ShoppingItem(
        id: 'itemId',
        name: 'Item Name',
        description: 'Item Description',
        amount: 2,
        price: 10.99,
        dateDue: dateDueTime,
        assignedTo: 'assignedUserId',
        done: false,
        doneBy: 'doneByUserId',
        doneOn: dateDoneTime,
        points: 5,
      );

      expect(shoppingItem.id, 'itemId');
      expect(shoppingItem.name, 'Item Name');
      expect(shoppingItem.description, 'Item Description');
      expect(shoppingItem.amount, 2);
      expect(shoppingItem.price, 10.99);
      expect(shoppingItem.dateDue, isA<Timestamp>());
      expect(shoppingItem.assignedTo, 'assignedUserId');
      expect(shoppingItem.done, false);
      expect(shoppingItem.doneBy, 'doneByUserId');
      expect(shoppingItem.doneOn, isA<Timestamp>());
      expect(shoppingItem.points, 5);
    });

    test('ShoppingItem Equality', () {
      final shoppingItem1 = ShoppingItem(
        id: 'itemId',
        name: 'Item Name',
        description: 'Item Description',
        amount: 2,
        price: 10.99,
        dateDue: dateDueTime,
        assignedTo: 'assignedUserId',
        done: false,
        doneBy: 'doneByUserId',
        doneOn: dateDoneTime,
        points: 5,
      );

      final shoppingItem2 = ShoppingItem(
        id: 'itemId',
        name: 'Item Name',
        description: 'Item Description',
        amount: 2,
        price: 10.99,
        dateDue: dateDueTime,
        assignedTo: 'assignedUserId',
        done: false,
        doneBy: 'doneByUserId',
        doneOn: dateDoneTime,
        points: 5,
      );

      final shoppingItem3 = ShoppingItem(
        id: 'anotherId',
        name: 'Another Item',
        description: 'Another Description',
        amount: 1,
        price: 5.99,
        dateDue: dateDueTime,
        assignedTo: 'anotherUserId',
        done: true,
        doneBy: 'doneByUserId',
        doneOn: dateDoneTime,
        points: 10,
      );

      expect(shoppingItem1, equals(shoppingItem2));
      expect(shoppingItem1.hashCode, equals(shoppingItem2.hashCode));
      expect(shoppingItem1, isNot(equals(shoppingItem3)));
      expect(shoppingItem1.hashCode, isNot(equals(shoppingItem3.hashCode)));
    });
  });
}
