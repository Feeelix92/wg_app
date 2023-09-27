import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/user_model.dart';

/// {@category Providers}
/// Die UserProvider Klasse verwaltet die Daten des Users, enthält einige Methoden für das Arbeiten mit diesen Daten.
class UserProvider extends ChangeNotifier {
  /// Die Instanzen der Firestore Datenbank
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Der aktuelle User
  late UserModel _user;
  UserModel get user => _user;

  /// Gibt an, ob der User bereits gesetzt wurde
  bool _userIsSet = false;
  bool get userIsSet => _userIsSet;

  late DocumentSnapshot snap;

  /// Updated die Daten des Users
  Future updateUserInformation() async {
    try {
      print(auth.currentUser!.uid);
      final docRefUser = db.collection("users").doc(auth.currentUser!.uid);

      print("1");

      await docRefUser.get().then((DocumentSnapshot doc) {
        snap = doc;

        print("2");

        final userDetailData = doc.data() as Map<String, dynamic>;

        print("3 ${userDetailData.toString()}");

        _user = UserModel(
            firstName: userDetailData['firstName'],
            lastName: userDetailData['lastName'],
            uid: auth.currentUser!.uid,
            email: auth.currentUser!.email as String,
            birthdate: userDetailData['birthdate'],
            username: userDetailData['username']);
      });

      print("Hallo");

      _userIsSet = true;

      if (kDebugMode) {
        print('Aktueller User: ');
        print(user.toString());
      }

      notifyListeners();

      return;
    } catch (e) {
      if (kDebugMode) {
        print("Hallo Fehler");
        print(e);
      }
    }
  }

  /// Mit der Methode changeEmail kann die Email für einen User geändert werden.
  Future<bool> changeEmail(String newEmail) async {
    try {
      await auth.currentUser!.updateEmail(newEmail);

      await updateUserInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  /// Mit der Methode changePassword kann das aktuelle Passwort für einen User geändert werden.
  Future<bool> changePassword(String newPassword) async {
    try {
      await auth.currentUser!.updatePassword(newPassword);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  /// Mit der Methode changeUsername kann der Username für einen User geändert werden.
  Future<bool> changeUsername(String newUsername) async {
    try {
      final docRefUser = db.collection("users").doc(_user.uid);

      await docRefUser.update({'username': newUsername});

      await updateUserInformation();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  /// Mit der Methode userStream wird ein Stream für den aktuellen User zurückgegeben, wodu die Daten des
  /// Users live abrufen werden können.
  // Stream<UserModel?> get userStream {
  //   return db
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .snapshots()
  //       .map((snapshot) => snapshot.data() != null ? UserModel.fromMap(snapshot.data()!) : null);
  // }



}
