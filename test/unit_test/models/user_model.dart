import 'package:test/test.dart';
import 'package:wg_app/model/user_model.dart';

void main() {
  group('UserModel Model Tests', () {
    test('Create UserModel', () {
      const user = UserModel(
        username: 'testuser',
        firstName: 'John',
        lastName: 'Doe',
        uid: 'userId',
        email: 'test@example.com',
        birthdate: '1990-01-01',
      );

      expect(user.username, 'testuser');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.uid, 'userId');
      expect(user.email, 'test@example.com');
      expect(user.birthdate, '1990-01-01');
    });

    test('UserModel Equality', () {
      const user1 = UserModel(
        username: 'testuser',
        firstName: 'John',
        lastName: 'Doe',
        uid: 'userId',
        email: 'test@example.com',
        birthdate: '1990-01-01',
      );

      const user2 = UserModel(
        username: 'testuser',
        firstName: 'John',
        lastName: 'Doe',
        uid: 'userId',
        email: 'test@example.com',
        birthdate: '1990-01-01',
      );

      const user3 = UserModel(
        username: 'anotheruser',
        firstName: 'Jane',
        lastName: 'Smith',
        uid: 'anotherId',
        email: 'another@example.com',
        birthdate: '1995-02-15',
      );

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1, isNot(equals(user3)));
      expect(user1.hashCode, isNot(equals(user3.hashCode)));
    });
  });
}
