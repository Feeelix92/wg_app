import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/data/constants.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';
import '../providers/household_provider.dart';
import '../widgets/build_member_circle.dart';
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
  int touchedIndex = 0;

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
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: H1(text: 'Finanzen'),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 20,
                  child: AspectRatio(
                    aspectRatio: 10,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: showingSections(),
                      ),
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

  PieChartSectionData buildPieChartSectionData(isTouched, String personName, double personValue) {
    final fontSize = isTouched ? 30.0 : 20.0;
    final radius = isTouched ? 200.0 : 160.0;
    final widgetSize = isTouched ? 55.0 : 40.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 10)];
    return PieChartSectionData(
      color: increaseBrightness(convertToColor(personName), 0.3),
      value: personValue,
      title: '$personValue %',
      radius: radius,
      titlePositionPercentageOffset: .60,
      showTitle: true,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
        shadows: shadows,
      ),
      badgeWidget: buildMemberCircle(personName, 50.0, 50.0, 0.1),
      badgePositionPercentageOffset: .99,
    );
  }


  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      switch (i) {
        case 0:
          return buildPieChartSectionData(isTouched, "Person 1", 20.0);
        case 1:
          return buildPieChartSectionData(isTouched, "Person 2", 30.0);
        case 2:
          return buildPieChartSectionData(isTouched, "Person 3", 40.0);
        case 3:
          return buildPieChartSectionData(isTouched, "Person 4", 10.0);
        default:
          throw Exception('Oh no');
      }
    });
  }
}

