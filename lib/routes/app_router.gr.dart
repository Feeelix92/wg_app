// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:wg_app/screens/home_screen.dart' as _i1;
import 'package:wg_app/screens/household_create_screen.dart' as _i2;
import 'package:wg_app/screens/household_detail_screen.dart' as _i3;
import 'package:wg_app/screens/household_edit_screen.dart' as _i4;
import 'package:wg_app/screens/shoppinglist_screen.dart' as _i5;
import 'package:wg_app/screens/tasklist_screen.dart' as _i6;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    HouseHoldCreateRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HouseHoldCreateScreen(),
      );
    },
    HouseHoldDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseHoldDetailRouteArgs>(
          orElse: () => HouseHoldDetailRouteArgs(
              householdId: pathParams.getInt('householdId')));
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.HouseHoldDetailScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    HouseHoldEditRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseHoldEditRouteArgs>(
          orElse: () => HouseHoldEditRouteArgs(
              householdId: pathParams.getInt('householdId')));
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.HouseHoldEditScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    ShoppingListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ShoppingListRouteArgs>(
          orElse: () => ShoppingListRouteArgs(
              householdId: pathParams.getInt('householdId')));
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ShoppingListScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    TaskListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TaskListRouteArgs>(
          orElse: () =>
              TaskListRouteArgs(householdId: pathParams.getInt('householdId')));
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.TaskListScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HouseHoldCreateScreen]
class HouseHoldCreateRoute extends _i7.PageRouteInfo<void> {
  const HouseHoldCreateRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HouseHoldCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'HouseHoldCreateRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HouseHoldDetailScreen]
class HouseHoldDetailRoute extends _i7.PageRouteInfo<HouseHoldDetailRouteArgs> {
  HouseHoldDetailRoute({
    _i8.Key? key,
    required int householdId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          HouseHoldDetailRoute.name,
          args: HouseHoldDetailRouteArgs(
            key: key,
            householdId: householdId,
          ),
          rawPathParams: {'householdId': householdId},
          initialChildren: children,
        );

  static const String name = 'HouseHoldDetailRoute';

  static const _i7.PageInfo<HouseHoldDetailRouteArgs> page =
      _i7.PageInfo<HouseHoldDetailRouteArgs>(name);
}

class HouseHoldDetailRouteArgs {
  const HouseHoldDetailRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i8.Key? key;

  final int householdId;

  @override
  String toString() {
    return 'HouseHoldDetailRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i4.HouseHoldEditScreen]
class HouseHoldEditRoute extends _i7.PageRouteInfo<HouseHoldEditRouteArgs> {
  HouseHoldEditRoute({
    _i8.Key? key,
    required int householdId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          HouseHoldEditRoute.name,
          args: HouseHoldEditRouteArgs(
            key: key,
            householdId: householdId,
          ),
          rawPathParams: {'householdId': householdId},
          initialChildren: children,
        );

  static const String name = 'HouseHoldEditRoute';

  static const _i7.PageInfo<HouseHoldEditRouteArgs> page =
      _i7.PageInfo<HouseHoldEditRouteArgs>(name);
}

class HouseHoldEditRouteArgs {
  const HouseHoldEditRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i8.Key? key;

  final int householdId;

  @override
  String toString() {
    return 'HouseHoldEditRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i5.ShoppingListScreen]
class ShoppingListRoute extends _i7.PageRouteInfo<ShoppingListRouteArgs> {
  ShoppingListRoute({
    _i8.Key? key,
    required int householdId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ShoppingListRoute.name,
          args: ShoppingListRouteArgs(
            key: key,
            householdId: householdId,
          ),
          rawPathParams: {'householdId': householdId},
          initialChildren: children,
        );

  static const String name = 'ShoppingListRoute';

  static const _i7.PageInfo<ShoppingListRouteArgs> page =
      _i7.PageInfo<ShoppingListRouteArgs>(name);
}

class ShoppingListRouteArgs {
  const ShoppingListRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i8.Key? key;

  final int householdId;

  @override
  String toString() {
    return 'ShoppingListRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i6.TaskListScreen]
class TaskListRoute extends _i7.PageRouteInfo<TaskListRouteArgs> {
  TaskListRoute({
    _i8.Key? key,
    required int householdId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          TaskListRoute.name,
          args: TaskListRouteArgs(
            key: key,
            householdId: householdId,
          ),
          rawPathParams: {'householdId': householdId},
          initialChildren: children,
        );

  static const String name = 'TaskListRoute';

  static const _i7.PageInfo<TaskListRouteArgs> page =
      _i7.PageInfo<TaskListRouteArgs>(name);
}

class TaskListRouteArgs {
  const TaskListRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i8.Key? key;

  final int householdId;

  @override
  String toString() {
    return 'TaskListRouteArgs{key: $key, householdId: $householdId}';
  }
}
