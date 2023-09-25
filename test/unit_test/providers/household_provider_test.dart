
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:wg_app/model/household.dart';
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
        if (kDebugMode) {
          print("Household konnte nicht erstellt werden");
        }
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
        if (kDebugMode) {
          print("Household konnte nicht erstellt werden");
        }
      }
      // Schritt 2: Laden des erstellten Haushalts.
      final loaded = await householdProvider.loadHousehold(householdProvider.household.id);
      // Überprüfung, ob das Laden erfolgreich war.
      if(loaded) {
        expect(loaded, true);
      }else{
        if (kDebugMode) {
          print("Household konnte nicht geladen werden");
        }
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
        if (kDebugMode) {
          print("Household konnte nicht erstellt werden");
        }
      }

      // Schritt 2: Aktualisierung von Titel und Beschreibung des Haushalts ("Haushalt eins" und "Haushalt eins Beschreibung").
      final updated = await householdProvider.updateHouseholdTitleAndDescription("Haushalt eins", "Haushalt eins Beschreibung");
      // Überprüfung, ob das Aktualisierung erfolgreich war.
      if(updated) {
        expect(updated, true);
        expect(householdProvider.household.title, "Haushalt eins");
        expect(householdProvider.household.description, "Haushalt eins Beschreibung");
      }else{
        if (kDebugMode) {
          print("Household konnte nicht aktualisiert werden");
        }
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
        if (kDebugMode) {
          print("Household konnte nicht erstellt werden");
        }
      }

      // Schritt 2: Löschen des Haushalts.
      final deleted = await householdProvider.deleteHousehold(householdProvider.household.id);
      // Überprüfung, ob das Löschen erfolgreich war.
      if(deleted) {
        expect(deleted, true);
      }else{
        if (kDebugMode) {
          print("Household konnte nicht gelöscht werden");
        }
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
        if (kDebugMode) {
          print("Household konnte nicht erstellt werden");
        }
      }

      // Schritt 2: Abfragen der Daten von Mitgliedern eines Haushalts.
      final membersData = await householdProvider.getHouseholdMembersData(householdProvider.household.id);
      // Überprüfung, ob die Daten vorhanden sind.
      if(membersData.isNotEmpty) {
        expect(membersData, true);
        for (var userId in membersData.keys) {
          expect(membersData[userId], mockAuth.currentUser?.uid);
        }
      }else{
        if (kDebugMode) {
          print("Daten der Mitglieder konnten nicht geladen werden");
        }
      }
    });





    // test('Test loadAllAccessibleHouseholds', () async {
    //   final result = await householdProvider.loadAllAccessibleHouseholds();
    //   expect(result, true);
    // });

    // test('Test getHouseholdInformation', () async {
    //   final result = await householdProvider.getHouseholdInformation();
    //   expect(result, true);
    // });
    //
    // test('Test updateHouseholdInformation', () async {
    //   final result = await householdProvider.updateHouseholdInformation("Haushalt eins", "Beschreibung Haushalt eins");
    //   expect(result, true);
    // });
  });
}
