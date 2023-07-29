import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';

@RoutePage()
class HouseHoldDetailScreen extends StatefulWidget {
  const HouseHoldDetailScreen({super.key, @PathParam('id') required this.id });
  final int id;

  @override
  State<HouseHoldDetailScreen> createState() => _HouseHoldDetailScreenState();
}

class _HouseHoldDetailScreenState extends State<HouseHoldDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: Center(
        child: Column(
          children: [
            const H1(text: 'Haushalt'),
            Text(TestData.houseHoldData[widget.id].title),
            Text(TestData.houseHoldData[widget.id].description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AutoRouter.of(context).push(const HomeRoute()); // Zurück zum HomeScreen
              },
              child: const Text('Zurück'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AutoRouter.of(context).push(HouseHoldEditRoute(id: widget.id));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

}
