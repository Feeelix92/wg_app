import '../color_functions.dart';
import 'indicator.dart';

/// {@category Widgets}
/// Erstellt ein [Indicator] Objekt für das Erstellen einer Legende.
Indicator buildIndicator(String username, double memberExpense) {
  return Indicator(
    color: increaseBrightness(convertToColor(username), 0.2),
    text: '$username: ${memberExpense.toStringAsFixed(2)} €',
    isSquare: false,
  );
}