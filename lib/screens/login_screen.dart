import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wg_app/routes/app_router.gr.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';

import '../widgets/custom_snackbars.dart';

/// {@category Screens}
/// Login Screen
@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

  /// Initialisierung des FormKeys für das Absenden des Login Formulars
  void _initializeFormKey() {
    _formKeyLogin = GlobalKey<FormState>();
  }

  /// Anzeige des Passwortes
  bool _isObscure = true;

  /// Anzeige des Ladekreises
  bool _isLoading = false;

  /// Controller für die Eingabe der Email
  final TextEditingController _emailController = TextEditingController(text: '');

  /// Controller für die Eingabe des Passwortes
  final TextEditingController _passwordController = TextEditingController(text: '');

  /// Login mit Email und Passwort
  Future _signIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });

      /// Prüfen ob die Email-Adresse verifiziert wurde
      if (userCredential.user!.emailVerified) {
        AutoRouter.of(context).replace(const HomeRoute());
      } else {
        AutoRouter.of(context).replace(const VerifyEmailRoute());
      }

      AutoRouter.of(context).popUntilRoot();
    } on FirebaseAuthException catch (e) {

      setState(() {
        _isLoading = false;
      });

      /// Fehlermeldungen anzeigen wenn der Login fehlschlägt
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
        showAwesomeSnackbar(context, 'Kein Benutzer gefunden', Colors.red, Icons.close);
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        showAwesomeSnackbar(context, 'Falsches Passwort', Colors.red, Icons.close);
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _initializeFormKey();

    /// Setzen der Orientierung auf Portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 22),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 80),
              child: const Text('Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: _formKeyLogin,
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: false,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            helperText: 'E-Mail Adresse eingeben',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (email) =>
                              !EmailValidator.validate(email!) ? 'Gib eine valide Email ein' : null,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        TextFormField(
                          autofocus: false,
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            labelText: 'Passwort',
                            helperText: 'Passwort eingeben',
                            prefixIcon: const Icon(Icons.password_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (password) {
                            if (password!.isEmpty) return 'Gib dein Passwort ein';
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                   AutoRouter.of(context).push(const MyForgotPasswordRoute());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black12, foregroundColor: Colors.black54),
                                  child: const Text('Passwort vergessen')),
                              ElevatedButton(
                                onPressed: _isLoading ? null : () {
                                  if (_formKeyLogin.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    _signIn(context);
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitFadingCircle(
                                color: _isLoading ? Colors.green : Colors.transparent,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Noch keine Account? '),
                      InkWell(
                        child: const Text(
                          'Registrieren',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onTap: () {
                         AutoRouter.of(context).push(const RegistrationRoute());
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
