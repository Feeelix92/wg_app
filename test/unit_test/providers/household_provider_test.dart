
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:wg_app/model/shopping_item.dart';
import 'package:wg_app/model/task_Item.dart';
import 'package:wg_app/providers/household_provider.dart';

void main() {
  group('HouseholdProvider Tests:', () {
    late HouseholdProvider householdProvider;
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;
    final mockUser = MockUser(
      isAnonymous: false,
      email: 'test@mail.de',
      displayName: 'Test User',
    );

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      householdProvider = HouseholdProvider(firestore: fakeFirestore, firebaseAuth: mockAuth);
    });

    Future<void> createHouseholdAndAssert(String title, String description) async {
      final created = await householdProvider.createHousehold(title, description);
      expect(created, true);
      expect(householdProvider.household.title, title);
      expect(householdProvider.household.description, description);

      // Überprüfung, ob das Erstellen erfolgreich war.
      if(created) {
        expect(created, true);
        // Und, ob der erstellte Haushalt die erwarteten Werte hat.
        expect(householdProvider.household.title, title);
        expect(householdProvider.household.description, description);
      }else{
        fail("Household konnte nicht erstellt werden");
      }
    }

    /// Test für das Erstellen eines Haushalts.
    test('Test createHousehold', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");
    });

    /// Test für das Erstellen und Laden eines Haushalts.
    test('Test loadHousehold', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");
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
    test('Test updateHouseholdTitleAndDescription', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");

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
    test('Test deleteHousehold', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");

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
    test('Test getHouseholdMembersData', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");

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
    test('Test isUserInHousehold', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");

      // Schritt 2: Überprüfung, ob ein bestimmter Benutzer in einem bestimmten Haushalt ist.
      final userInHousehold = await householdProvider.isUserInHousehold(householdProvider.household.id, mockAuth.currentUser!.uid);
      // Überprüfung, ob der Aufruf erfolgreich war.
      if(userInHousehold) {
        expect(userInHousehold, true);
      }else{
        fail("Mitglied oder Haushalt konnte nicht gefunden werden oder Benutzer ist nicht in Haushalt");
      }
    });

    /// Test für das Abfragen des Username anhand der UUID
    test('Test getUsernameForUserId', () async {
      // Simulieren einer gültigen Benutzer-UUID und eines gespeicherten Benutzernamens in Firestore.
      const userId = 'gültigeBenutzerID123';
      const expectedUsername = 'Gültiger Benutzername';

      // Hinzufügen der Daten in Firestore (Simulieren der Datenbank).
      fakeFirestore.collection('users').doc(userId).set({'username': expectedUsername});

      // Methodenaufruf mit der simulierten Benutzer-UUID.
      final username = await householdProvider.getUsernameForUserId(userId);

      // Überprüfung, ob die Methode den erwarteten Benutzernamen zurückgibt.
      expect(username, expectedUsername);

      // Test, wnen die Benutzer-ID nicht vorhanden ist.
      const nonExistentUserId = 'ungültigeBenutzerID456';
      final nonExistentUsername = await householdProvider.getUsernameForUserId(nonExistentUserId);
      expect(nonExistentUsername, isNull); // Benutzer sollte nicht gefunden werden.
    });

    /// Test für das Abfragen des Username anhand der Email
    test('Test getUsernameFromEmail', () async {
      // Simulieren einer gültigen E-Mail-Adresse und eines Benutzernamen in Firestore.
      const userEmail = 'test@mail.de';
      const expectedUsername = 'Gültiger Benutzername';

      // Hinzufügen der Daten in Firestore (Simulieren der Datenbank).
      fakeFirestore.collection('users').add({'email': userEmail, 'username': expectedUsername});

      // Methodenaufruf getUsernameFromEmail.
      final username = await householdProvider.getUsernameFromEmail(userEmail);

      // Überprüfung, ob die Methode den erwarteten Benutzernamen zurückgibt.
      expect(username, expectedUsername);

      // Test, ob die E-Mail nicht vorhanden ist.
      const nonExistentUserEmail = 'nichtvorhanden@mail.de';
      final nonExistentUsername = await householdProvider.getUsernameFromEmail(nonExistentUserEmail);
      expect(nonExistentUsername, isNull); // E-Mail-Adresse sollte nicht gefunden werden.
    });

   /// Test für das Hinzufügen eines Mitglieds zu einem Haushalt.
    test('Test addUserToHousehold', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");

      const userEmail = 'tester@mail.de';
      const expectedUsername = 'Gültiger Benutzername';

      // Hinzufügen der Daten in Firestore (Simulieren der Datenbank).
      fakeFirestore.collection('users').add({'email': userEmail, 'username': expectedUsername});

      // Hinzufügen des Benutzers zum Haushalt.
      final added = await householdProvider.addUserToHousehold(userEmail);

      // Überprüfen, ob der Benutzer erfolgreich hinzugefügt wurde.
      expect(added, true);

      // Testen, ob der Benutzer bereits im Haushalt ist.
      final alreadyAdded = await householdProvider.addUserToHousehold(userEmail);
      expect(alreadyAdded, false); // Benutzer sollte nicht erneut hinzugefügt werden.
    });

    /// Test für das Entfernen eines Mitglieds aus einem Haushalt und erneutem Hinzufügen.
    test('Entfernen eines Mitglieds aus einem Haushalt und erneutem Hinzufügen', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");

      // Der aktuelle User wird zuerst entfernt...
      final userRemoved = await householdProvider.removeUserFromHousehold(mockAuth.currentUser!.email!);
      if(userRemoved) {
        expect(userRemoved, true);
        // ...und dann wieder hinzugefügt.

        const userEmail = 'tester@mail.de';
        const expectedUsername = 'Gültiger Benutzername';

        // Hinzufügen der Daten in Firestore (Simulieren der Datenbank).
        fakeFirestore.collection('users').add({'email': userEmail, 'username': expectedUsername});

        // Hinzufügen des Benutzers zum Haushalt.
        final added = await householdProvider.addUserToHousehold(userEmail);

        // Überprüfen, ob der Benutzer erfolgreich hinzugefügt wurde.
        expect(added, true);
      }
    });

    /// Test für das Ändern des Admins in einem Haushalt.
    test('Test changeAdmin', () async {
      // Erstellen eines Haushalts ("Haushalt 1") mit einer Beschreibung ("Haushalt 1 Beschreibung").
      await createHouseholdAndAssert("Haushalt 1", "Haushalt 1 Beschreibung");

      expect(householdProvider.household.admin == householdProvider.household.members[0], true);

      const userEmail = 'tester@mail.de';
      const expectedUsername = 'Gültiger Benutzername';

      // Hinzufügen der Daten in Firestore (Simulieren der Datenbank).
      fakeFirestore.collection('users').add({'email': userEmail, 'username': expectedUsername});

      // Hinzufügen des Benutzers zum Haushalt.
      final added = await householdProvider.addUserToHousehold(userEmail);

      // Überprüfen, ob der Benutzer erfolgreich hinzugefügt wurde.
      expect(added, true);

      // Ändern des Administrators des Haushalts.
      final changed = await householdProvider.changeAdmin(userEmail);

      // Überprüfen, ob die Änderung erfolgreich war.
      expect(changed, true);

      // Überprüfen, ob der Benutzer tatsächlich der neue Administrator ist.
      // final household = await householdProvider.loadHousehold(householdProvider.household.id);

      expect(householdProvider.household.admin == householdProvider.household.members[0], false);
      expect(householdProvider.household.admin == householdProvider.household.members[1], true);
    });

    /// Test für das Hinzufügen und Entfernen eines Elements zur Einkaufsliste.
    test('Test addShoppingItem', () async {
      await createHouseholdAndAssert('Haushalt 1', 'Haushalt 1 Beschreibung');
      final itemId = DateTime.timestamp().toString();

      // überprüfen, ob ein Element hinzugefügt wurde und ob die Rückgabe true ist.
      final item = ShoppingItem(id: itemId, name: 'Test Item', description: '', amount: 2, price: 2.99, done: false);
      final added = await householdProvider.addShoppingItem(item);

      // Überprüfen, ob das Hinzufügen erfolgreich war.
      expect(added, true);
      expect(item.toMap(), householdProvider.household.shoppingList[0]);

      final removed = await householdProvider.removeShoppingItem(itemId);
      expect(removed, true);  // überprüfen, ob ein Element entfernt wurde und ob die Rückgabe true ist.
      expect(householdProvider.household.shoppingList.isEmpty, true); // überprüfen, ob das Element tatsächlich entfernt wurde.
    });

    /// Test für das Hinzufügen und updaten eines Elements der Einkaufsliste.
    test('Test updateShoppingItem', () async {
      await createHouseholdAndAssert('Haushalt 1', 'Haushalt 1 Beschreibung');
      final itemId = DateTime.timestamp().toString();

      // überprüfen, ob ein Element hinzugefügt wurde und ob die Rückgabe true ist.
      final item = ShoppingItem(id: itemId, name: 'Test Item', description: '', amount: 2, price: 2.99, done: false);
      final added = await householdProvider.addShoppingItem(item);

      // Überprüfen, ob das Hinzufügen erfolgreich war.
      expect(added, true);
      expect(item.toMap(), householdProvider.household.shoppingList[0]);

      item.name = 'Test Item update';
      item.description = 'Test Item update';
      item.amount = 3;
      item.price = 3.99;

      final updated = await householdProvider.updateShoppingItem(item);
      expect(updated, true);  // überprüfen, ob das Element aktualisiert wurde und ob die Rückgabe true ist.
      expect(item.toMap(), householdProvider.household.shoppingList[0]); // überprüfen, ob das Element tatsächlich aktualisiert wurde.
    });

    /// Test für das Hinzufügen und Entfernen eines Elements zur Aufgabenliste.
    test('Test addTaskItem', () async {
      await createHouseholdAndAssert('Haushalt 1', 'Haushalt 1 Beschreibung');
      final itemId = DateTime.timestamp().toString();

      // überprüfen, ob ein Element hinzugefügt wurde und ob die Rückgabe true ist.
      final item = TaskItem(id: itemId, name: 'Test Item', description: '', done: false);
      final added = await householdProvider.addTaskItem(item);

      // Überprüfen, ob das Hinzufügen erfolgreich war.
      expect(added, true);
      expect(item.toMap(), householdProvider.household.taskList[0]);

      final removed = await householdProvider.removeTaskItem(itemId);
      expect(removed, true);  // überprüfen, ob ein Element entfernt wurde und ob die Rückgabe true ist.
      expect(householdProvider.household.taskList.isEmpty, true); // überprüfen, ob das Element tatsächlich entfernt wurde.
    });

    /// Test für das Hinzufügen und Entfernen eines Elements zur Aufgabenliste.
    test('Test updateTaskItem', () async {
      await createHouseholdAndAssert('Haushalt 1', 'Haushalt 1 Beschreibung');
      final itemId = DateTime.timestamp().toString();

      // überprüfen, ob ein Element hinzugefügt wurde und ob die Rückgabe true ist.
      final item = TaskItem(id: itemId, name: 'Test Item', description: '', done: false);
      final added = await householdProvider.addTaskItem(item);

      // Überprüfen, ob das Hinzufügen erfolgreich war.
      expect(added, true);
      expect(item.toMap(), householdProvider.household.taskList[0]);

      final updated = await householdProvider.updateTaskItem(item);
      expect(updated, true);  // überprüfen, ob das Element aktualisiert wurde und ob die Rückgabe true ist.
      expect(item.toMap(), householdProvider.household.taskList[0]); // überprüfen, ob das Element tatsächlich aktualisiert wurde.
    });
  });
}
