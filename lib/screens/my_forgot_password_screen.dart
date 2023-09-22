import 'dart:async';
import 'package:auto_route/annotations.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_snackbars.dart';

/// Initialisierung des FormKeys für das Absenden des Passwort vergessen Formulars
final _formKeyForgotPassword = GlobalKey<FormState>();

/// {@category Screens}
/// Passwort vergessen Screen
@RoutePage()
class MyForgotPasswordScreen extends StatefulWidget {
  const MyForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<MyForgotPasswordScreen> createState() => _MyForgotPasswordScreenState();
}

class _MyForgotPasswordScreenState extends State<MyForgotPasswordScreen> {

  /// Controller für die Eingabe der Email
  final TextEditingController _emailController = TextEditingController(text: '');

  bool _canResendEmail = true;

  final AppBar _appBar = AppBar(
    title: const Text('Passwort vergessen'),
  );

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height - (_appBar.preferredSize.height * 1.7);
    final double screenWidth = MediaQuery.of(context).size.width;

    final FirebaseAuth auth = FirebaseAuth.instance;

    Future resetPassword() async {

      setState(() => _canResendEmail = false);


      try {
        final credentials = await auth.sendPasswordResetEmail(email: _emailController.text.trim()).then(
              (value) {

                showAwesomeSnackbar(context, 'Email gesendet', Colors.green, Icons.check);

                Timer(const Duration(seconds: 10), () {
                  setState(() => _canResendEmail = true);
                });
              },
            );
      } on FirebaseAuthException catch (err) {
        showAwesomeSnackbar(context, err.code, Colors.red, Icons.close);
        setState(() => _canResendEmail = true);
        if (kDebugMode) {
          print('Fehler Password Reset');
          print(err.code);
        }
      }
    }

    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Emailadresse deines Accounts',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 18,
                ),
                Form(
                  key: _formKeyForgotPassword,
                  child: TextFormField(
                    //autofocus: true,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      helperText: 'Email zum Zurücksetzten',
                      prefixIcon: const Icon(Icons.password_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (email) => !EmailValidator.validate(email!) ? 'Gib eine valide Email ein' : null,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canResendEmail ? null : Colors.grey[100],
                    foregroundColor: _canResendEmail ? null : Colors.black,
                  ),
                  onPressed: () => _formKeyForgotPassword.currentState!.validate() && _canResendEmail
                      ? resetPassword()
                      : null,
                  child: const Text('Passwort zurücksetzten'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
