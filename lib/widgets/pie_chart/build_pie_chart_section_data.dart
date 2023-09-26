import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../build_member_circle.dart';
import '../color_functions.dart';

/// Erstellt ein [PieChartSectionData] Objekt für das Erstellen eines Pie Chart.
PieChartSectionData buildPieChartSectionData(String personName, double personValue, double percentageOfTotal) {
  const fontSize = 20.0;
  const radius = 140.0;
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
    badgeWidget: buildMemberCircle(personName, 50.0, 0.2),
    badgePositionPercentageOffset: .99,
  );
}