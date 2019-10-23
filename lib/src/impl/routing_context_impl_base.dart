import 'package:routex/src/exceptions/illegal_argument_exception.dart';
import 'package:routex/src/exceptions/response_status_exception.dart';
import 'package:routex/src/handler.dart';
import 'package:routex/src/impl/route_impl.dart';
import 'package:routex/src/impl/router_impl.dart';
import 'package:routex/src/routing_context.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/util/atomic_integer.dart';

abstract class RoutingContextImplBase extends RoutingContext {
  final Set<RouteImpl> routes;
  final RoutingRequest _request;

  Iterator<RouteImpl> iter;
  final String _mountPoint;
  RouteImpl currentRoute;
  AtomicInteger _currentRouteNextHandlerIndex;
  AtomicInteger _currentRouteNextFailureHandlerIndex;

  RoutingContextImplBase(this.routes, this._mountPoint, this._request)
    : this.iter = routes.iterator {
    _currentRouteNextHandlerIndex = new AtomicInteger();
    _currentRouteNextFailureHandlerIndex = new AtomicInteger();
  }

  String mountPoint() => _mountPoint;


  int currentRouteNextHandlerIndex() =>
    _currentRouteNextHandlerIndex.intValue();

  int currentRouteNextFailureHandlerIndex() =>
    _currentRouteNextFailureHandlerIndex.intValue();

  void restart() {
    this.iter = routes.iterator;
    currentRoute = null;
    next();
  }

  @override
  RoutingRequest request() => _request;

  Future<bool> iterateNext() async {
    bool failedd = failed();
    if (currentRoute != null) {
      try {
        if ((!failedd) && currentRoute.hasNextContextHandler(this)) {
          _currentRouteNextHandlerIndex.incrementAndGet();
          await currentRoute.handleContext(this);
          return true;
        } else {
          if (failedd && currentRoute.hasNextFailureHandler(this)) {
            _currentRouteNextFailureHandlerIndex.incrementAndGet();
            await currentRoute.handleFailure(this);
            return true;
          }
        }
      } catch (t) {
        if (!failedd) {
          fail(t);
        } else {
          await unhandledFailure(-1, t, currentRoute.router());
        }
        return true;
      }
    }
    while (iter.moveNext()) {
      RouteImpl route = iter.current;
      _currentRouteNextHandlerIndex.set(0);
      _currentRouteNextFailureHandlerIndex.set(0);
      try {
        if (route.matches(this, mountPoint(), failedd)) {
          try {
            currentRoute = route;
            if (failedd && currentRoute.hasNextFailureHandler(this)) {
              _currentRouteNextFailureHandlerIndex.incrementAndGet();
              await route.handleFailure(this);
            } else if (currentRoute.hasNextContextHandler(this)) {
              _currentRouteNextHandlerIndex.incrementAndGet();
              await route.handleContext(this);
            } else {
              continue;
            }
          } catch (t) {
            if (!failedd) {
              fail(t);
            } else {
              await unhandledFailure(-1, t, route.router());
            }
          }
          return true;
        }
      } catch (e) {
        if (!this.response().ended())
          await unhandledFailure((e as IllegalArgumentException) != null ? 400 : -1, e, route.router());
        return true;
      }
    }
    return false;
  }

  Future<void> unhandledFailure(int statusCode, Object failure,
    RouterImpl router) async {
    int code = statusCode != -1 ? statusCode : 500;

    Handler<RoutingContext> errorHandler = router.getErrorHandlerByStatusCode(
      code);
    if (errorHandler == null) {
      this.response().fail(ResponseStatusException(code, failure));
    } else {
      await errorHandler.handle(this);
    }
  }
}
