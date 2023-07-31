import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    /// routes go here
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: HouseHoldDetailRoute.page, path: '/haushalt/:id'),
    AutoRoute(page: ShoppingListRoute.page, path: '/haushalt/:id/shoppinglist'),
    AutoRoute(page: TaskListRoute.page, path: '/haushalt/:id/tasklist'),
  ];
}