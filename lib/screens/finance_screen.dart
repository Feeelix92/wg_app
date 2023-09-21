import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';
import '../providers/household_provider.dart';
import '../color_functions.dart';
import '../widgets/build_member_circle.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/text/h1.dart';

/// Der Finanzscreen zeigt Ausgaben der Mitglieder eines Haushalts an.
/// {@category Screens}
@RoutePage()
class FinanceScreen extends StatefulWidget {
  const FinanceScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  /// Die ID des Haushalts, dessen Ausgaben angezeigt werden sollen.
  final String householdId;

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HouseholdProvider>(
        builder: (context, householdProvider, child) {
      return Scaffold(
        appBar: const CustomAppBar(),
        endDrawer: const AppDrawer(),
        body: Center(
          child: Column(
            children: [
              const H1(text: 'Ausgaben'),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 20,
                  child: AspectRatio(
                    aspectRatio: 10,
                    child: FutureBuilder(
                      future: householdProvider
                          .calculateMemberExpenses(widget.householdId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            (snapshot.data as Map<String, dynamic>).isEmpty) {
                          return const Center(
                              child: Text('Keine Daten verfügbar'));
                        } else if (!snapshot.hasData ||
                            (snapshot.data as Map<String, dynamic>)
                                .values
                                .every((value) => value['expense'] == 0)) {
                          return const Center(
                              child: Text(
                                  'Es sind noch keine Ausgaben vorhanden'));
                        } else {
                          final memberExpenses =
                              snapshot.data as Map<String, dynamic>;
                          return PieChart(
                            PieChartData(
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 10,
                              centerSpaceColor: Colors.white,
                              sections: showingSections(memberExpenses),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<PieChartSectionData> showingSections(
      Map<String, dynamic> memberExpenses) {
    final List<PieChartSectionData> sections = [];

    memberExpenses.forEach((memberId, memberData) {
      sections.add(buildPieChartSectionData(
        memberData['username'],
        memberData['expense'],
        memberData['percentageOfTotal'],
      ));
    });

    return sections;
  }

  PieChartSectionData buildPieChartSectionData(String personName, double personValue, double percentageOfTotal) {
    const fontSize = 20.0;
    const radius = 160.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 10)];
    return PieChartSectionData(
      color: increaseBrightness(convertToColor(personName), 0.3),
      value: personValue,
      title: '$percentageOfTotal %',
      radius: radius,
      titlePositionPercentageOffset: .60,
      showTitle: true,
      titleStyle: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: shadows,
      ),
      badgeWidget: buildMemberCircle(personName, 50.0, 0.5),
      borderSide: const BorderSide(color: Colors.grey, width: 1),
      badgePositionPercentageOffset: .99,
    );
  }
}
