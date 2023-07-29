// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:wg_app/screens/home_screen.dart' as _i1;
import 'package:wg_app/screens/household_create_screen.dart' as _i4;
import 'package:wg_app/screens/household_detail_screen.dart' as _i2;
import 'package:wg_app/screens/household_edit_screen.dart' as _i3;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    HouseHoldDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseHoldDetailRouteArgs>(
          orElse: () => HouseHoldDetailRouteArgs(id: pathParams.getInt('id')));
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.HouseHoldDetailScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    HouseHoldEditRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseHoldEditRouteArgs>(
          orElse: () => HouseHoldEditRouteArgs(id: pathParams.getInt('id')));
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.HouseHoldEditScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    HouseHoldCreateRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HouseHoldCreateScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HouseHoldDetailScreen]
class HouseHoldDetailRoute extends _i5.PageRouteInfo<HouseHoldDetailRouteArgs> {
  HouseHoldDetailRoute({
    _i6.Key? key,
    required int id,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          HouseHoldDetailRoute.name,
          args: HouseHoldDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'HouseHoldDetailRoute';

  static const _i5.PageInfo<HouseHoldDetailRouteArgs> page =
      _i5.PageInfo<HouseHoldDetailRouteArgs>(name);
}

class HouseHoldDetailRouteArgs {
  const HouseHoldDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i6.Key? key;

  final int id;

  @override
  String toString() {
    return 'HouseHoldDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i3.HouseHoldEditScreen]
class HouseHoldEditRoute extends _i5.PageRouteInfo<HouseHoldEditRouteArgs> {
  HouseHoldEditRoute({
    _i6.Key? key,
    required int id,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          HouseHoldEditRoute.name,
          args: HouseHoldEditRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'HouseHoldEditRoute';

  static const _i5.PageInfo<HouseHoldEditRouteArgs> page =
      _i5.PageInfo<HouseHoldEditRouteArgs>(name);
}

class HouseHoldEditRouteArgs {
  const HouseHoldEditRouteArgs({
    this.key,
    required this.id,
  });

  final _i6.Key? key;

  final int id;

  @override
  String toString() {
    return 'HouseHoldEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i4.HouseHoldCreateScreen]
class HouseHoldCreateRoute extends _i5.PageRouteInfo<void> {
  const HouseHoldCreateRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HouseHoldCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'HouseHoldCreateRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
