import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';
import '../providers/household_provider.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/pie_chart/build_indicator.dart';
import '../widgets/pie_chart/build_pie_chart_section_data.dart';
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
  Future<Map<String, dynamic>?> fetchMemberExpenses() async {
    final householdProvider =
    Provider.of<HouseholdProvider>(context, listen: false);

    final memberExpenses =
    await householdProvider.calculateMemberExpenses(widget.householdId);

    if (memberExpenses.isEmpty ||
        memberExpenses.values.every((value) => value['expense'] == 0)) {
      // Handle the case where there is no data or all expenses are zero.
      return null;
    }

    return memberExpenses;
  }

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
                        future: fetchMemberExpenses(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.data == null) {
                            /// Keine Daten verfügbar.
                            return const Center(child: Text('Keine Daten verfügbar'));
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
                FutureBuilder(
                  future: fetchMemberExpenses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data == null) {
                      /// Keine Daten verfügbar.
                      return const Center(child: Text('Keine Daten verfügbar'));
                    } else {
                      final memberExpenses =
                      snapshot.data as Map<String, dynamic>;
                      return SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 5.0,
                              children: [
                                ...memberExpenses.entries.map((memberId) {
                                  final memberData = memberId.value;
                                  final memberExpense = memberData['expense'];
                                  final username = memberData['username'];
                                  return buildIndicator(username, memberExpense);
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(Map<String, dynamic> memberExpenses) {
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
}
