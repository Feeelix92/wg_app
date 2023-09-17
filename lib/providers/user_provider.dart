import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late UserModel _user;
  UserModel get user => _user;

  bool _userIsSet = false;
  bool get userIsSet => _userIsSet;

  late DocumentSnapshot snap;

  Future updateUserInformation() async {
    try {
      final docRefUser = db.collection("users").doc(auth.currentUser!.uid);

      await docRefUser.get().then((DocumentSnapshot doc) {
        snap = doc;

        final userDetailData = doc.data() as Map<String, dynamic>;

        _user = UserModel(
            firstName: userDetailData['name'],
            lastName: userDetailData['name'],
            uid: auth.currentUser!.uid,
            email: auth.currentUser!.email as String,
            birthdate: userDetailData['birthdate'],
            username: userDetailData['username']);
      });

      _userIsSet = true;

      if (kDebugMode) {
        print('Aktueller User: ');
        print(user.toString());
      }

      notifyListeners();

      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }


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

}
