import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../routes/app_router.gr.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/fonts.dart';
import '../data/constants.dart';

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
                  return InkWell(
                    onTap: () {
                      // Route zur Detailseite des Haushalts
                      // ToDo change to dynamic Route
                      AutoRouter.of(context).push(HouseHoldDetailRoute(id: index));
                    },
                    child: SizedBox(
                      height: 200,
                      width: 300,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            H2(text: TestData.houseHoldData[index].title),
                            H3(text: TestData.houseHoldData[index].description),
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
            AutoRouter.of(context).push(const HouseHoldFormRoute());
          },
          child: const Icon(Icons.add),
        ),
    );
  }
}
