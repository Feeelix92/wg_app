import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/data/constants.dart';
import 'package:wg_app/routes/app_router.gr.dart';
import 'package:wg_app/widgets/navigation/app_drawer.dart';
import 'package:wg_app/widgets/text/fonts.dart';

import '../providers/household_provider.dart';
import '../color_functions.dart';
import '../widgets/custom_error_dialog.dart';
import '../widgets/navigation/custom_app_bar.dart';

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
  String? selectedUserId;
  GlobalKey<FormState> _formKeyMember = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyAdmin = GlobalKey<FormState>();

  void _initializeFormKey() {
    _formKeyMember = GlobalKey<FormState>();
    _formKeyAdmin = GlobalKey<FormState>();
  }

  @override
  void initState() {
    final householdProvider =
        Provider.of<HouseholdProvider>(context, listen: false);
    selectedUserId = householdProvider.auth.currentUser?.uid;
    super.initState();
  }

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          const H1(text: "Mitglieder verwalten"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: H2(text: houseHoldProvider.household.title),
                          ),
                          if (houseHoldProvider.household.members.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: FutureBuilder<
                                  Map<String, Map<String, dynamic>>>(
                                future:
                                    houseHoldProvider.getHouseholdMembersData(
                                        houseHoldProvider.household.id),
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              const H3(text: 'Mitglieder'),
                                              Wrap(
                                                alignment: WrapAlignment.center,
                                                spacing: 5.0,
                                                children: [
                                                  ...?members?.keys.map(
                                                    (userId) {
                                                      if (userId ==
                                                          houseHoldProvider
                                                              .household
                                                              .admin) {
                                                        return Chip(
                                                          label: Text(
                                                            members[userId]
                                                                ?['username'],
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        20.0)),
                                                          ),
                                                          side:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                          backgroundColor:
                                                              increaseBrightness(
                                                                  convertToColor(
                                                                      members[userId]
                                                                          ?[
                                                                          'username']),
                                                                  0.2),
                                                        );
                                                      } else {
                                                        return InputChip(
                                                          label: Text(
                                                            members[userId]
                                                                ?['username'],
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        20.0)),
                                                          ),
                                                          side:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                          deleteIconColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              increaseBrightness(
                                                                  convertToColor(
                                                                      members[userId]
                                                                          ?[
                                                                          'username']),
                                                                  0.2),
                                                          selectedColor:
                                                              increaseBrightness(
                                                                  convertToColor(
                                                                      members[userId]
                                                                          ?[
                                                                          'username']),
                                                                  0.5),
                                                          onDeleted: () async {
                                                            String? email =
                                                                members[userId]
                                                                    ?['email'];
                                                            // cannot delete yourself
                                                            if (email ==
                                                                houseHoldProvider
                                                                    .auth
                                                                    .currentUser!
                                                                    .email) {
                                                              customErrorDialog(
                                                                  context,
                                                                  "Fehler",
                                                                  "Du kannst dich nicht selbst entfernen!");
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Mitglied entfernen'),
                                                                      content: Text(
                                                                          'Möchtest du ${members[userId]?['username']} wirklich entfernen?'),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              houseHoldProvider.removeUserFromHousehold(email!);
                                                                              AutoRouter.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('Entfernen')),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              AutoRouter.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('Abbrechen')),
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ).toList(),
                                                  Form(
                                                    key: _formKeyMember,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Column(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: H3(
                                                                text:
                                                                    'Mitglied hinzufügen'),
                                                          ),
                                                          TextFormField(
                                                            autofocus: false,
                                                            controller:
                                                                _emailController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .emailAddress,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'E-Mail Adresse',
                                                              prefixIcon: Icon(Icons
                                                                  .email_outlined),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0)),
                                                              ),
                                                            ),
                                                            validator: (email) =>
                                                                !EmailValidator
                                                                        .validate(
                                                                            email!)
                                                                    ? 'Bitte gib eine gültige E-Mail-Adresse ein!'
                                                                    : null,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKeyMember
                                                                    .currentState!
                                                                    .validate()) {
                                                                  String?
                                                                      email =
                                                                      _emailController
                                                                          .text;
                                                                  if (email ==
                                                                      houseHoldProvider
                                                                          .auth
                                                                          .currentUser!
                                                                          .email) {
                                                                    customErrorDialog(
                                                                        context,
                                                                        "Fehler",
                                                                        "Du kannst dich nicht selbst einladen!");
                                                                  }

                                                                  if (await houseHoldProvider
                                                                      .addUserToHousehold(
                                                                          email)) {
                                                                    _emailController
                                                                        .clear();
                                                                  } else {
                                                                    customErrorDialog(
                                                                        context,
                                                                        "Fehler",
                                                                        "Mitglied konnte nicht hinzugefügt werden! Entweder ist dieser Benutzer bereits im Haushalt oder es existiert kein Benutzer für die E-Mail-Adresse.");
                                                                  }
                                                                }
                                                              },
                                                              child: const Text(
                                                                  'Hinzufügen'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Column(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: H3(
                                                              text:
                                                                  'Admin ändern'),
                                                        ),
                                                        Form(
                                                          key: _formKeyAdmin,
                                                          child:
                                                              DropdownButtonFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'Admin ändern',
                                                              prefixIcon: Icon(Icons
                                                                  .admin_panel_settings),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30.0)),
                                                              ),
                                                            ),
                                                            value:
                                                                selectedUserId,
                                                            items: members?.keys
                                                                .map((userId) {
                                                              return DropdownMenuItem(
                                                                value: userId,
                                                                child: Text(members[
                                                                        userId]![
                                                                    'username']),
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedUserId =
                                                                    value
                                                                        as String; // Annahme: selectedUserId ist ein String
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              String email =
                                                                  members?[
                                                                          selectedUserId]![
                                                                      'email'];
                                                              if (email ==
                                                                  houseHoldProvider
                                                                      .auth
                                                                      .currentUser!
                                                                      .email) {
                                                                customErrorDialog(
                                                                    context,
                                                                    "Achtung!",
                                                                    "Der Admin konnte nicht geändert werden, da du bereits der Admin des Haushalts bist.");
                                                              } else {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Admin ändern'),
                                                                        content:
                                                                            const Text('Möchtest du den Admin wirklich ändern? Du kannst diesen Haushalt dann nicht mehr verwalten.'),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                houseHoldProvider.changeAdmin(email);
                                                                                AutoRouter.of(context).pop();
                                                                                AutoRouter.of(context).popUntilRouteWithName(HouseHoldDetailRoute.name);
                                                                              },
                                                                              child: const Text('Ja')),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                AutoRouter.of(context).pop();
                                                                              },
                                                                              child: const Text('Abbrechen')),
                                                                        ],
                                                                      );
                                                                    });
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Admin speichern'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
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
