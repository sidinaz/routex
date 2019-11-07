import 'package:example/widgets/custom_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import '../theme/theme.dart';
import 'navigator_customization/custom_error_screen.dart';
import 'navigator_customization/custom_navigator.dart';
import 'navigator_customization/navigator_customization_controller.dart';

class NavigatorCustomizationApp extends StatelessWidget {

  RoutexNavigator createAndCustomizeNavigator() {
    RoutexNavigator customNavigator;
    //for more controls on transitions
    customNavigator = CustomNavigator();

    RoutexNavigator navigator = RoutexNavigator.newInstance(navigator: customNavigator);
//    navigator.errorScreen = (error) => (_) => CustomErrorScreen(error);
    //or directly on router for specific error codes
//    navigator.router.errorHandler(500, (context) => context.response().end((_) => CustomErrorScreen(context.failure)));
//    navigator.router.errorHandler(404, (context) => context.response().end((_) => CustomErrorScreen(ResponseStatusException(404, "Not found"))));
//    navigator.futureBuilder = (future) => CustomFutureBuilder(future);

    return navigator;
  }

  void bindRouter(Router router) {

    var navigatorCustomizationController = NavigatorCustomizationController();
    navigatorCustomizationController.bindRouter(router);

  }

  @override
  Widget build(BuildContext context) {

    bindRouter(createAndCustomizeNavigator().router);

    return MaterialApp(
      theme: AppTheme.instance,
      debugShowCheckedModeBanner: false,
      home: RoutexNavigator.shared.get("/")(context),
    );
    //Widget content
  }
}

