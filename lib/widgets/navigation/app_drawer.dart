import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../routes/app_router.gr.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
                            AutoRouter.of(context).pop();
                          },
                          child: const Text('Abbrechen')),
                      TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            AutoRouter.of(context).popUntilRoot();
                            AutoRouter.of(context).replace(const LoginRoute());
                          },
                          child: const Text('Abmelden')),
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
