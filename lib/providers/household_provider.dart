import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:wg_app/model/household.dart';
import 'package:wg_app/model/shopping_item.dart';

import '../model/task_Item.dart';

/// {@category Providers}
/// Die HouseholdProvider Klasse, verwaltet alle Daten die zum Haushalt gehören und enthält einige Methoden für das Arbeiten mit diesen Daten
class HouseholdProvider extends ChangeNotifier {
  final FirebaseFirestore db;
  final FirebaseAuth auth;

  HouseholdProvider({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
      : db = firestore ?? FirebaseFirestore.instance,
        auth = firebaseAuth ?? FirebaseAuth.instance;

  /// Haushalt der aktuell ausgewählt ist
  late Household _household;
  Household get household => _household;

  /// Liste aller für den User verfügbaren Haushalte
  late List<Household> _accessibleHouseholds = [];
  List<Household> get accessibleHouseholds => _accessibleHouseholds;


  /// Funktion die den aktuellen Haushalt updatet
  Future updateHouseholdInformation() async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      _household = Household(
        admin: householdDetailData['admin'],
        id: _household.id,
        title: householdDetailData['title'],
        description: householdDetailData['description'],
        members: householdDetailData['members'].cast<String>(),
        shoppingList: householdDetailData['shoppingList'].cast<Map<String, dynamic>>(),
        taskList: householdDetailData['taskList'].cast<Map<String, dynamic>>(),
        expenses: householdDetailData['expenses'],
        scoreboard: householdDetailData['scoreboard'],
      );

      /// Benachrichtige alle Listener, dass sich die Daten geändert haben
      notifyListeners();

      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  /// Funktion die einen Haushalt erstellt
  Future<bool> createHousehold(String title, String description) async {
    try {
      final docRefHousehold = await db.collection("households").add({
        'title': title,
        'description': description,
        'admin': auth.currentUser!.uid,
        'members': [auth.currentUser!.uid],
        'shoppingList': [],
        'taskList': [],
        'expenses': {auth.currentUser!.uid: 0},
        'scoreboard': {auth.currentUser!.uid: 0},
      });

      /// Damit die ID des Haushalts für die Methode updateHouseholdInformation() verfügbar ist
      _household = Household(
        admin: auth.currentUser!.uid,
        id: docRefHousehold.id,
        title: title,
        description: description,
        members: [auth.currentUser!.uid],
        shoppingList: [],
        taskList: [],
        expenses: {auth.currentUser!.uid: 0},
        scoreboard: {auth.currentUser!.uid: 0},
      );

      await updateHouseholdInformation();

      /// Benachrichtige alle Listener, dass sich die Daten geändert haben
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Die Methode updateHouseholdTitleAndDescription aktualisiert den Titel und die Beschreibung eines Haushalts in der Datenbank
  Future<bool> updateHouseholdTitleAndDescription(String title, String description) async {
    try {
      await db.collection("households").doc(_household.id).update({
        'title': title,
        'description': description,
      });

      /// Nach dem Aktualisieren der Daten in Firebase die lokale Kopie aktualisieren
      _household.title = title;
      _household.description = description;

      /// Benachrichtige alle Listener, dass sich die Daten geändert haben
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Die Methode deleteHousehold löscht einen spezifischen Haushalt aus der Datenbank
  Future<bool> deleteHousehold(String householdId) async {
    try {
      /// Löschen der Shopping- und Task-Liste des Haushalts
      await Future.wait([
        db.collection("households").doc(householdId)
            .collection("shoppingList")
            .get()
            .then((querySnapshot) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        }),
        db.collection("households").doc(householdId)
            .collection("taskList")
            .get()
            .then((querySnapshot) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        }),
      ]);

      /// Löschen des Haushalts
      await db.collection("households").doc(householdId).delete();

      /// Benachrichtige alle Listener, dass sich die Daten geändert haben
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Statische Mitgliederliste für Testzwecke im Frontend
  final Map<String, Map<String, dynamic>> staticMembers = {
    'staticUserId1': {
      'username': 'StaticUser1',
      'email': 'staticuser1@example.com',
    },
    'staticUserId2': {
      'username': 'StaticUser2',
      'email': 'staticuser2@example.com',
    },
    'staticUserId3': {
      'username': 'StaticUser3',
      'email': 'staticuser3@example.com',
    },
    'staticUserId4': {
      'username': 'StaticUser4',
      'email': 'staticuser4@example.com',
    },
    'staticUserId5': {
      'username': 'StaticUser5',
      'email': 'staticuser5@example.com',
    },
    'staticUserId6': {
      'username': 'StaticUser6',
      'email': 'staticuser6@example.com',
    },
    'staticUserId7': {
      'username': 'StaticUser7',
      'email': 'staticuser7@example.com',
    },
  };

  /// Funktion die die Daten aller Mitglieder eines Haushalts lädt
  Future<Map<String, Map<String, dynamic>>> getHouseholdMembersData(String householdId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(householdId).get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
        final memberIds = householdDetailData['members'].cast<String>();

        final memberData = <String, Map<String, dynamic>>{};

        for (final memberId in memberIds) {
          final docRefUser = await db.collection("users").doc(memberId).get();
          if (docRefUser.exists) {
            final userData = docRefUser.data() as Map<String, dynamic>;
            final memberName = userData['username'];
            final memberEmail = userData['email'];

            if (memberName != null) {
              memberData[memberId] = {'username': memberName, 'email': memberEmail};
            }
          }
        }
        return memberData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }


  /// Funktion gibt eine Liste aller User die nicht in einem bestimtmen Haushalt Mitglied sind zurück
  Future<Map<String, String>> getUsersNotInHousehold(String householdId) async {
    try {
      final usersCollection = db.collection("users");
      final querySnapshot = await usersCollection.get();

      final usersMap = <String, String>{};

      for (final doc in querySnapshot.docs) {
        final userData = doc.data();
        final email = userData['email'] as String;
        final username = userData['username'] as String;

        final userInHousehold = await isUserInHousehold(householdId, doc.id);

        if (!userInHousehold) {
          usersMap[email] = username;
        }
      }

      return usersMap;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      /// Wenn ein Fehler auftritt oder keine Benutzer vorhanden sind.
      return {};
    }
  }

  /// Funktion prüft ob ein User Mitglied in einem bestimmten Haushalt ist
  Future<bool> isUserInHousehold(String householdId, String userId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(householdId).get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
        final memberIds = householdDetailData['members'].cast<String>();

        return memberIds.contains(userId);
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      /// Wenn ein Fehler auftritt oder der Haushalt nicht gefunden wird.
      return false;
    }
  }
 /// Funktion die den Username mithilfe der UserId herausfindet
  Future<String?> getUsernameForUserId(String userId) async {
    try {
      final docRefUser = await db.collection("users").doc(userId).get();

      if (docRefUser.exists) {
        final userData = docRefUser.data() as Map<String, dynamic>;
        return userData['username'] as String?;
      }
      /// Benutzer nicht gefunden
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      /// Fehler beim Abrufen der Benutzerdaten
      return null;
    }
  }


  /// Funktion die den Username mithilfe der Email herausfindet
  Future<String?> getUsernameFromEmail(String email) async {
    try {
      final usersCollection = db.collection("users");
      final querySnapshot = await usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final username = userData['username'] as String?;
        return username;
      } else {
        /// Wenn die E-Mail-Adresse nicht gefunden wurde.
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      /// Wenn ein Fehler auftritt.
      return null;
    }
  }

  /// Funktion die die Email mithilfe des Usernamen herausfindet
  Future<String?> getEmailFromUsername(String username) async {
    try {
      final usersCollection = db.collection("users");
      final querySnapshot = await usersCollection.where('username', isEqualTo: username).get();

      /// Überprüfen ob der Username existiert
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final email = userData['email'] as String?;
        return email;
      } else {
        /// Wenn der Username nicht gefunden wurde.
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      /// Wenn ein Fehler auftritt.
      return null;
    }
  }


  /// Suche nach User in der Datenbank anhand der Email und füge ihn dem Haushalt hinzu
  Future<bool> addUserToHousehold(String email) async {
    try {
      final docRefUser = await db.collection("users").where('email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty){
        return false;
      }

      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();
      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
      /// Abrufen der ID (uid) des Benutzers
      final userId = docRefUser.docs.first.id;
      final List<String> members = householdDetailData['members'].cast<String>();
      final Map<String, dynamic> expenses = householdDetailData['expenses'];
      final Map<String, dynamic> scoreboard = householdDetailData['scoreboard'];

      /// Überprüfen, ob der Benutzer bereits im Haushalt ist
      if (!members.contains(userId)) {
        members.add(userId);
        expenses[userId] = 0;
        scoreboard[userId] = 0;

        await db.collection("households").doc(_household.id.toString()).update({
          'members': members,
          'expenses': expenses,
          'scoreboard': scoreboard,
        });

        await updateHouseholdInformation();
      } else {
        /// Benutzer ist bereits im Haushalt
        return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die einen User anhand der Email aus einem Haushalt entfernt
  Future<bool> removeUserFromHousehold(String email) async {
    try {
      final docRefUser = await db.collection("users").where('email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty) return false;

      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final userId = docRefUser.docs.first.id; // Abrufen der ID (uid) des Benutzers

      final List<String> members = householdDetailData['members'].cast<String>();
      final Map<String, dynamic> expenses = householdDetailData['expenses'];
      final Map<String, dynamic> scoreboard = householdDetailData['scoreboard'];
      members.remove(userId);
      expenses.removeWhere((key, value) => key == userId);
      scoreboard.removeWhere((key, value) => key == userId);

      await db.collection("households").doc(_household.id.toString()).update({
        'members': members,
        'expenses': expenses,
        'scoreboard': scoreboard,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die alle Haushalte eines Users lädt
  Future<bool> loadAllAccessibleHouseholds() async {
    try {
      final querySnapshot = await db.collection("households").where("members", arrayContains: auth.currentUser!.uid).get();
      final households = <Household>[];

      for (final docSnapshot in querySnapshot.docs) {
        final householdDetailData = docSnapshot.data();
        final household = Household(
          admin: householdDetailData['admin'],
          id: docSnapshot.id,
          title: householdDetailData['title'],
          description: householdDetailData['description'],
          members: householdDetailData['members'].cast<String>(),
          shoppingList: householdDetailData['shoppingList'],
          taskList: householdDetailData['taskList'],
        );
        households.add(household);
      }
      _accessibleHouseholds = households;

      /// Benachrichtige alle Listener, dass sich die Daten geändert haben
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die einen Haushalt anhand der ID lädt
  Future<bool> loadHousehold(String id) async {
    try {
      final docRefHousehold = await db.collection("households").doc(id).get();
      final householdDetailData = docRefHousehold.data();

      _household = Household(
        admin: householdDetailData?['admin'],
        id: docRefHousehold.id,
        title: householdDetailData?['title'],
        description: householdDetailData?['description'],
        members: householdDetailData?['members'].cast<String>(),
        shoppingList: householdDetailData?['shoppingList'],
        taskList: householdDetailData?['taskList'],

      );
      /// Benachrichtige alle Listener, dass sich die Daten geändert haben
      notifyListeners();

      /// Wenn der Haushalt erfolgreich geladen wurde, dann true zurückgeben
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      /// Wenn der Haushalt nicht geladen werden konnte, dann false zurückgeben
      return false;
    }
  }

  /// Funktion die den Admin eines Haushalts ändert
  Future<bool> changeAdmin(String email) async {
    try {

      final docRefUser = await db.collection("users").where('email', isEqualTo: email).get();

      /// Überprüfen ob der Benutzer existiert
      if (docRefUser.docs.isEmpty) return false;

      /// Speichern der ID (uid) des Benutzers
      final userId = docRefUser.docs.first.id;

      await db.collection("households").doc(_household.id.toString()).update({
        'admin': userId,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die ein ShoppingItem zu einem Haushalt hinzufügt
  Future<bool> addShoppingItem(ShoppingItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> shoppingList = householdDetailData['shoppingList']?.cast<Map<String, dynamic>>() ?? [];
      shoppingList.add(item.toMap()); // Hier wird das ShoppingItem in ein Map-Objekt umgewandelt

      await db.collection("households").doc(_household.id.toString()).update({
        'shoppingList': shoppingList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Funktion die ein ShoppingItem aus einem Haushalt entfernt
  Future<bool> removeShoppingItem(String itemId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> shoppingList = householdDetailData['shoppingList']?.cast<Map<String, dynamic>>() ?? [];
      shoppingList.removeWhere((element) => element['id'] == itemId);

      await db.collection("households").doc(_household.id.toString()).update({
        'shoppingList': shoppingList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die ein ShoppingItem in einem Haushalt updatet
  Future<bool> updateShoppingItem(ShoppingItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> shoppingList = householdDetailData['shoppingList']?.cast<Map<String, dynamic>>() ?? [];
      shoppingList.removeWhere((element) => element['id'] == item.id);
      shoppingList.add(item.toMap());

      await db.collection("households").doc(_household.id.toString()).update({
        'shoppingList': shoppingList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die das 'erledigt' Feld eines ShoppingItems im Haushalt umschaltet
  Future<bool> toggleShoppingItemDoneStatus(String itemId, String userId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> shoppingList = householdDetailData['shoppingList']?.cast<Map<String, dynamic>>() ?? [];

      /// Entfernt das Item, um es im Anschluss zu updaten und wieder hinzuzufügen
      Map<String, dynamic> itemToUpdate = shoppingList.firstWhere((element) => element['id'] == itemId);
      shoppingList.removeWhere((element) => element['id'] == itemId);
      itemToUpdate['done'] = !itemToUpdate['done'];

      /// Fertigstellungs-Timestamp Updaten und ausführenden User setzen
      if (itemToUpdate['done']) {
        itemToUpdate['doneOn'] = DateTime.now().toString();
        itemToUpdate['doneBy'] = userId;
      } else if (!itemToUpdate['done']) {
        itemToUpdate['doneOn'] = null;
        itemToUpdate['doneBy'] = null;
      }
      shoppingList.add(itemToUpdate);

      await db.collection("households").doc(_household.id.toString()).update({
        'shoppingList': shoppingList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die das 'erledigt' Feld eines TaskItems im Haushalt umschaltet
  Future<bool> toggleTaskItemDoneStatus(String itemId, String userId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> taskList = householdDetailData['taskList']?.cast<Map<String, dynamic>>() ?? [];

      /// Entfernt das Item, um es im Anschluss zu updaten und wieder hinzuzufügen
      Map<String, dynamic> taskToUpdate = taskList.firstWhere((element) => element['id'] == itemId);
      taskList.removeWhere((element) => element['id'] == itemId);
      taskToUpdate['done'] = !taskToUpdate['done'];

      /// Fertigstellungs-Timestamp Updaten und ausführenden User setzen
      if (taskToUpdate['done']) {
        taskToUpdate['doneOn'] = DateTime.now().toString();
        taskToUpdate['doneBy'] = userId;
      } else if (!taskToUpdate['done']) {
        taskToUpdate['doneOn'] = null;
        taskToUpdate['doneBy'] = null;
      }
      taskList.add(taskToUpdate);

      await db.collection("households").doc(_household.id.toString()).update({
        'taskList': taskList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die alle erledigten ShoppingItems aus einem Haushalt entfernt und ihre/n Punkte/Preis auf das Konto der Person legt, die das Item als erledigt markiert hat.
  Future<bool> removeDoneShoppingItems() async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> shoppingList = householdDetailData['shoppingList']?.cast<Map<String, dynamic>>() ?? [];
      final Map<String, dynamic> scoreboard = householdDetailData['scoreboard'] ?? [];
      final Map<String, dynamic> expenses = householdDetailData['expenses'] ?? [];

      /// Erhöht Scoreboard Eintrag des Mitglieds um die Punkte des Items
      scoreboard.forEach((member, score) {
        for (var element in shoppingList) {
          if (element['done'] && element['doneBy'] == member) {
            score += element['points'] as int;
          }
        }
        scoreboard[member] = score;
      });

      /// Erhöht Ausgaben Kontostand des Mitglieds um den Preis des Items
      expenses.forEach((member, balance) {
        for (var element in shoppingList) {
          if (element['done'] && element['doneBy'] == member) {
            balance += element['price'] as double;
          }
        }
        expenses[member] = balance;
      });

      ///Entfernt das erledigte Item nach dem Auslesen der Punkte/des Preises
      shoppingList.removeWhere((element) => element['done'] == true);

      await db.collection("households").doc(_household.id.toString()).update({
        'shoppingList': shoppingList,
        'scoreboard' : scoreboard,
        'expenses' : expenses,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  /// Funktion die die Ausgaben eines Haushalts berechnet
  Future<Map<String, dynamic>> calculateMemberExpenses(String householdId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(householdId).get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
        final memberIds = householdDetailData['members'].cast<String>();
        final shoppingList = householdDetailData['shoppingList'].cast<Map<String, dynamic>>();

        final memberExpenses = <String, Map<String, dynamic>>{};
        double totalExpenses = 0.0;

        /// Berechnung der Gesamtsumme aller  Ausgaben
        /// Iteration für alle ShoppingItems
        for (final shoppingItem in shoppingList) {
          final price = shoppingItem['price'] as double;
          final done = shoppingItem['done'] as bool;

          /// Wenn das ShoppingItem erledigt ist, dann wird der Preis zu den Gesamtausgaben hinzugefügt
          if (done) {
            totalExpenses += price;
          }
        }

        /// Berechnung der Ausgaben für jedes Mitglied
        /// Iteration für alle Mitglieder
        for (final memberId in memberIds) {
          double memberExpense = 0.0;

          /// Iteration für alle ShoppingItems
          for (final shoppingItem in shoppingList) {
            final doneBy = shoppingItem['doneBy'] as String?;
            final price = shoppingItem['price'] as double;
            final done = shoppingItem['done'] as bool;

            /// Wenn das ShoppingItem erledigt ist und das Mitglied es erledigt hat, dann wird der Preis zu den Ausgaben des Mitglieds hinzugefügt
            if (done && doneBy == memberId) {
              memberExpense += price;
            }
          }

          /// Berechnung des prozentualen Anteils der Ausgaben eines Mitglieds an den Gesamtkosten
          double percentageOfTotal = 0.0;
          if (totalExpenses != 0.0) {
            percentageOfTotal = (memberExpense / totalExpenses) * 100;
          }

          final username = await getUsernameForUserId(memberId);
          memberExpenses[memberId] = {
            'username': username,
            'expense': memberExpense,
            'percentageOfTotal': percentageOfTotal,
          };
        }

        return memberExpenses;
      }

      return {};
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }


  /// Funktion die ein TaskItem zu einem Haushalt hinzufügt
  Future<bool> addTaskItem(TaskItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> taskList = householdDetailData['taskList']?.cast<Map<String, dynamic>>() ?? [];
      taskList.add(item.toMap());

      await db.collection("households").doc(_household.id.toString()).update({
        'taskList': taskList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Funktion die ein TaskItem aus einem Haushalt entfernt
  Future<bool> removeTaskItem(String itemId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> taskList = householdDetailData['taskList']?.cast<Map<String, dynamic>>() ?? [];
      taskList.removeWhere((element) => element['id'] == itemId);

      await db.collection("households").doc(_household.id.toString()).update({
        'taskList': taskList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die ein TaskItem in einem Haushalt updatet
  Future<bool> updateTaskItem(TaskItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> taskList = householdDetailData['taskList']?.cast<Map<String, dynamic>>() ?? [];
      taskList.removeWhere((element) => element['id'] == item.id);
      taskList.add(item.toMap());

      await db.collection("households").doc(_household.id.toString()).update({
        'taskList': taskList,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Funktion die alle erledigten TaskItems aus einem Haushalt entfernt und ihre Punkte auf das Konto der Person legt, die das Item als erledigt markiert hat.
  Future<bool> removeDoneTaskItems() async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> taskList = householdDetailData['taskList']?.cast<Map<String, dynamic>>() ?? [];
      final Map<String, dynamic> scoreboard = householdDetailData['scoreboard'] ?? [];

      /// Erhöht Scoreboard Eintrag des Mitglieds um die Punkte des Items
      scoreboard.forEach((member, score) {
        for (var element in taskList) {
          if (element['done'] && element['doneBy'] == member) {
            score += element['points'] as int;
          }
        }
        scoreboard[member] = score;
      });

      ///Entfernt das erledigte Item nach dem Auslesen der Punkte
      taskList.removeWhere((element) => element['done'] == true);

      await db.collection("households").doc(_household.id.toString()).update({
        'taskList': taskList,
        'scoreboard' : scoreboard,
      });

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  /// Funktion die die Punkte der Mitglieder eines Haushalts berechnet
  Future<Map<String, int>> getMemberPointsOverview(String householdId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(householdId).get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
        final members = householdDetailData['members'].cast<String>();

        final memberPoints = <String, int>{};

        /// Iteration für alle Mitglieder
        for (final memberUserId in members) {
          final username = await getUsernameForUserId(memberUserId);
          if (username != null) {
            int points = 0;

            /// Iteration für alle ShoppingItems und TaskItems
            final items = [
              ...householdDetailData['shoppingList'],
              ...householdDetailData['taskList']
            ];
            for (final itemData in items) {
              final doneBy = itemData['doneBy'] as String?;
              final isDone = itemData['done'] as bool? ?? false;
              final pointsEarned = itemData['points'] as int? ?? 0;

              if (doneBy == memberUserId && isDone) {
                points += pointsEarned;
              }
            }
            /// Punkte für das aktuelle Mitglied im Haushalt speichern
            memberPoints[username] = points;
          }
        }

        /// sortedMemberPoints speichert die Map sortiert nach den Punkten, die Person mit der Höchsten Punktzahl steht an erster Stelle
        final sortedMemberPoints = Map<String, int>.fromEntries(
            memberPoints.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value))
        );

        return sortedMemberPoints;
      }

      return {};
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }
}