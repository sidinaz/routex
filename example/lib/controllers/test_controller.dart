import 'package:example/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import '../widgets/test_screens.dart';

class TestController implements BaseController {
  @override
  void bindRouter(Router router) {
    router.route("/app/test/").handler(startScreenHandler);

    router.route("/app/test/press-for-success-back-for-failure").handler(
        (context) => context
            .response()
            .end((_) => TestClickForSuccessBackForFailureScreen()));

    router
        .route("/app/test/result")
        .handler(showScreenForResultHandler)
        .handler((context) => context.response().end((_) => TestResultScreen()))
        .failureHandler((context) => context.reroute("/app/test/failure"));

    router.route("/app/test/failure").handler(
        (context) => context.response().end((_) => TestFailureScreen()));
  }

  Future showScreenForResultHandler(RoutingContext context) async {
    //build_context passed as parameter with RoutexNavigator.shared.push("/app/test/result", context, { "build_context": context});
    //Needed for navigation, RoutexNavigator simple passes BuildContext to Material's Navigator.
    int result = await RoutexNavigator.shared.push(
        "/app/test/press-for-success-back-for-failure",
        context.getParam("build_context"));
    Objects.requireNonNull(result);
    print(result.toString());
    context.put("some_info", result);
    context.next();
  }

  WidgetBuilder startScreenHandler(RoutingContext context) =>
      (_) => context<TestStartScreen>();
}
