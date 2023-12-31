import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wg_app/main.dart';
import 'package:wg_app/routes/app_router.gr.dart';

/// {@category Screens}
/// Ansicht für die Verifizierung der Email-Adresse
@RoutePage()
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

/// State für den [VerifyEmailScreen]
class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  bool _isEmailVerified = false;
  bool _canResendEmail = true;

  Timer? timer;



  @override
  void initState() {
    super.initState();

    /// Speichert den aktuell angemeldeten Benutzer
    final user = FirebaseAuth.instance.currentUser;

    /// Prüft ob der Benutzer existiert
    if (user != null) {
      _isEmailVerified = user.emailVerified;

      if (!_isEmailVerified) {
        sendVerificationEmail();
      }

      /// Prüft alle 3 Sekunden ob die Email-Adresse verifiziert wurde
      timer = Timer.periodic(const Duration(seconds: 3), (timer) => checkEmailVerified());
    }
  }

  /// sendVerificationEmail sendet eine Email an den Benutzer zur Verifizierung
  Future sendVerificationEmail() async {

    /// Speichert den aktuell angemeldeten Benutzer
    final user = FirebaseAuth.instance.currentUser;

    try {
      await user!.sendEmailVerification();

      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 10));
      setState(() => _canResendEmail = true);

    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  /// checkEmailVerified prüft ob die Email-Adresse verifiziert wurde
  Future checkEmailVerified() async {

    /// Aktualisiert den Benutzer
    await FirebaseAuth.instance.currentUser!.reload();

    /// Prüft ob die Email-Adresse verifiziert wurde
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    /// Wenn die Email-Adresse verifiziert wurde, wird der Benutzer zur Startseite weitergeleitet
    if (_isEmailVerified) {
      timer?.cancel();
      AutoRouter.of(context).replace(const HomeRoute());
    }

  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _isEmailVerified
      ? MyApp()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Email Verifizierung'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitPouringHourGlassRefined(
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                'Bitte bestätige deine Email',
                style: TextStyle(fontSize: 26),
              ),
              const Text('Schaue auch in deinem Spam-Ordner nach'),
              const SizedBox(
                height: 36,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Abbrechen'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _canResendEmail ? sendVerificationEmail() : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canResendEmail ? null : Colors.grey[100],
                      foregroundColor: _canResendEmail ? null : Colors.black,
                    ),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Email erneut senden'),
                  ),
                ],
              ),
            ],
          ),
        );
}
