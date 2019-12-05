import 'package:routex/src/content_type.dart';

/// A route is a holder for a set of criteria which determine whether a request or failure should be routed to a handler.
abstract class Route {
  /// Append a request handler to the route handlers list. The router routes requests to handlers depending on whether the various
  /// criteria such as method, path, etc match. When method, path, etc are the same for different routes, You should add multiple
  /// handlers to the same route object rather than creating two different routes objects with one handler for route
  ///
  /// [handler] the request handler
  /// returns a reference to this, so the API can be used fluently
  Route handler(Object handler);

  /// Append a failure handler to the route failure handlers list. The router routes failures to failurehandlers depending on whether the various
  /// criteria such as method, path, etc match. When method, path, etc are the same for different routes, You should add multiple
  /// failure handlers to the same route object rather than creating two different routes objects with one failure handler for route
  ///
  /// [handler] the request handler
  /// returns a reference to this, so the API can be used fluently
  Route failureHandler(Object handler);

  Route content(ContentType content);

  Set<ContentType> contents();

  /// returns the path prefix (if any) for this route
  String getPath();

  Route setRegexGroupsNames(List<String> groups);
}
