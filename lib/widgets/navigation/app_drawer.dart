import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../routes/app_router.gr.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
    // Get user details before launching the app
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateUserInformation();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text('Drawer Header'),
          ),
           ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              AutoRouter.of(context).push(const ProfileRoute());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Abmelden'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Abmelden'),
                    content: const Text('Möchten Sie sich wirklich abmelden?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            AutoRouter.of(context).popUntilRoot();
                            AutoRouter.of(context).replace(const LoginRoute());
                          },
                          child: const Text('Abmelden')),
                      TextButton(
                          onPressed: () {
                            AutoRouter.of(context).pop();
                          },
                          child: const Text('Abbrechen')),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
