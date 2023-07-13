import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wg_app/model/household.dart';

import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';

// @Todo: Remove this dummy data and replace with Firebase data
class TestData {
  static List<Household> houseHoldData = [
    Household(
      title: 'WG-Name',
      description: 'WG-Beschreibung',
    ),
  ];
}

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: Center(
        child: Column(
          children: [
            const H1(text: 'Haushalt'),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: TestData.houseHoldData.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 200,
                    width: 300,
                    child: Card(
                      child: Column(
                        children: [
                          Text(TestData.houseHoldData[index].title),
                          Text(TestData.houseHoldData[index].description),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AutoRouter.of(context).push(const HouseHoldFormRoute());
          },
          child: const Icon(Icons.add),
        ),
    );
  }
}
