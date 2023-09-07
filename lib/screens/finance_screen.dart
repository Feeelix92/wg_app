import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';
import '../providers/household_provider.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/text/h1.dart';

@RoutePage()
class FinanceScreen extends StatefulWidget {
  const FinanceScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(builder: (context, householdProvider, child) {
      return const Scaffold(
        appBar: CustomAppBar(),
        endDrawer: AppDrawer(),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: H1(text: 'Finanzen'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
