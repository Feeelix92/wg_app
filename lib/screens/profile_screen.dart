import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_input_decoration.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';

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

  /// Controller für die Eingabe des Namens
  final TextEditingController _nameController = TextEditingController(text: '');

  /// Controller für die Eingabe der Email
  final TextEditingController _emailController = TextEditingController(text: '');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 42),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Form(
            key: _profileFormKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autofocus: false,
                  controller: _nameController,
                  decoration: materialInputDecoration('Name', null, Icons.person),
                  onChanged: (value) {
                    setState(() => _userDataIsChanged = true);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autofocus: false,
                  controller: _emailController,
                  decoration: materialInputDecoration('Email', null, Icons.email),
                  onChanged: (value) {
                    setState(() => _userDataIsChanged = true);
                  },
                ),
                const SizedBox(height: 84),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _userDataIsChanged
            ? FloatingActionButton.extended(
                onPressed: () {},
                label: const Text('Speichern'),
                icon: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }
}
