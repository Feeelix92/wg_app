
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:wg_app/providers/household_provider.dart';

void main() {
  group('HouseholdProvider Tests:', () {
    late HouseholdProvider householdProvider;
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockFirebaseAuth(signedIn: true);
      householdProvider = HouseholdProvider(firestore: fakeFirestore, firebaseAuth: mockAuth);
    });

    /// Test für das Erstellen eines Haushalts.
    test('Erstellen eines Haushalts', () async {
      // Schritt 1: Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      final created = await householdProvider.createHousehold("Haushalt 1", "Haushalt 1 Beschreibung");
      // Überprüfung, ob das Erstellen erfolgreich war.
      if(created) {
        expect(created, true);
        // Und, ob der erstellte Haushalt die erwarteten Werte hat.
        expect(householdProvider.household.title, "Haushalt 1");
        expect(householdProvider.household.description, "Haushalt 1 Beschreibung");
      }else{
        fail("Household konnte nicht erstellt werden");
      }
    });

    /// Test für das Erstellen und Laden eines Haushalts.
    test('Erstellen und Laden eines Haushalts', () async {
      // Schritt 1: Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      final created = await householdProvider.createHousehold("Haushalt 1", "Haushalt 1 Beschreibung");
      // Überprüfung, ob das Erstellen erfolgreich war.
      if(created) {
        expect(created, true);
        // Und, ob der erstellte Haushalt die erwarteten Werte hat.
        expect(householdProvider.household.title, "Haushalt 1");
        expect(householdProvider.household.description, "Haushalt 1 Beschreibung");
      }else{
        fail("Household konnte nicht erstellt werden");

      }
      // Schritt 2: Laden des erstellten Haushalts.
      final loaded = await householdProvider.loadHousehold(householdProvider.household.id);
      // Überprüfung, ob das Laden erfolgreich war.
      if(loaded) {
        expect(loaded, true);
      }else{
        fail("Household konnte nicht geladen werden");
      }
    });

    /// Test für das Erstellen und Aktualisieren von Titel und Beschreibung eines Haushalts.
    test('Erstellen und Aktualisieren von Titel und Beschreibung eines Haushalts', () async {
      // Schritt 1: Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      final created = await householdProvider.createHousehold("Haushalt 1", "Haushalt 1 Beschreibung");
      // Überprüfung, ob das Erstellen erfolgreich war.
      if(created) {
        expect(created, true);
        // Und, ob der erstellte Haushalt die erwarteten Werte hat.
        expect(householdProvider.household.title, "Haushalt 1");
        expect(householdProvider.household.description, "Haushalt 1 Beschreibung");
      }else{
        fail("Household konnte nicht erstellt werden");
      }

      // Schritt 2: Aktualisierung von Titel und Beschreibung des Haushalts ("Haushalt eins" und "Haushalt eins Beschreibung").
      final updated = await householdProvider.updateHouseholdTitleAndDescription("Haushalt eins", "Haushalt eins Beschreibung");
      // Überprüfung, ob das Aktualisierung erfolgreich war.
      if(updated) {
        expect(updated, true);
        expect(householdProvider.household.title, "Haushalt eins");
        expect(householdProvider.household.description, "Haushalt eins Beschreibung");
      }else{
        fail("Household konnte nicht aktualisiert werden");
      }
    });

    /// Test für das Erstellen und Löschen eines Haushalts.
    test('Erstellen und Löschen eines Haushalts', () async {
      // Schritt 1: Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      final created = await householdProvider.createHousehold("Haushalt 1", "Haushalt 1 Beschreibung");
      // Überprüfung, ob das Erstellen erfolgreich war.
      if(created) {
        expect(created, true);
        // Und, ob der erstellte Haushalt die erwarteten Werte hat.
        expect(householdProvider.household.title, "Haushalt 1");
        expect(householdProvider.household.description, "Haushalt 1 Beschreibung");
      }else{
        fail("Household konnte nicht erstellt werden");
      }

      // Schritt 2: Löschen des Haushalts.
      final deleted = await householdProvider.deleteHousehold(householdProvider.household.id);
      // Überprüfung, ob das Löschen erfolgreich war.
      if(deleted) {
        expect(deleted, true);
      }else{
        fail("Household konnte nicht gelöscht werden");
      }
    });

    /// Test für das Erstellen und Abfragen der Daten von Mitgliedern eines Haushalts.
    test('Erstellen und Abfragen der Daten von Mitgliedern eines Haushalts', () async {
      // Schritt 1: Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      final created = await householdProvider.createHousehold("Haushalt 1", "Haushalt 1 Beschreibung");
      // Überprüfung, ob das Erstellen erfolgreich war.
      if(created) {
        expect(created, true);
        // Und, ob der erstellte Haushalt die erwarteten Werte hat.
        expect(householdProvider.household.title, "Haushalt 1");
        expect(householdProvider.household.description, "Haushalt 1 Beschreibung");
      }else{
        fail("Household konnte nicht erstellt werden");
      }

      // Schritt 2: Abfragen der Daten von Mitgliedern eines Haushalts.
      final membersData = await householdProvider.getHouseholdMembersData(householdProvider.household.id);
      // Überprüfung, ob die Daten vorhanden sind.
      for (var userId in membersData.keys) {
        final currentUserUid = mockAuth.currentUser?.uid;
        final memberData = membersData[userId];

        if (currentUserUid != null && memberData != null) {
          expect(memberData['userId'], equals(currentUserUid));
        } else {
          fail("Fehler beim Abrufen von Benutzerdaten oder aktuellem Benutzer");
        }
      }

    });

    /// Test für das Erstellen eines Haushalts und Überprüfung, ob ein bestimmter Benutzer in einem bestimmten Haushalt.
    test('Erstellen eines Haushalts und Überprüfung, ob ein bestimmter Benutzer in einem bestimmten Haushalt.', () async {
      // Schritt 1: Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      final created = await householdProvider.createHousehold("Haushalt 1", "Haushalt 1 Beschreibung");
      // Überprüfung, ob das Erstellen erfolgreich war.
      if(created) {
        expect(created, true);
        // Und, ob der erstellte Haushalt die erwarteten Werte hat.
        expect(householdProvider.household.title, "Haushalt 1");
        expect(householdProvider.household.description, "Haushalt 1 Beschreibung");
      }else{
        fail("Household konnte nicht erstellt werden");
      }

      // Schritt 2: Überprüfung, ob ein bestimmter Benutzer in einem bestimmten Haushalt ist.
      final userInHousehold = await householdProvider.isUserInHousehold(householdProvider.household.id, mockAuth.currentUser!.uid);
      // Überprüfung, ob der Aufruf erfolgreich war.
      if(userInHousehold) {
        expect(userInHousehold, true);
      }else{
        fail("Mitglied oder Haushalt konnte nicht gefunden werden oder Benutzer ist nicht in Haushalt");
      }
    });

    // /// Test für das Abfragen des Username anhand der UUID
    // test('Abfragen des Username anhand der UUID', () async {
    //   final username = await householdProvider.getUsernameForUserId(mockAuth.currentUser!.uid);
    //   expect(username, mockAuth.currentUser!.displayName);
    // });
    //
    // /// Test für das Abfragen der Email anhand der Email
    // test('Abfragen des Username anhand der Email', () async {
    //   final email = mockAuth.currentUser?.email;
    //   if (email != null) {
    //     final username = await householdProvider.getUsernameFromEmail('test@mail.de');
    //     expect(username, mockAuth.currentUser!.displayName);
    //   } else {
    //     fail('Email sollte nicht null sein.');
    //   }
    // });

   //  /// Test für das Hinzufügen eines Mitglieds zu einem Haushalt.
   // test('Hinzufügen eines Mitglieds zu einem Haushalt', () async {
   //   // Schritt 1: Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
   //   final created = await householdProvider.createHousehold("Haushalt 1", "Haushalt 1 Beschreibung");
   //   // Überprüfung, ob das Erstellen erfolgreich war.
   //   if(created) {
   //     expect(created, true);
   //     // Und, ob der erstellte Haushalt die erwarteten Werte hat.
   //     expect(householdProvider.household.title, "Haushalt 1");
   //     expect(householdProvider.household.description, "Haushalt 1 Beschreibung");
   //   }else{
   //     if (kDebugMode) {
   //       print("Household konnte nicht erstellt werden");
   //     }
   //   }
   //   // Test erfolgt mit dem aktuellen Benutzer. Da dieser bereits in einem Haushalt ist, sollte das Hinzufügen fehlschlagen.
   //    final userAdded = await householdProvider.addUserToHousehold(mockAuth.currentUser!.email);
   //    if(userAdded) {
   //      expect(userAdded, false);
   //    }
   //  });

    // /// Test für das Entfernen eines Mitglieds aus einem Haushalt und erneutem Hinzufügen.
    // test('Entfernen eines Mitglieds aus einem Haushalt und erneutem Hinzufügen', () async {
    //   // Der aktuelle User wird zuerst entfernt...
    //   final userRemoved = await householdProvider.removeUserFromHousehold(mockAuth.currentUser!.email!);
    //   if(userRemoved) {
    //     expect(userRemoved, true);
    //     // ...und dann wieder hinzugefügt.
    //     final userAdded = await householdProvider.addUserToHousehold(mockAuth.currentUser!.email!);
    //     if(userAdded) {
    //       expect(userAdded, true);
    //     }
    //   }
    // });
  });
}
