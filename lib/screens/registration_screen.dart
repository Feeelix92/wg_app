import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:wg_app/routes/app_router.gr.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';

import '../widgets/custom_snackbars.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>();

  void _initializeFormKey() {
    _formKeyRegister = GlobalKey<FormState>();
  }
  bool _isObscure = true;
  bool _isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();
  DateTime _selectedDate = DateTime.now();


  Future signUp() async {
    try {
      final authCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((value) async {
        await FirebaseAuth.instance.setLanguageCode("de");
        await value.user!.sendEmailVerification();
        sendUserDetails(value.user!.uid);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAwesomeSnackbar(context, 'Das Passwort ist zu schwach', Colors.red, Icons.close);
      } else if (e.code == 'email-already-in-use') {
        showAwesomeSnackbar(
            context, 'Zu dieser Email existiert bereits ein Account', Colors.red, Icons.close);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future sendUserDetails(String uid) async {
    final credentials = db.collection("users").doc(uid).set({
      'name': _nameController.text.trim(),
      'birthdate': _selectedDate.toString().trim(),
      'isAdmin': false,
    }).then((value) {
      FirebaseAuth.instance.signOut();
      setState(() => _isLoading = false);
      showAwesomeSnackbar(
          context, 'Registrieren erfolgreich\nBestätigen sie ihre Emailadresse', Colors.blue, Icons.email);
      AutoRouter.of(context).push(const VerifyEmailRoute());
      clearForm();
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('Ich bin hier');
        print(error);
      }
    });
  }

  void clearForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _passwordRepeatController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeFormKey();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 36),
          child: Column(
            children: [
              Form(
                key: _formKeyRegister,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        helperText: 'Kompletten Name eingeben',
                        prefixIcon: const Icon(Icons.account_circle),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (name) {
                        if (name!.isEmpty) return 'Gib dein Passwort ein';
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      autofocus: false,
                      readOnly: true,
                      controller: TextEditingController(
                          text: DateFormat('dd.MM.yyyy').format(_selectedDate)),
                      decoration: InputDecoration(
                        labelText: 'Geburtsdatum',
                        helperText: 'Geburtsdatum auswählen',
                        prefixIcon: const Icon(Icons.date_range),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
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
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: _passwordRepeatController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'Passwort bestätigen',
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
                        if (password != _passwordController.text) return 'Das Passwort stimmt nicht überein';
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16, left: 16, top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SpinKitFadingCircle(
                            color: _isLoading ? Colors.green : Colors.transparent,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKeyRegister.currentState!.validate()) {
                                setState(() => _isLoading = true);
                                signUp();
                              }
                            },
                            child: const Text('Registrieren'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
