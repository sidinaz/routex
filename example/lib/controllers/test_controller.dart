import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import '../di/app_component.dart';
import '../widgets/test_screens.dart';


class TestController implements Controller{

  @override
  void bindRouter(Router router) {
    router
      .route("/app/test/")
      .handler(startScreenHandler);

    router
      .route("/app/test/press-for-success-back-for-failure")
      .handler((context) =>
      context.response().end((_) => _template("Press or back", TestClickForSuccessBackForFailureScreen())));

    router
      .route("/app/test/result")
      .handler(showScreenForResultHandler)
      .handler((context) =>
      context.response().end((_) => _template("Success", TestResultScreen())))
      .failureHandler((context) => context.reroute("/app/test/failure"));

    router
      .route("/app/test/failure")
      .handler((context) =>
      context.response().end((_) => _template("Failure, no result", TestFailureScreen())));
  }

  Future showScreenForResultHandler(RoutingContext context) async {
    //build_context passed as parameter with RoutexNavigator.shared.push("/app/test/result", context, { "build_context": context});
    //Needed for navigation, RoutexNavigator simple passes BuildContext to Material's Navigator.
    int result = await RoutexNavigator.shared.push("/app/test/press-for-success-back-for-failure", context.getParam("build_context"));
    Objects.requireNonNull(result);
    print(result.toString());
    context.put("some_info", result);
    context.next();
  }


  void startScreenHandler(RoutingContext context){
    var appComponent = context.get<AppComponent>(AppComponent.key);
    Objects.requireNonNull(appComponent);

    context.response().end((bc) => _template("Test", TestStartScreen(logoutAction:(){
      appComponent.setUser(null);
      //push to app main but we will be redirected to the login screen.
      RoutexNavigator.shared.pushReplacement("/app/main", bc);
    })));
  }


  Widget _template(String title, Widget content) =>
    Scaffold(
      appBar: AppBar(
        title: Text(title)),
      body: content,
    );
}