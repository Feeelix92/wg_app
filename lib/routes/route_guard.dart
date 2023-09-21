import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_router.gr.dart';

/// {@category Routes}
/// Schütz die Routen der App vor unautorisierten Zugriffen.
class AuthGuard extends AutoRouteGuard {
  @override
  /// Überprüft, ob der User angemeldet ist. Falls nicht, wird er auf die Login-Seite weitergeleitet.
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      router.push(const LoginRoute());
    } else {
      resolver.next(true);
    }
  }
}