import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/providers/household_provider.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';
import 'household_create_screen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, houseHoldData, child) {
      houseHoldData.loadAllAccessibleHouseholds();
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
                  itemCount: houseHoldData.accessibleHouseholds.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        AutoRouter.of(context).push(HouseHoldDetailRoute(householdId: index));
                      },
                      child: SizedBox(
                        height: 200,
                        width: 300,
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              H2(text: houseHoldData.accessibleHouseholds[index].title), // Verwende die Liste von houseHoldData
                              H3(text: houseHoldData.accessibleHouseholds[index].description), // Verwende die Liste von houseHoldData
                            ],
                          ),
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
            showModalBottomSheet(
              context: context,
              builder: (context) => const SingleChildScrollView(
                  child: HouseHoldCreateScreen()
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
