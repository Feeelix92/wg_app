import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      endDrawer: AppDrawer(),
      body: Center(
        child: Column(
          children: [
            H1(text: 'Willkommen auf der Hauptseite!'),
            CustomText(text: 'Hier können Sie sich durch die App navigieren.'),
            CustomText(text: 'Viel Spaß!'),
          ],
        ),
      ),
    );
  }
}