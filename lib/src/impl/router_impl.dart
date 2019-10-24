import 'dart:collection';

import 'package:routex/src/content_type.dart';
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
    RouteImpl(this, orderSequence.getAndIncrement(), path);

  @override
  Route wb(String path) =>
    RouteImpl(this, orderSequence.getAndIncrement(), path,
      content: ContentType.WIDGET_BUILDER);

  @override
  Route string(String path) =>
    RouteImpl(
      this, orderSequence.getAndIncrement(), path, content: ContentType.STRING);

  @override
  Route dynamic(String path) =>
    RouteImpl(this, orderSequence.getAndIncrement(), path,
      content: ContentType.DYNAMIC);

  @override
  Route object(String path) =>
    RouteImpl(
      this, orderSequence.getAndIncrement(), path, content: ContentType.OBJECT);

  void add(RouteImpl route) {
    routes.add(route);
  }

  @override
  RoutingExecution<T> handle<T>(RoutingRequest request) => RoutingExecution<T>(RoutingContextImpl(null, this, request, routes));

  Iterator<RouteImpl> iterator() => routes.iterator;
}
