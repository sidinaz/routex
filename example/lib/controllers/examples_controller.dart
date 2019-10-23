import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import '../theme/theme.dart';
import '../widgets/examples_screen.dart';

class ExamplesController implements Controller {
  //ExamplesSource executes this controller.

  void log(RoutingContext context){
//    throw "Uncomment this line to see result on examples screen";
    context.next();
  }

  @override
  void bindRouter(Router router) {
    router.route("/app/examples/*")
    .handler(log);

    router.route("/app/examples/")
        .handler((context) => context.response().end((_) => ExamplesScreen()));

    router.route("/app/examples/async-sync")
        .handler((context) async {
          context.put("a", await Future.delayed(Duration(milliseconds: 1), () => "Hello")); 
          context.next(); 
        })
        .handler((context) { context.put("b", "World"); context.next(); })
        .handler((context) => context.response().end("${context.get("a")} ${context.get("b")} ${context.getParam("additional_info")}"));

    router
        .route("/app/examples/request-for-widget-builder")
    .handler(widgetBuilderSpecialHandlerExample);

    router
        .route("/app/examples/request-for-widget")
        .handler(widgetSpecialHandlerExample);

    router
        .route("/app/examples/irresponsible")
        .handler((context) => print("Context neither complete or fails. (Missing context.next() or context.fail(error) call.)"))
        .handler((context) => context.response().end("This will not be executed without fix"));

    router
        .route("/app/examples/failing-context")
        .handler((context) => throw 454545454)
        .handler((context) => context.response().end("This will not be executed"))
        .failureHandler((context) => context.response().end("Failure handler used to return successfull response, catched error: ${context.failure.toString()} || Code: ${context.statusCode}"));

    router
        .route("/app/examples/putting-build_context-and-more-data")
        .handler(contextInfo);


    router.route("/app/examples/simple-future")
    .handler(futureInAsyncHandlerExample)
    .handler(anotherFutureInSyncHandlerExample)
        .handler(getResponse);
  }

  void contextInfo(RoutingContext context){
    context.response().end(context.getParam("message"));
  }

  Future getResponse(RoutingContext context) async => context.response().end(await Future.delayed(Duration(milliseconds: 1), () => "Future async, sync..."));

  Future futureInAsyncHandlerExample(RoutingContext context) async{
    await Future.delayed(Duration(milliseconds: 1), () => "Simple future");
    context.next();
  }

  void anotherFutureInSyncHandlerExample(RoutingContext context){
    Future.delayed(Duration(milliseconds: 1), () => "Simple future")
        .then((_) => context.next())
        .catchError((error) => context.fail(error));
  }

  WidgetBuilder widgetBuilderSpecialHandlerExample (RoutingContext context){
    //Handlers-functions with return type Widget and WidgetBuilder are special functions.
    //Routex is satisfied when you provide widgetBuilder which is just function that create widgets at the end.
    int a;
    Objects.requireNonNull(a);

    return (bc) =>
          Card(color: Theme
              .of(bc)
              .primaryColor, child: ListTile(
            title: Text("Text widget"), trailing: Icon(Icons.done_outline),),);
}

  Widget widgetSpecialHandlerExample (RoutingContext context){
  //Handlers-functions with return type Widget and WidgetBuilder are special functions.
    //Routex is satisfied when you provide widgetBuilder which is just function that create widgets at the end.
    //But if that function throws error it doesn't have anything with routex context, because existence of wb function in response.end(wb) is what you want to achieve.
    return Card(color: AppTheme.instance.primaryColor, child: ListTile(
      title: Text("Text widget 2"), trailing: Icon(Icons.done_outline),),);
  }
}
