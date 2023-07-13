// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:wg_app/screens/home_screen.dart' as _i1;
import 'package:wg_app/screens/household_detail_screen.dart' as _i2;
import 'package:wg_app/screens/household_form_screen.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    HouseHoldDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HouseHoldDetailRouteArgs>(
          orElse: () => HouseHoldDetailRouteArgs(id: pathParams.getInt('id')));
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.HouseHoldDetailScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    HouseHoldFormRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HouseHoldFormScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HouseHoldDetailScreen]
class HouseHoldDetailRoute extends _i4.PageRouteInfo<HouseHoldDetailRouteArgs> {
  HouseHoldDetailRoute({
    _i5.Key? key,
    required int id,
    List<_i4.PageRouteInfo>? children,
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

  static const _i4.PageInfo<HouseHoldDetailRouteArgs> page =
      _i4.PageInfo<HouseHoldDetailRouteArgs>(name);
}

class HouseHoldDetailRouteArgs {
  const HouseHoldDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i5.Key? key;

  final int id;

  @override
  String toString() {
    return 'HouseHoldDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i3.HouseHoldFormScreen]
class HouseHoldFormRoute extends _i4.PageRouteInfo<void> {
  const HouseHoldFormRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HouseHoldFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'HouseHoldFormRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
