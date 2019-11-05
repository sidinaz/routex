import 'dart:collection';

import 'package:routex/src/content_type.dart';
import 'package:routex/src/exceptions/illegal_argument_exception.dart';
import 'package:routex/src/handler.dart';
import 'package:routex/src/impl/route_impl.dart';
import 'package:routex/src/impl/routing_context_impl.dart';
import 'package:routex/src/route.dart';
import 'package:routex/src/router.dart';
import 'package:routex/src/routing_context.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/util/atomic_integer.dart';
import 'package:routex/src/util/objects.dart';
import 'package:routex/src/util/routing_execution.dart';

import 'routing_context_wrapper.dart';


class RouterImpl implements Router {
  final Set<RouteImpl> routes = SplayTreeSet(routeComparator);
  final AtomicInteger orderSequence = new AtomicInteger();

  static Function routeComparator = (RouteImpl o1, RouteImpl o2) {
    int x = o1.order;
    int y = o2.order;
    int compare = (x < y) ? -1 : ((x == y) ? 0 : 1);
    if (compare == 0) {
      if (x == y) {
        return 0;
      }
      return 1;
    }
    return compare;
  };

  Map<int, Handler<RoutingContext>> _errorHandlers = Map();

  @override
  Router errorHandler(int statusCode, Object errorHandler) {
    Objects.requireNonNull(errorHandler);
    this._errorHandlers[statusCode] = Action(errorHandler);
    return this;
  }

  Handler<RoutingContext> getErrorHandlerByStatusCode(int statusCode) =>
    _errorHandlers[statusCode];

  @override
  Route route(String path) =>
    RouteImpl(this, orderSequence.getAndIncrement(), path: path);


  @override
  Route routeWithRegex(String regex) =>
    RouteImpl(this, orderSequence.getAndIncrement(), regex: regex);

  @override
  Route wb(String path) =>
    RouteImpl(this, orderSequence.getAndIncrement(), path: path,
      content: ContentType.WIDGET_BUILDER);

  @override
  Route string(String path) =>
    RouteImpl(
      this, orderSequence.getAndIncrement(), path: path, content: ContentType.STRING);

  @override
  Route dynamic(String path) =>
    RouteImpl(this, orderSequence.getAndIncrement(), path: path,
      content: ContentType.DYNAMIC);

  @override
  Route object(String path) =>
    RouteImpl(
      this, orderSequence.getAndIncrement(), path: path, content: ContentType.OBJECT);

  void add(RouteImpl route) {
    routes.add(route);
  }

  @override
  RoutingExecution<T> handle<T>(RoutingRequest request) => RoutingExecution<T>(RoutingContextImpl(null, this, request, routes));

  Iterator<RouteImpl> iterator() => routes.iterator;

  @override
  Router mountSubRouter(String mountPoint, Router subRouter) {
    if (mountPoint.endsWith("*")) {
      throw new IllegalArgumentException("Don't include * when mounting subrouter");
    }
    if (mountPoint.contains(":")) {
      throw new IllegalArgumentException("Can't use patterns in subrouter mounts");
    }
    route(mountPoint + "*").handler(subRouter.handleContext).failureHandler(subRouter.handleFailure);
    return this;
  }

  @override
  void handleFailure(RoutingContext ctx) => RoutingContextWrapper(getAndCheckRoutePath(ctx), ctx.request(), routes, ctx).next();

  @override
  void handleContext(RoutingContext ctx) => RoutingContextWrapper(getAndCheckRoutePath(ctx), ctx.request(), routes, ctx).next();

  String getAndCheckRoutePath(RoutingContext ctx) {
    Route currentRoute = ctx.currentRoute();
    String path = currentRoute.getPath();
    if (path == null) {
      throw Exception("Sub routers must be mounted on constant paths (no regex or patterns)");
    }
    return path;
  }

}
