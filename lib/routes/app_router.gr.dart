// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;
import 'package:wg_app/screens/finance_screen.dart' as _i1;
import 'package:wg_app/screens/home_screen.dart' as _i2;
import 'package:wg_app/screens/household_detail_screen.dart' as _i3;
import 'package:wg_app/screens/household_member_screen.dart' as _i4;
import 'package:wg_app/screens/login_screen.dart' as _i5;
import 'package:wg_app/screens/my_forgot_password_screen.dart' as _i6;
import 'package:wg_app/screens/profile_screen.dart' as _i7;
import 'package:wg_app/screens/ranking_screen.dart' as _i8;
import 'package:wg_app/screens/registration_screen.dart' as _i9;
import 'package:wg_app/screens/shoppinglist_screen.dart' as _i10;
import 'package:wg_app/screens/tasklist_screen.dart' as _i11;
import 'package:wg_app/screens/verify_email_screen.dart' as _i12;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    FinanceRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<FinanceRouteArgs>(
          orElse: () => FinanceRouteArgs(
              householdId: pathParams.getString('householdId')));
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.FinanceScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    HouseHoldDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseHoldDetailRouteArgs>(
          orElse: () => HouseHoldDetailRouteArgs(
              householdId: pathParams.getString('householdId')));
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.HouseHoldDetailScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    HouseholdMemberRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseholdMemberRouteArgs>(
          orElse: () => HouseholdMemberRouteArgs(
              householdId: pathParams.getString('householdId')));
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.HouseholdMemberScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoginScreen(),
      );
    },
    MyForgotPasswordRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.MyForgotPasswordScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ProfileScreen(),
      );
    },
    RankingRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<RankingRouteArgs>(
          orElse: () => RankingRouteArgs(
              householdId: pathParams.getString('householdId')));
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.RankingScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    RegistrationRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.RegistrationScreen(),
      );
    },
    ShoppingListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ShoppingListRouteArgs>(
          orElse: () => ShoppingListRouteArgs(
              householdId: pathParams.getString('householdId')));
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.ShoppingListScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    TaskListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TaskListRouteArgs>(
          orElse: () => TaskListRouteArgs(
              householdId: pathParams.getString('householdId')));
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.TaskListScreen(
          key: args.key,
          householdId: args.householdId,
        ),
      );
    },
    VerifyEmailRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.VerifyEmailScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.FinanceScreen]
class FinanceRoute extends _i13.PageRouteInfo<FinanceRouteArgs> {
  FinanceRoute({
    _i14.Key? key,
    required String householdId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          FinanceRoute.name,
          args: FinanceRouteArgs(
            key: key,
            householdId: householdId,
          ),
          rawPathParams: {'householdId': householdId},
          initialChildren: children,
        );

  static const String name = 'FinanceRoute';

  static const _i13.PageInfo<FinanceRouteArgs> page =
      _i13.PageInfo<FinanceRouteArgs>(name);
}

class FinanceRouteArgs {
  const FinanceRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i14.Key? key;

  final String householdId;

  @override
  String toString() {
    return 'FinanceRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HouseHoldDetailScreen]
class HouseHoldDetailRoute
    extends _i13.PageRouteInfo<HouseHoldDetailRouteArgs> {
  HouseHoldDetailRoute({
    _i14.Key? key,
    required String householdId,
    List<_i13.PageRouteInfo>? children,
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

  static const _i13.PageInfo<HouseHoldDetailRouteArgs> page =
      _i13.PageInfo<HouseHoldDetailRouteArgs>(name);
}

class HouseHoldDetailRouteArgs {
  const HouseHoldDetailRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i14.Key? key;

  final String householdId;

  @override
  String toString() {
    return 'HouseHoldDetailRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i4.HouseholdMemberScreen]
class HouseholdMemberRoute
    extends _i13.PageRouteInfo<HouseholdMemberRouteArgs> {
  HouseholdMemberRoute({
    _i14.Key? key,
    required String householdId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          HouseholdMemberRoute.name,
          args: HouseholdMemberRouteArgs(
            key: key,
            householdId: householdId,
          ),
          rawPathParams: {'householdId': householdId},
          initialChildren: children,
        );

  static const String name = 'HouseholdMemberRoute';

  static const _i13.PageInfo<HouseholdMemberRouteArgs> page =
      _i13.PageInfo<HouseholdMemberRouteArgs>(name);
}

class HouseholdMemberRouteArgs {
  const HouseholdMemberRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i14.Key? key;

  final String householdId;

  @override
  String toString() {
    return 'HouseholdMemberRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i5.LoginScreen]
class LoginRoute extends _i13.PageRouteInfo<void> {
  const LoginRoute({List<_i13.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MyForgotPasswordScreen]
class MyForgotPasswordRoute extends _i13.PageRouteInfo<void> {
  const MyForgotPasswordRoute({List<_i13.PageRouteInfo>? children})
      : super(
          MyForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyForgotPasswordRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ProfileScreen]
class ProfileRoute extends _i13.PageRouteInfo<void> {
  const ProfileRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i8.RankingScreen]
class RankingRoute extends _i13.PageRouteInfo<RankingRouteArgs> {
  RankingRoute({
    _i14.Key? key,
    required String householdId,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          RankingRoute.name,
          args: RankingRouteArgs(
            key: key,
            householdId: householdId,
          ),
          rawPathParams: {'householdId': householdId},
          initialChildren: children,
        );

  static const String name = 'RankingRoute';

  static const _i13.PageInfo<RankingRouteArgs> page =
      _i13.PageInfo<RankingRouteArgs>(name);
}

class RankingRouteArgs {
  const RankingRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i14.Key? key;

  final String householdId;

  @override
  String toString() {
    return 'RankingRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i9.RegistrationScreen]
class RegistrationRoute extends _i13.PageRouteInfo<void> {
  const RegistrationRoute({List<_i13.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ShoppingListScreen]
class ShoppingListRoute extends _i13.PageRouteInfo<ShoppingListRouteArgs> {
  ShoppingListRoute({
    _i14.Key? key,
    required String householdId,
    List<_i13.PageRouteInfo>? children,
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

  static const _i13.PageInfo<ShoppingListRouteArgs> page =
      _i13.PageInfo<ShoppingListRouteArgs>(name);
}

class ShoppingListRouteArgs {
  const ShoppingListRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i14.Key? key;

  final String householdId;

  @override
  String toString() {
    return 'ShoppingListRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i11.TaskListScreen]
class TaskListRoute extends _i13.PageRouteInfo<TaskListRouteArgs> {
  TaskListRoute({
    _i14.Key? key,
    required String householdId,
    List<_i13.PageRouteInfo>? children,
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

  static const _i13.PageInfo<TaskListRouteArgs> page =
      _i13.PageInfo<TaskListRouteArgs>(name);
}

class TaskListRouteArgs {
  const TaskListRouteArgs({
    this.key,
    required this.householdId,
  });

  final _i14.Key? key;

  final String householdId;

  @override
  String toString() {
    return 'TaskListRouteArgs{key: $key, householdId: $householdId}';
  }
}

/// generated route for
/// [_i12.VerifyEmailScreen]
class VerifyEmailRoute extends _i13.PageRouteInfo<void> {
  const VerifyEmailRoute({List<_i13.PageRouteInfo>? children})
      : super(
          VerifyEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'VerifyEmailRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}
