import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:wg_app/providers/household_provider.dart';

void main() {
  group('HouseholdProvider Tests', () {
    late HouseholdProvider householdProvider;
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockFirebaseAuth(signedIn: true);
      householdProvider = HouseholdProvider(firestore: fakeFirestore, firebaseAuth: mockAuth);
    });

    test('Test createHousehold', () async {
      final result = await householdProvider.createHousehold("Test Haushalt", "Test Beschreibung");
      expect(result, true);
    });

    test('Test loadAllAccessibleHouseholds', () async {
      final result = await householdProvider.loadAllAccessibleHouseholds();
      expect(result, true);
    });

    // Add more tests for your other functions.
  });
}
