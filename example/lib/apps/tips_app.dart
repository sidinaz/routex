import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import 'package:rxdart/rxdart.dart';

import '../theme/theme.dart';
import '../widgets/custom_future_builder.dart';

class TipsApp extends StatelessWidget {

  void bindRouter(Router router) {
    router.route("/tips")
      .handler(handleFutureWithoutAsyncAwaitExample)
      .handler(handleAnotherAsyncCode)
      .handler(specialWBHandlers);

    router
      .route("/app/examples/division-by-zero")
    //.handler((context) => throw "some exception to se another failure handler in action")
      .handler((context) => context.put("value", 7 ~/ 0).next())
      .handler((context) =>
      context.response().end((_) => Text("Result: ${context.get("value")}")))
      .failureHandler((context) =>
    context.failure != null && context.failure is IntegerDivisionByZeroException
      ?
    context.response().end((_) => Text("IntegerDivisionByZeroException"))
      :
    context.next()) //continue to another failure handler if presented
      .failureHandler((context) =>
      context.response().end((_) =>
        Text("Error: ${ResponseStatusException(
          context.statusCode != -1 ? context.statusCode : 500,
          context.failure)}")));
  }

  void handleFutureWithoutAsyncAwaitExample(RoutingContext context) {
    Future<String> longRunningFuture = Future.delayed(
      Duration(seconds: 2), () => "Some content");

    longRunningFuture.then((value) {
      context.put("message", value);
      context.next();
    }).catchError((error) {
      context.fail(error);
    });
  }

  void handleAnotherAsyncCode(RoutingContext context) {
    //IMPORTANT!!!
    // As seen in handleFutureWithoutAsyncAwaitExample we can execute async code in sync handlers(void type) but
    //we must not throw errors like this: throw something in async rxdart's on error handler.
    //This is possible because only context.next can trigger next handler, that means
    //In this scenario we must always use context.fail(something) because throwing something will lead to unhandled exceptions.
    //In example below, map operator will propagate error to onError handler and we pass that error to the context.
    //This is sync handler(void handleAnotherAsyncCode) so we can't do throw in rxdart's async onError handler.
    //https://dart.dev/codelabs/async-await#handling-errors
    //https://dart.dev/tutorials/language/streams
    //https://github.com/ReactiveX/rxdart
    Stream.value(context.get<String>(
      "change_this_to_message")) //change_this_to_message to success
      .map((value) => Objects.requireNonNull(value))
      .listen((value) => context.next(),
      onError: (error) =>
        context.fail("Error: $error caught with rx extension"));
  }

  //functions that return WidgetBuilder or Widget have special meaning.
  //That handlers will be used as input for: context.response.end(WB Function(RC context))....
  WidgetBuilder specialWBHandlers(RoutingContext context) {
    return (_) =>
      Container(child: Center(child: Text(context.get<String>("message")),),);
  }

  @override
  Widget build(BuildContext context) {
    //Custom settings for easier testing
    //With applyDefaultHandlers: false we will see CustomFutureBuilder in action, unhandled error will result in error in
    //resulting future, if we leave that error handlers, then we will always have successfull response,but 500 or 404 unwanted errors screen.
    var routexNavigator = RoutexNavigator.newInstance(applyDefaultHandlers: false);
    Router router = routexNavigator.router;
    bindRouter(router);

    //Add custom future Builder
    routexNavigator.futureBuilder = (future) => CustomFutureBuilder(future);

    return MaterialApp(
      theme: AppTheme.instance,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
//          child: RoutexNavigator.shared.asWidgetBuilder("/tips", context)(context),
          child: RoutexNavigator.shared.get(
            "/app/examples/division-by-zero")(context),
        ),
      ),
    );
  }
}
