import 'package:auto_route/annotations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_input_decoration.dart';
import '../widgets/custom_snackbars.dart';

/// Erstelle einen GLoablKey für das Form Widget
final _profileFormKey = GlobalKey<FormState>();

/// {@category Screens}
/// Ansicht für das Profil des angemeldeten Benutzers
@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  /// Speichert ob sich die Benutzerdaten geändert haben
  bool _userDataIsChanged = false;

  /// Gibt an ob die Daten gerade an Firebase gesendet werden. Wenn ja wird der Button zum Speichern deaktiviert
  bool _isSendingToFirebase = false;


  /// Controller für die Eingabe des Namens
  final TextEditingController _usernameController = TextEditingController(text: '');

  /// Controller für die Eingabe des Vornamens
  final TextEditingController _firstNameController = TextEditingController(text: '');

  /// Controller für die Eingabe des Nachnamens
  final TextEditingController _lastNameController = TextEditingController(text: '');

  /// Controller für die Eingabe der Email
  final TextEditingController _emailController = TextEditingController(text: '');

  /// Controller für die Eingabe des Geburtsdatums
  final TextEditingController _birthdateController = TextEditingController(text: '');

  /// Überprüft, ob die Benutzerdaten geändert wurden.
  ///
  /// Diese Methode vergleicht die aktuellen Werte der Textfelder mit den Werten des aktuellen Benutzers.
  /// Wenn eine Änderung erkannt wird, wird `_userDataIsChanged` auf `true` gesetzt, ansonsten bleibt es `false`.
  void checkForChange() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel user = userProvider.user;

    if (_usernameController.text.trim() == user.username &&
        _firstNameController.text.trim() == user.firstName &&
        _lastNameController.text.trim() == user.lastName &&
        _emailController.text.trim() == user.email &&
        _birthdateController.text.trim() == user.birthdate) {
      setState(() => _userDataIsChanged = false);
    } else {
      setState(() => _userDataIsChanged = true);
    }
  }

  /// Initialisiert die Textfelder mit den aktuellen Benutzerdaten.
  ///
  /// Diese Methode holt den aktuellen Benutzer vom `UserProvider` und setzt die Werte der Textfelder auf die Werte des Benutzers.
  void initialiseValues() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.updateUserInformation();

    print("Before User is set: ${userProvider.user}");

    if (userProvider.userIsSet) {

      print("After User is set: ${userProvider.userIsSet}");

      final UserModel user = userProvider.user;

      setState(() {
        _usernameController.text = user.username;
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _emailController.text = user.email;
        _birthdateController.text = user.birthdate;
      });
    }
  }


  /// Listener für den `UserProvider`.
  ///
  /// Diese Methode wird aufgerufen, wenn sich die Benutzerdaten im `UserProvider` ändern.
  /// Sie ruft `initialiseValues` und `checkForChange` auf, um die Textfelder zu initialisieren und zu überprüfen, ob die Benutzerdaten geändert wurden.
  void userProviderListener() {
    initialiseValues();
    checkForChange();
  }

  /// Initialisiert den Zustand des Widgets.
  ///
  /// Diese Methode wird aufgerufen, wenn das Widget erstellt wird.
  /// Sie fügt den `userProviderListener` als Listener zum `UserProvider` hinzu und initialisiert die Textfelder mit den aktuellen Benutzerdaten.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialiseValues());

    context.read<UserProvider>().addListener(userProviderListener);
  }

  /// Bereinigt den Zustand des Widgets.
  ///
  /// Diese Methode wird aufgerufen, wenn das Widget entfernt wird.
  /// Sie entfernt den `userProviderListener` als Listener vom `UserProvider`.
  @override
  void dispose() {
    super.dispose();

    context.read<UserProvider>().removeListener(userProviderListener);
  }



  @override
  Widget build(BuildContext context) {

    /// Speichert die Änderungen des Benutzerprofils.
    ///
    /// Diese Methode aktualisiert die Benutzerinformationen in der Firestore-Datenbank und im `UserProvider`.
    /// Nachdem die Informationen aktualisiert wurden, wird `checkForChange` aufgerufen, um zu überprüfen, ob die Benutzerdaten geändert wurden.
    /// Wenn die Daten erfolgreich gespeichert wurden, wird eine Snackbar mit einer Erfolgsmeldung angezeigt.
    Future saveProfileChanges() async {
      // Absicherung das die Funktion wirklich nicht zwei mal ausgeführt wird
      if (_isSendingToFirebase) return;

      if (_profileFormKey.currentState!.validate()) {
        setState(() => _isSendingToFirebase = true);

        try {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          final docRefUser = userProvider.db.collection("users").doc(userProvider.user.uid);

          await docRefUser.update({
            'username': _usernameController.text.trim(),
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'birthdate': _birthdateController.text.trim(),
          });

          await userProvider.updateUserInformation();

          setState(() {
            _isSendingToFirebase = false;
          });

          checkForChange();

          showAwesomeSnackbar(context, 'Speichern erfolgreich', Colors.green, Icons.check);

        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 64),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Form(
                  key: _profileFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: materialInputDecoration('Username', null, Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        onChanged: (_) => checkForChange(),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: materialInputDecoration('First Name', null, Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onChanged: (_) => checkForChange(),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: materialInputDecoration('Last Name', null, Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onChanged: (_) => checkForChange(),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: materialInputDecoration('Email', null, Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (_) => checkForChange(),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextFormField(
                        autofocus: false,
                        readOnly: true,
                        controller: _birthdateController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: materialInputDecoration('Geburtsdatum', null, Icons.date_range),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your birthdate';
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              locale: const Locale('de', 'DE'),
                              initialDate: _birthdateController.text.isNotEmpty
                                  ? DateTime(
                                  int.parse(_birthdateController.text.substring(6)),
                                  int.parse(_birthdateController.text.substring(3, 5)),
                                  int.parse(_birthdateController.text.substring(0, 2)))
                                  : DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd-MM-yyy').format(pickedDate);
                            setState(() {
                              _birthdateController.text = formattedDate;
                              checkForChange();
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        height: 28,
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        //visible: _userDataIsChanged,
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            ScaleTransition(scale: animation, child: child),
        child: _userDataIsChanged
            ? FloatingActionButton.extended(
          onPressed: _isSendingToFirebase ? null : () => saveProfileChanges(),
          label: const Text('Speichern'),
          icon: const Icon(Icons.save),
        )
            : null,
      ),
    );
  }
}
