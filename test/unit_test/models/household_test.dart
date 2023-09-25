import 'package:test/test.dart';
import 'package:wg_app/model/household.dart';

void main() {
  group('Household Model Tests', () {
    test('Haushalt erstellen', () {
      final household = Household(
        admin: 'adminId',
        id: 'householdId',
        title: 'My Household',
        description: 'Description',
        members: ['member1', 'member2'],
      );

      expect(household.admin, 'adminId');
      expect(household.id, 'householdId');
      expect(household.title, 'My Household');
      expect(household.description, 'Description');
      expect(household.members, ['member1', 'member2']);
      expect(household.shoppingList, isEmpty);
      expect(household.taskList, isEmpty);
    });

    test('Haushalt erstellen mit shopping- und TaskListe', () {
      final household = Household(
        admin: 'adminId',
        id: 'householdId',
        title: 'My Household',
        description: 'Description',
        members: ['member1', 'member2'],
        shoppingList: ['item1', 'item2'],
        taskList: ['task1', 'task2'],
      );

      expect(household.shoppingList, ['item1', 'item2']);
      expect(household.taskList, ['task1', 'task2']);
    });
  });
}
