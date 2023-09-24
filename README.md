# Liv2Gether
Eine App die beim Organisieren einer WG hilft.

## App-Plattformen
Die App ist für die nachfolgenden Plattformen verfügbar, jedoch wurde sie, 
aufgrund der zeitlichen Einschränkungen im Entwicklungsprozess, 
nur auf Android Geräten getestet und für Android Smartphones optimiert.
- Android
- iOS
- Linux
- MacOS
- Web
- Windows

## Features der App:
- Erstellung eines neuen Haushalts und Einladen/ Entfernen von Mitbewohnern. 
- Erstellung einer funktionsfähigen Einkauf- und Aufgabenliste mit der Möglichkeit, Produkte und Aufgaben hinzuzufügen, 
zu entfernen und Bewohnern zuzuweisen. 
- Ausgabenverwaltung für gemeinsame Ausgaben.
- Rangliste mit Punktestand über gesammelte Punkte
- ausstehend: Belohnungen in Form von Punkten für erledigte Aufgaben
- ausstehend: Erinnerungsfunktion für anstehende Aufgaben

## Verwendete Technologien
- Flutter
- Firebase

## Development
Im nachfolgenden Abschnitt wird beschrieben, wie die App lokal gestartet werden kann.

### Voraussetzungen
- Flutter SDK
- Android Studio
- Android Emulator oder Android Gerät

### Installation
- Flutter installieren: https://flutter.dev/docs/get-started/install
- Android Studio installieren: https://developer.android.com/studio/install
- Flutter Plugin für Android Studio installieren: https://flutter.dev/docs/get-started/editor?tab=androidstudio
- Android Studio starten und Flutter SDK Pfad angeben
- Flutter Projekt klonen: `git clone https://github.com/Feeelix92/wg_app`
- Packages installieren: `flutter pub get`
- Android Emulator starten oder Android Gerät anschließen
- App starten: `flutter run`

### Weitere Befehle
- App bauen: `flutter build apk`
- Packages installieren: `flutter pub get`
- Packages aktualisieren: `flutter pub upgrade`
- Prüfen, ob alles notwendige korrekt installiert ist: `flutter doctor`

### Route hinzufügen
- im jeweiligen Screen die Annotation `@RoutePage()` hinzufügen
- in /routes/app_router.dart kann ein Pfad für die Route hinzugefügt werden
- Befehl `flutter packages pub run build_runner build` ausführen, damit automatisch die Route generiert wird