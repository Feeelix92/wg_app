import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:wg_app/data/constants.dart';
import 'package:wg_app/providers/household_provider.dart';
import 'package:wg_app/providers/user_provider.dart';
import 'package:wg_app/routes/app_router.dart';

import 'firebase_options.dart';

/// Die Main-Methode startet die App.
Future main() async {

  /// .env-Datei laden
  await dotenv.load(fileName: ".env");

  /// Firebase auf für entsprechende Plattform konfigurieren
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase initialisieren
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// App starten
  runApp(
    /// Initialisieren der Provider für die Datenverwaltung
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => HouseholdProvider()),
      ],
      child: MyApp(),
    ),
  );
}

/// Die MyApp-Klasse ist die Wurzel der App.
class MyApp extends StatelessWidget {
  MyApp({super.key});

  /// AppRouter für ddas Verwenden von Routen
  final _appRouter = AppRouter();

  /// NavigatorKey für die Navigation
  final navigatorKey = GlobalKey<NavigatorState>();


  /// Die build-Methode baut die App.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      /// Konfiguration des AppRouters
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
      /// Titel der App
      title: Constants.appName,
      /// Theme für die App
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}


