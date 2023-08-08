// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:wg_app/main.dart' as _i1;
import 'package:wg_app/screens/home_screen.dart' as _i2;
import 'package:wg_app/screens/household_detail_screen.dart' as _i3;
import 'package:wg_app/screens/login_screen.dart' as _i4;
import 'package:wg_app/screens/myForgotPassword_screen.dart' as _i5;
import 'package:wg_app/screens/register_screen.dart' as _i6;
import 'package:wg_app/screens/shoppinglist_screen.dart' as _i7;
import 'package:wg_app/screens/tasklist_screen.dart' as _i8;
import 'package:wg_app/screens/verifyEmail_screen.dart' as _i9;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    AuthGate.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AuthGate(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    HouseHoldDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseHoldDetailRouteArgs>(
          orElse: () => HouseHoldDetailRouteArgs(
              householdId: pathParams.getInt('householdId')));
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.HouseHoldDetailScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginScreen(),
      );
    },
    MyForgotPasswordRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MyForgotPasswordScreen(),
      );
    },
    MyRegisterRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.MyRegisterScreen(),
      );
    },
    ShoppingListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ShoppingListRouteArgs>(
          orElse: () => ShoppingListRouteArgs(
              householdId: pathParams.getInt('householdId')));
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.ShoppingListScreen(
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
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.TaskListScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    VerifyEmailRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.VerifyEmailScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthGate]
class AuthGate extends _i10.PageRouteInfo<void> {
  const AuthGate({List<_i10.PageRouteInfo>? children})
      : super(
          AuthGate.name,
          initialChildren: children,
        );

  static const String name = 'AuthGate';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i10.PageRouteInfo<void> {
  const HomeRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HouseHoldDetailScreen]
class HouseHoldDetailRoute
    extends _i10.PageRouteInfo<HouseHoldDetailRouteArgs> {
  HouseHoldDetailRoute({
    _i11.Key? key,
    required int householdId,
    List<_i10.PageRouteInfo>? children,
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

  static const _i10.PageInfo<HouseHoldDetailRouteArgs> page =
      _i10.PageInfo<HouseHoldDetailRouteArgs>(name);
}

class HouseHoldDetailRouteArgs {
  const HouseHoldDetailRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i11.Key? key;

  final int householdId;

  @override
  String toString() {
    return 'HouseHoldDetailRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MyForgotPasswordScreen]
class MyForgotPasswordRoute extends _i10.PageRouteInfo<void> {
  const MyForgotPasswordRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MyForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyForgotPasswordRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MyRegisterScreen]
class MyRegisterRoute extends _i10.PageRouteInfo<void> {
  const MyRegisterRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MyRegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyRegisterRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ShoppingListScreen]
class ShoppingListRoute extends _i10.PageRouteInfo<ShoppingListRouteArgs> {
  ShoppingListRoute({
    _i11.Key? key,
    required int householdId,
    List<_i10.PageRouteInfo>? children,
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

  static const _i10.PageInfo<ShoppingListRouteArgs> page =
      _i10.PageInfo<ShoppingListRouteArgs>(name);
}

class ShoppingListRouteArgs {
  const ShoppingListRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i11.Key? key;

  final int householdId;

  @override
  String toString() {
    return 'ShoppingListRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i8.TaskListScreen]
class TaskListRoute extends _i10.PageRouteInfo<TaskListRouteArgs> {
  TaskListRoute({
    _i11.Key? key,
    required int householdId,
    List<_i10.PageRouteInfo>? children,
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

  static const _i10.PageInfo<TaskListRouteArgs> page =
      _i10.PageInfo<TaskListRouteArgs>(name);
}

class TaskListRouteArgs {
  const TaskListRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i11.Key? key;

  final int householdId;

  @override
  String toString() {
    return 'TaskListRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i9.VerifyEmailScreen]
class VerifyEmailRoute extends _i10.PageRouteInfo<void> {
  const VerifyEmailRoute({List<_i10.PageRouteInfo>? children})
      : super(
          VerifyEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'VerifyEmailRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
