import 'package:auto_route/auto_route.dart';
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
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Home'),
            onTap: () {
              AutoRouter.of(context).push(const HomeRoute());
            },
          ),
        ],
      ),
    );
  }
}
