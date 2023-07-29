import 'dart:math';

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
            // Anzeige der Personen-Kreise
            if (TestData.houseHoldData[widget.id].members.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: TestData.houseHoldData[widget.id].members
                      .map((member) => _buildMemberCircle(member))
                      .toList(),
                ),
              ),

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

Widget _buildMemberCircle(String name) {
  Color circleColor = _getRandomColor();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
      ),
      child: Center(
        child: Text(
          name[0],
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Color _getRandomColor() {
  Random random = Random();
  int r = random.nextInt(256); // Zufälliger Rot-Wert (0-255)
  int g = random.nextInt(256); // Zufälliger Grün-Wert (0-255)
  int b = random.nextInt(256); // Zufälliger Blau-Wert (0-255)
  return Color.fromARGB(255, r, g, b); // ARGB-Format, Alpha auf 255 gesetzt (vollständig sichtbar)
}



