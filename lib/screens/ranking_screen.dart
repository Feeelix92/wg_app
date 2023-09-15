import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/data/constants.dart';
import 'package:wg_app/widgets/navigation/custom_app_bar.dart';

import '../providers/household_provider.dart';
import '../widgets/bar_chart/icon_widget.dart';
import '../widgets/navigation/app_drawer.dart';
import '../widgets/text/h1.dart';

@RoutePage()
class RankingScreen extends StatefulWidget {
  const RankingScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 20,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;


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
                const H1(text: 'Ranking'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: FutureBuilder<Map<String, int>>(
                      future: householdProvider
                          .getMemberPointsOverview(widget.householdId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Fehler: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text('Keine Daten verfügbar'));
                        } else {
                          var memberPointsOverview = snapshot.data!;
                          var dataList =
                              memberPointsOverview.entries.map((entry) {
                            return _BarData(
                                entry.key, entry.value.toDouble());
                          }).toList();
                          // Bestimmen der maaximalen Y-Achsen-Höhe bzw. Beschriftung
                          double maxY;
                          if (memberPointsOverview.values.first <= 10){
                            maxY = (memberPointsOverview.values.first + 20).toDouble();
                          } else if(memberPointsOverview.values.first <= 20){
                            maxY = (memberPointsOverview.values.first + 10).toDouble();
                          } else{
                            maxY = memberPointsOverview.values.first.toDouble();
                          }

                          return BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceBetween,
                              borderData: FlBorderData(
                                show: true,
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                leftTitles: AxisTitles(
                                  drawBelowEverything: true,
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      if (value.isFinite) { // Überprüfen, ob der Wert endlich ist
                                        return Text(
                                          value.toInt().toString(),
                                          textAlign: TextAlign.left,
                                        );
                                      } else {
                                        return const Text('');
                                      }
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 36,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: IconWidget(
                                          color: dataList[index].color,
                                          isSelected:
                                              touchedGroupIndex == index,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(),
                                topTitles: const AxisTitles(),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                ),
                              ),
                              barGroups: dataList.asMap().entries.map((e) {
                                final index = e.key;
                                final data = e.value;
                                return generateBarGroup(
                                  index,
                                  data.color,
                                  data.value,
                                );
                              }).toList(),
                              maxY: maxY,
                              barTouchData: BarTouchData(
                                enabled: true,
                                handleBuiltInTouches: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.white,
                                  tooltipBorder: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                  tooltipRoundedRadius: 40,
                                  tooltipMargin: 0,
                                  tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                                  tooltipPadding: const EdgeInsets.all(8),
                                  tooltipHorizontalOffset: 20,
                                  getTooltipItem: (
                                    BarChartGroupData group,
                                    int groupIndex,
                                    BarChartRodData rod,
                                    int rodIndex,
                                  ) {
                                    final name = dataList[groupIndex].name;
                                    return BarTooltipItem(
                                      '$name: ${rod.toY.toStringAsFixed(2)}', // Hier wird der Name und der Wert angezeigt
                                      const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BarData {
  const _BarData(this.name, this.value);

  final String name;
  final double value;

  Color get color => increaseBrightness(convertToColor(name), 0.1);
}

