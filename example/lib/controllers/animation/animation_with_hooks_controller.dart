import 'package:example/base/base_controller.dart';
import 'package:example/config/config.dart';
import 'package:example/controllers/animation/data/animation_screen_type.dart';
import 'package:example/controllers/animation/view/animation_screen_with_tabs.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import 'package:rxdart/rxdart.dart';

class AnimationWithHooksController extends BaseController {
  @override
  void bindRouter(Router router) {
    router.route("/app/animation/").handler(index);

    router
        .route("/app/animation/with-tabs")
        .handler(getTabsHandler)
        .handler(withTabs);
  }

  void getTabsHandler(RoutingContext context) {
    //its easier to have 3 different routes for screens like this: router.route("/animation/:path").handler(index);
    // just like MainScreen with tabs
    //but this is example to show routex async handlers, standalone router usage, and passing tabs with context.
    final router = RoutexNavigator.shared.router;
    final animationScreenTypes = [
      AnimationScreenType.withStatefulWidget,
      AnimationScreenType.withHookWidget,
    ];
    final tabsWidgetBuilders = animationScreenTypes.map((ast) => router
        .handle(BaseRequest<WidgetBuilder>("/app/animation/",
            params: {"type": ast}))
        .asStream());
    Rx.zipList(tabsWidgetBuilders).listen((tabs) {
      context.put("tabs", tabs).next();
    }, onError: (error) => context.fail(error));
  }

  WidgetBuilder index(RoutingContext context) =>
      (_) => context("AnimationScreen");

  WidgetBuilder withTabs(RoutingContext context) =>
      (_) => AnimationScreenWithTabs(context.get("tabs"));
}
