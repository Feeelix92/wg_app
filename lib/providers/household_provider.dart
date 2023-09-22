import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:wg_app/model/household.dart';
import 'package:wg_app/model/shoppingItem.dart';

import '../model/TaskItem.dart';

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
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      _household = Household(
        admin: householdDetailData['admin'],
        id: _household.id,
        title: householdDetailData['title'],
        description: householdDetailData['description'],
        members: householdDetailData['members'].cast<String>(),
        shoppingList: householdDetailData['shoppingList'].cast<Map<String, dynamic>>(),
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
        db.collection("households").doc(householdId).collection("shoppingList").get().then((querySnapshot) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        }),
        db.collection("households").doc(householdId).collection("taskList").get().then((querySnapshot) {
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

  // Funktion die die Namen aller Mitglieder eines Haushalts lädt
  Future<List<String>> getHouseholdMembersNames(String householdId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(householdId).get();

      if (docRefHousehold.exists) {
        final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;
        final memberIds = householdDetailData['members'].cast<String>();

        final memberNames = <String>[];

        for (final memberId in memberIds) {
          final docRefUser = await db.collection("users").doc(memberId).get();
          if (docRefUser.exists) {
            final userData = docRefUser.data() as Map<String, dynamic>;
            final memberName = userData['username'];
            if(memberName != null) {
              memberNames.add(memberName);
            }
          }
        }
        return memberNames;
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }



// Suche nach User in der Datenbank anhand der Email und füge ihn dem Haushalt hinzu
  Future<bool> addUserToHousehold(String email) async {
    try {
      final docRefUser = await db.collection("users").where('email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty) return false;

      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final userDetailData = docRefUser.docs.first.data();
      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<String> members = householdDetailData['members'].cast<String>();
      members.add(userDetailData['uid']);

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

  // Funktion die einen User anhand der Email aus einem Haushalt entfernt
  Future<bool> removeUserFromHousehold(String email) async {
    try {
      final docRefUser = await db.collection("users").where('email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty) return false;

      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final userDetailData = docRefUser.docs.first.data();
      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<String> members = householdDetailData['members'].cast<String>();
      members.remove(userDetailData['uid']);

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
      final docRefUser = await db.collection("users").where('email', isEqualTo: email).get();

      if (docRefUser.docs.isEmpty) return false;

      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

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

  // Funktion die ein ShoppingItem in einem Haushalt updatet
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

  // Funktion die ein ShoppingItem in einem Haushalt updatet
  Future<bool> toggleShoppingItemDoneStatus(String itemId) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> shoppingList = householdDetailData['shoppingList']?.cast<Map<String, dynamic>>() ?? [];
      Map<String, dynamic> itemToUpdate = shoppingList.firstWhere((element) => element['id'] == itemId);
      shoppingList.removeWhere((element) => element['id'] == itemId);
      itemToUpdate['done'] = !itemToUpdate['done'];
      //Fertigstellungs-Timestamp Updaten
      if (itemToUpdate['done']) {
        itemToUpdate['doneOn'] = DateTime.now().toString();
      } else if (!itemToUpdate['done']) {
        itemToUpdate['doneOn'] = null;
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

  // Funktion die alle erledigten ShoppingItems aus einem Haushalt entfernt
  Future<bool> removeDoneShoppingItems() async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<Map<String, dynamic>> shoppingList = householdDetailData['shoppingList']?.cast<Map<String, dynamic>>() ?? [];
      for (var element in shoppingList) {
        if(element['done']) {
          //hier punkte auszählen an leute
        }
      }

      shoppingList.removeWhere((element) => element['done'] == true);

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

  // Funktion die ein TaskItem zu einem Haushalt hinzufügt
  Future<bool> addTaskItem(TaskItem item) async {
    try {
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<TaskItem> taskList = householdDetailData['taskList'].cast<TaskItem>();
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
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<TaskItem> taskList = householdDetailData['taskList'].cast<TaskItem>();
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
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      final List<TaskItem> taskList = householdDetailData['taskList'].cast<TaskItem>();
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
      final docRefHousehold = await db.collection("households").doc(_household.id.toString()).get();

      final householdDetailData = docRefHousehold.data() as Map<String, dynamic>;

      List<TaskItem> taskList = householdDetailData['taskList'].cast<TaskItem>();
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

}