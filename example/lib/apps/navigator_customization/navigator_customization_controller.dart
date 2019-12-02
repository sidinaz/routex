import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import 'navigator_customization_screen.dart';

class NavigatorCustomizationController implements Controller {
  @override
  void bindRouter(Router router) {
    router.route("/").handler(main);

    router
      .route("/white")
      .handler(white);

    router
        .route("/green")
        .handler((context) async => context
            .put("message",
                await Future.delayed(Duration(seconds: 2), () => "Hello"))
            .next())
        .handler(green);

    router.route("/blue").handler((context) => throw "error").handler(blue);
  }

  WidgetBuilder main(RoutingContext context) => (bc) => _template(
        "Main",
        bc,
        NavigatorCustomizationScreen(),
      );

  WidgetBuilder white(RoutingContext context) => (bc) => _template(
      "White - simple",
      bc,
      Container(
        color: Colors.white70,
      ));

  WidgetBuilder green(RoutingContext context) => (bc) => _template(
      "Green - delay",
      bc,
      Container(
        color: Colors.green,
      ));

  WidgetBuilder blue(RoutingContext context) => (bc) => _template(
      "Blue - error",
      bc,
      Container(
        color: Colors.blue,
      ));

  Widget _template(String title, BuildContext context, Widget content) =>
      Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: content,
      );
}
