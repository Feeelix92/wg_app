import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:wg_app/model/household.dart';
import 'package:wg_app/model/shopping_item.dart';

import '../model/task_Item.dart';

class HouseholdProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late Household _household;

  Household get household => _household;

  late List<Household> _accessibleHouseholds = [];

  List<Household> get accessibleHouseholds => _accessibleHouseholds;


  // Funktion die den aktuellen Haushalt updatet
  Future updateHouseholdInformation() async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      _household = Household(
        admin: householdDetailData['admin'],
        id: _household.id,
        title: householdDetailData['title'],
        description: householdDetailData['description'],
        members: householdDetailData['members'].cast<String>(),
        shoppingList: householdDetailData['shoppingList'].cast<String>(),
        taskList: householdDetailData['taskList'].cast<String>(),
      );

      notifyListeners();

      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> createHousehold(String title, String description) async {
    try {
      final docRefHousehold = await db.collection("households").add({
        'title': title,
        'description': description,
        'admin': auth.currentUser!.uid,
        'members': [auth.currentUser!.uid],
        'shoppingList': [],
        'taskList': [],
      });

      // Damit die ID des Haushalts für die Methode updateHouseholdInformation() verfügbar ist
      _household = Household(
        admin: auth.currentUser!.uid,
        id: docRefHousehold.id,
        title: title,
        description: description,
        members: [auth.currentUser!.uid],
        shoppingList: [],
        taskList: [],
      );

      await updateHouseholdInformation();
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Funktion die die Daten eines Haushalts in der Datenbank aktualisiert
  Future<bool> updateHouseholdInfo(String title, String description) async {
    try {
      await db.collection("households").doc(_household.id).update({
        'title': title,
        'description': description,
      });

      // Nach dem Aktualisieren der Daten in Firebase die lokale Kopie aktualisieren
      _household.title = title;
      _household.description = description;

      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteHousehold(String householdId) async {
    try {
      // LÖschen der Shopping- und Task-Liste des Haushalts
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

      // Löschen des Haushalts
      await db.collection("households").doc(householdId).delete();
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Funktion die die Daten aller Mitglieder eines Haushalts lädt
  Future<Map<String, Map<String, dynamic>>> getHouseholdMembersData(String householdId) async {
    try {
      final docRefHousehold = await db.collection("households")
          .doc(householdId)
          .get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<
            String,
            dynamic>;
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


  // Funktion gibt eine Liste aller User die nciht in einem bestimtmen Haushalt Mitglied sind zurück
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
      return {}; // Wenn ein Fehler auftritt oder keine Benutzer vorhanden sind.
    }
  }

  // Funktion prüft ob ein User Mitglied in einem bestimmten Haushalt ist
  Future<bool> isUserInHousehold(String householdId, String userId) async {
    try {
      final docRefHousehold = await db.collection("households")
          .doc(householdId)
          .get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<
            String,
            dynamic>;
        final memberIds = householdDetailData['members'].cast<String>();

        return memberIds.contains(userId);
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false; // Wenn ein Fehler auftritt oder der Haushalt nicht gefunden wird.
    }
  }
 // Funktion die den Username mithilfe der UserId herausfindet
  Future<String?> getUsernameForUserId(String userId) async {
    try {
      final docRefUser = await db.collection("users").doc(userId).get();

      if (docRefUser.exists) {
        final userData = docRefUser.data() as Map<String, dynamic>;
        return userData['username'] as String?;
      }
      return null; // Benutzer nicht gefunden
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null; // Fehler beim Abrufen der Benutzerdaten
    }
  }


  // Funktion die den Username mithilfe der Email herausfindet
  Future<String?> getUsernameFromEmail(String email) async {
    try {
      final usersCollection = db.collection("users");
      final querySnapshot = await usersCollection.where(
          'email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final username = userData['username'] as String?;
        return username;
      } else {
        return null; // Wenn die E-Mail-Adresse nicht gefunden wurde.
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null; // Wenn ein Fehler auftritt.
    }
  }

  // Funktion die die Email mithilfe des Usernamen herausfindet
  Future<String?> getEmailFromUsername(String username) async {
    try {
      final usersCollection = db.collection("users");
      final querySnapshot = await usersCollection.where(
          'username', isEqualTo: username).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final email = userData['email'] as String?;
        return email;
      } else {
        return null; // Wenn der Username nicht gefunden wurde.
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null; // Wenn ein Fehler auftritt.
    }
  }


// Suche nach User in der Datenbank anhand der Email und füge ihn dem Haushalt hinzu
  Future<bool> addUserToHousehold(String email) async {
    try {
      final docRefUser = await db.collection("users").where(
          'email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty){
        return false;
      }

      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final userId = docRefUser.docs.first.id; // Abrufen der ID (uid) des Benutzers

      final List<String> members = householdDetailData['members'].cast<String>();
      members.add(userId);

      await db.collection("households").doc(_household.id.toString()).update({
        'members': members,
      });

      //@TODO: Ist User bereits in Household?

      await updateHouseholdInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Funktion die einen User anhand der Email aus einem Haushalt entfernt
  Future<bool> removeUserFromHousehold(String email) async {
    try {
      final docRefUser = await db.collection("users").where(
          'email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty) return false;

      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final userDetailData = docRefUser.docs.first.data();
      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      final userId = docRefUser.docs.first.id; // Abrufen der ID (uid) des Benutzers

      final List<String> members = householdDetailData['members'].cast<
          String>();
      members.remove(userId);

      await db.collection("households").doc(_household.id.toString()).update({
        'members': members,
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

  // Funktion die alle Haushalte eines Users lädt
  Future<bool> loadAllAccessibleHouseholds() async {
    print("loadAllAccessibleHouseholds from Firebase");
    try {
      final querySnapshot = await db.collection("households").where(
          "members", arrayContains: auth.currentUser!.uid).get();
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
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Funktion die einen Haushalt anhand der ID lädt
  Future<bool> loadHousehold(String id) async {
    print("loadHousehold from Firebase");
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
      notifyListeners();

      // Wenn der Haushalt erfolgreich geladen wurde, dann true zurückgeben
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // Wenn der Haushalt nicht geladen werden konnte, dann false zurückgeben
      return false;
    }
  }

  // Funktion die den admin eines Haushalts ändert
  Future<bool> changeAdmin(String email) async {
    try {
      final docRefUser = await db.collection("users").where(
          'email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty) return false;
      final userDetailData = docRefUser.docs.first.data();

      await db.collection("households").doc(_household.id.toString()).update({
        'admin': userDetailData['uid'],
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

  // Funktion die ein ShoppingItem zu einem Haushalt hinzufügt
  Future<bool> addShoppingItem(ShoppingItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      final List<
          ShoppingItem> shoppingList = householdDetailData['shoppingList'].cast<
          ShoppingItem>();
      shoppingList.add(item);

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
  Future<bool> removeShoppingItem(ShoppingItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      final List<
          ShoppingItem> shoppingList = householdDetailData['shoppingList'].cast<
          ShoppingItem>();
      shoppingList.remove(item);

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

  // Funktion die ein ShoppingItem in einem Haushalt updatet
  Future<bool> updateShoppingItem(ShoppingItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      final List<
          ShoppingItem> shoppingList = householdDetailData['shoppingList'].cast<
          ShoppingItem>();
      shoppingList.removeWhere((element) => element.id == item.id);
      shoppingList.add(item);

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

  // Funktion die alle erledigten ShoppingItems aus einem Haushalt entfernt
  Future<bool> removeDoneShoppingItems() async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      List<ShoppingItem> shoppingList = householdDetailData['shoppingList']
          .cast<ShoppingItem>();
      shoppingList.removeWhere((element) => element.done == true);

      await db.collection("households").doc(_household.id.toString()).update({
        'shoppingList': shoppingList,
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

  // Funktion die die Ausgaben eines Haushalts berechnet
  Future<Map<String, dynamic>> calculateMemberExpenses(
      String householdId) async {
    try {
      final docRefHousehold = await db.collection("households")
          .doc(householdId)
          .get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
        final memberIds = householdDetailData['members'].cast<String>();
        final shoppingList = householdDetailData['shoppingList'].cast<Map<String, dynamic>>();

        final memberExpenses = <String, Map<String, dynamic>>{};
        double totalExpenses = 0.0;

        // Berechnung der Gesamtsumme aller  Ausgaben
        for (final shoppingItem in shoppingList) {
          final price = shoppingItem['price'] as double;
          final done = shoppingItem['done'] as bool;

          if (done) {
            totalExpenses += price;
          }
        }

        for (final memberId in memberIds) {
          double memberExpense = 0.0;

          for (final shoppingItem in shoppingList) {
            final doneBy = shoppingItem['doneBy'] as String?;
            final price = shoppingItem['price'] as double;
            final done = shoppingItem['done'] as bool;

            if (done && doneBy == memberId) {
              memberExpense += price;
            }
          }

          // Berechnung des prozentualen Anteils der Ausgaben eines Mitglieds an den Gesamtkosten
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


  // Funktion die ein TaskItem zu einem Haushalt hinzufügt
  Future<bool> addTaskItem(TaskItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      final List<TaskItem> taskList = householdDetailData['taskList'].cast<
          TaskItem>();
      taskList.add(item);

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
  Future<bool> removeTaskItem(TaskItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      final List<TaskItem> taskList = householdDetailData['taskList'].cast<
          TaskItem>();
      taskList.remove(item);

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

  // Funktion die ein TaskItem in einem Haushalt updatet
  Future<bool> updateTaskItem(TaskItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      final List<TaskItem> taskList = householdDetailData['taskList'].cast<
          TaskItem>();
      taskList.removeWhere((element) => element.id == item.id);
      taskList.add(item);

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

  // Funktion die alle erledigten TaskItems aus einem Haushalt entfernt
  Future<bool> removeDoneTaskItems() async {
    try {
      final docRefHousehold = await db.collection("households").doc(
          _household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String,
          dynamic>;

      List<TaskItem> taskList = householdDetailData['taskList'].cast<
          TaskItem>();
      taskList.removeWhere((element) => element.done == true);

      await db.collection("households").doc(_household.id.toString()).update({
        'taskList': taskList,
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

  // Funktion die die Punkte der Mitglieder eines Haushalts berechnet
  Future<Map<String, int>> getMemberPointsOverview(String householdId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(householdId).get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
        final members = householdDetailData['members'].cast<String>();

        final memberPoints = <String, int>{};

        // Iteration für alle Mitglieder
        for (final memberUserId in members) {
          final username = await getUsernameForUserId(memberUserId);
          if (username != null) {
            int points = 0;

            // Iteration für alle ShoppingItems und TaskItems
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
            // Punkte für die Mitglieder im Haushalt speichern
            memberPoints[username] = points;
          }
        }

        // Jetzt die Punkte absteigend sortieren
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