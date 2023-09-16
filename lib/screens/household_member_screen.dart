import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/data/constants.dart';
import 'package:wg_app/widgets/navigation/app_drawer.dart';

import '../providers/household_provider.dart';
import '../widgets/custom_error_dialog.dart';
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/text/h1.dart';
import '../widgets/text/h2.dart';

@RoutePage()
class HouseholdMemberScreen extends StatefulWidget {
  const HouseholdMemberScreen(
      {super.key, @PathParam('householdId') required this.householdId});

  final String householdId;

  @override
  State<HouseholdMemberScreen> createState() => _HouseholdMemberScreenState();
}

class _HouseholdMemberScreenState extends State<HouseholdMemberScreen> {
  bool isLoading = false; // Starte mit dem Ladezustand
  bool showInviteField = false;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
        appBar: const CustomAppBar(),
        endDrawer: const AppDrawer(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(), // Ladekreis anzeigen
              )
            : Consumer<HouseholdProvider>(
                builder: (context, houseHoldProvider, child) {
                  // Ansonsten baue die Hauptansicht
                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          H1(text: "Mitglieder verwalten"),
                          H2(text: houseHoldProvider.household.title),
                          if (houseHoldProvider.household.members.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: FutureBuilder<List<String>>(
                                future:
                                    houseHoldProvider.getHouseholdMembersNames(houseHoldProvider.household.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Zeige einen Ladekreis während des Ladens an
                                  } else if (snapshot.hasError) {
                                    return Text('Fehler: ${snapshot.error}');
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Text(
                                        'Keine Mitglieder gefunden');
                                  } else {
                                    final members = snapshot.data;
                                    return Column(
                                      children: [
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 5.0,
                                          children: List<Widget>.generate(
                                            members!.length,
                                            (int index) {
                                              return InputChip(
                                                label: Text(
                                                    members[index],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                ),
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                ),
                                                deleteIconColor: Colors.white,
                                                backgroundColor: increaseBrightness(convertToColor(members[index]), 0.2),
                                                selectedColor: increaseBrightness(convertToColor(members[index]), 0.5),
                                                onDeleted: () async {
                                                  String? member =
                                                      await houseHoldProvider
                                                          .getEmailFromUsername(
                                                              members[index]);
                                                  print(member);
                                                  // houseHoldProvider
                                                  //     .removeUserFromHousehold(
                                                  //         members[index]);
                                                },
                                              );
                                            },
                                          ).toList(),
                                        ),

                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
