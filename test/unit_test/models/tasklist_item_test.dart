import 'package:test/test.dart';
import 'package:wg_app/model/task_Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('TaskItem Model Tests', () {
    test('Create TaskItem', () {
      final taskItem = TaskItem(
        id: 'itemId',
        name: 'Task Name',
        description: 'Task Description',
        dateDue: Timestamp.now(),
        assignedTo: 'assignedUserId',
        done: false,
        doneBy: 'doneByUserId',
        doneOn: Timestamp.now(),
        points: 5,
      );

      expect(taskItem.id, 'itemId');
      expect(taskItem.name, 'Task Name');
      expect(taskItem.description, 'Task Description');
      expect(taskItem.dateDue, isA<Timestamp>());
      expect(taskItem.assignedTo, 'assignedUserId');
      expect(taskItem.done, false);
      expect(taskItem.doneBy, 'doneByUserId');
      expect(taskItem.doneOn, isA<Timestamp>());
      expect(taskItem.points, 5);
    });

    test('TaskItem Equality', () {
      final taskItem1 = TaskItem(
        id: 'itemId',
        name: 'Task Name',
        description: 'Task Description',
        dateDue: Timestamp.now(),
        assignedTo: 'assignedUserId',
        done: false,
        doneBy: 'doneByUserId',
        doneOn: Timestamp.now(),
        points: 5,
      );

      final taskItem2 = TaskItem(
        id: 'itemId',
        name: 'Task Name',
        description: 'Task Description',
        dateDue: Timestamp.now(),
        assignedTo: 'assignedUserId',
        done: false,
        doneBy: 'doneByUserId',
        doneOn: Timestamp.now(),
        points: 5,
      );

      final taskItem3 = TaskItem(
        id: 'anotherId',
        name: 'Another Task',
        description: 'Another Description',
        dateDue: Timestamp.now(),
        assignedTo: 'anotherUserId',
        done: true,
        doneBy: 'doneByUserId',
        doneOn: Timestamp.now(),
        points: 10,
      );

      expect(taskItem1, equals(taskItem2));
      expect(taskItem1.hashCode, equals(taskItem2.hashCode));
      expect(taskItem1, isNot(equals(taskItem3)));
      expect(taskItem1.hashCode, isNot(equals(taskItem3.hashCode)));
    });

  });
}
