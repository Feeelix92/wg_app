import 'package:auto_route/auto_route.dart';
import 'route_guard.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    /// routes go here
    AutoRoute(page: RegistrationRoute.page, path: '/registration'),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: MyForgotPasswordRoute.page, path: '/forgotpassword'),
    AutoRoute(page: VerifyEmailRoute.page, path: '/verifyemail'),

    AutoRoute(page: HomeRoute.page, path: '/home', initial: true, guards: [AuthGuard()]),
    AutoRoute(page: HouseHoldDetailRoute.page, path: '/haushalt/:id', guards: [AuthGuard()]),
    AutoRoute(page: ShoppingListRoute.page, path: '/haushalt/:id/shoppinglist', guards: [AuthGuard()]),
    AutoRoute(page: TaskListRoute.page, path: '/haushalt/:id/tasklist', guards: [AuthGuard()]),
  ];
}