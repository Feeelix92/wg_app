import '../model/household.dart';

class Constants {
  static const String appName = 'Liv2Gether';
}

// @Todo: Remove this dummy data and replace with Firebase data
class TestData {
  static List<Household> houseHoldData = [
    Household(
      id: 1,
      title: 'Muster-WG',
      description: 'Das ist eine Muster-WG',
    ),
  ];
}