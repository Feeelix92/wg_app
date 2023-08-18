import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final user = FirebaseAuth.instance.currentUser;

   // final userProvider = Provider.of<UserProvider>(router.navigatorKey.currentContext!, listen: false);

    if (user == null) {
      router.push(const LoginRoute());
    } else {
      // userProvider.updateUserInformation().then((value) => resolver.next(true));
      resolver.next(true);
    }
  }
}