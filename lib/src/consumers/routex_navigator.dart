import 'package:flutter/material.dart';
import 'package:routex/src/consumers/future_observer.dart';
import 'package:routex/src/exceptions/response_status_exception.dart';
import 'package:routex/src/impl/routing_request_impl.dart';
import 'package:routex/src/router.dart';
import 'package:routex/src/widgets/routex_navigator_error_screen.dart';
import 'package:rxdart/rxdart.dart';

class RoutexNavigator {
  final Router _router;
  static RoutexNavigator _instance;
  static WidgetBuilder Function(ResponseStatusException) _errorScreen;
  Widget Function(Future<WidgetBuilder> wb) futureBuilder;

  static RoutexNavigator get shared =>
    _instance != null ? _instance : _instance = RoutexNavigator.createShared();

  Router get router => _router;

  RoutexNavigator._(this._router);

  static void _addDefaultErrorHandlers(Router router) {
    _checkForErrorScreen();

    router.errorHandler(404, (context) => context.response().end(_errorScreen(ResponseStatusException(404))));
    router.errorHandler(500, (context) => context.response().end(_errorScreen(ResponseStatusException(500, context.failure))));
    //Failing context will result in future with error, so with this strategy you relay on success context even with _errorScreen
    //otherwise error in future will show error in your future builder,
    // if you want to change default behaviour just explicitly call RoutexNavigator.createShared(applyDefaultHandlers) before any RoutexNavigator.shared usage to get ability to change applyDefaultHandlers parameter.
    //Without these handlers your context will fail for any unhandled erors(exceptions thrown in handlers without handling in .failureHandlers...), example:
//    Handler<RoutingContext> handler = router.getErrorHandlerByStatusCode(404);
//    if (handler == null) { // Default 404 handling
//      this.response().fail(ResponseStatusException(404));
    //...
  }

  //in app usage, called automatically when accesssing shared instance for the first time
  factory RoutexNavigator.createShared({bool applyDefaultHandlers: true}) {
    var router = Router.router();
    if (applyDefaultHandlers)
      _addDefaultErrorHandlers(router);
    _instance ??= RoutexNavigator._(router);
    return _instance;
  }

  //suitable for testing, RoutexNavigator.shared always has fresh instance.
  factory RoutexNavigator.newInstance({bool applyDefaultHandlers: true}) {
    Router router = Router.router();
    if (applyDefaultHandlers)
      _addDefaultErrorHandlers(router);
    _instance = RoutexNavigator._(router);
    return _instance;
  }

  Future<T> push<T extends Object>(String path, BuildContext context, [Map<String, dynamic> params]) =>
    Navigator.push(context, MaterialPageRoute(builder: asWidgetBuilder(path, params)));

  Future<T> pushReplacement<T extends Object>(String path, BuildContext context, [Map<String, dynamic> params]) =>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: asWidgetBuilder(path, params)));

  Future<T> replaceRoot<T extends Object>(String path, BuildContext context, [Map<String, dynamic> params]) =>
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: asWidgetBuilder(path, params)), (_) => false,);

  Future<WidgetBuilder> asWidgetBuilderFuture(String path, [Map<String, dynamic> params]) =>
    _router.handle(BaseRequest<WidgetBuilder>(path, params: params)).asFuture();

  WidgetBuilder asWidgetBuilder(String path, [Map<String, dynamic> params]) =>
      (ctx) => _futureObserver(asWidgetBuilderFuture(path, params));

  WidgetBuilder get(String path, [Map<String, dynamic> params]) =>
    asWidgetBuilder(path, params);

  Observable<WidgetBuilder> asWidgetBuilderStream(String path, [Map<String, dynamic> params]) =>
    Observable.fromFuture(asWidgetBuilderFuture(path, params));

  Widget _futureObserver(Future<WidgetBuilder> wb) =>
    futureBuilder != null ?
    futureBuilder(wb) :
    FutureObserver<WidgetBuilder>(
      future: wb,
      onSuccess: (ctx, widget) => widget(ctx),
    );

  static void _checkForErrorScreen() {
    if (_errorScreen == null)
      _errorScreen = (error) => (_) => RoutexNavigatorErrorScreen(error);
  }
}
