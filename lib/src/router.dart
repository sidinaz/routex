import 'package:routex/src/impl/router_impl.dart';
import 'package:routex/src/route.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/util/routing_execution.dart';

import 'routing_context.dart';

/// A router receives request and routes it to the first matching [Route] that it contains.
/// A router can contain many routes.
/// Routers are also used for routing failures.
abstract class Router {
  static RouterImpl router() => RouterImpl();

  /// Add a route that matches the specified path.
  Route route(String path);

  /// Add a route that matches the specified path regex.
  Route routeWithRegex(String regex);

  Route wb(String path);

  Route string(String path);

  Route dynamic(String path);

  Route object(String path);

  RoutingExecution<T> handle<T>(RoutingRequest<T> request);

  /// Specify an handler to handle an error for a particular status code. You can use to manage general errors too using status code 500.
  /// The handler will be called when the context fails and other failure handlers didn't write the reply or when an exception is thrown inside an handler.
  /// You must not use [RoutingContext.next] inside the error handler
  /// This does not affect the normal failure routing logic.
  ///
  /// [statusCode] status code the errorHandler is capable of handle
  /// [errorHandler] error handler. Note: You must not use [RoutingContext.next] inside the provided handler
  /// returns a reference to this, so the API can be used fluently
  Router errorHandler(int statusCode, Object errorHandler);

  /// Mount a sub router on this router
  ///
  /// [mountPoint] the mount point (path prefix) to mount it on
  /// [subRouter] the router to mount as a sub router
  Router mountSubRouter(String mountPoint, Router subRouter);

  /// Used to route a context to the router. Used for sub-routers. You wouldn't normally call this method directly.
  ///
  /// [context] the routing context
  void handleContext(RoutingContext context);

  /// Used to route a failure to the router. Used for sub-routers. You wouldn't normally call this method directly.
  ///
  /// [context] the routing context
  void handleFailure(RoutingContext context);
}
