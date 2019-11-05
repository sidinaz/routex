import 'package:routex/src/exceptions/illegal_argument_exception.dart';
import 'package:routex/src/exceptions/response_status_exception.dart';
import 'package:routex/src/handler.dart';
import 'package:routex/src/impl/route_impl.dart';
import 'package:routex/src/impl/router_impl.dart';
import 'package:routex/src/route.dart';
import 'package:routex/src/routing_context.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/util/atomic_integer.dart';

abstract class RoutingContextImplBase extends RoutingContext {
  final Set<RouteImpl> routes;
  final RoutingRequest _request;

  Iterator<RouteImpl> iter;
  final String _mountPoint;
  RouteImpl currentroute;
  AtomicInteger _currentRouteNextHandlerIndex;
  AtomicInteger _currentRouteNextFailureHandlerIndex;

  RoutingContextImplBase(
    this._mountPoint,
    this._request,
    this.routes,
  ) : this.iter = routes.iterator {
    _currentRouteNextHandlerIndex = new AtomicInteger();
    _currentRouteNextFailureHandlerIndex = new AtomicInteger();
  }

  String mountPoint() => _mountPoint;

  @override
  Route currentRoute() => currentroute;

  int currentRouteNextHandlerIndex() =>
      _currentRouteNextHandlerIndex.intValue();

  int currentRouteNextFailureHandlerIndex() =>
      _currentRouteNextFailureHandlerIndex.intValue();

  void restart() {
    this.iter = routes.iterator;
    currentroute = null;
    next();
  }

  @override
  RoutingRequest request() => _request;

  Future<bool> iterateNext() async {
    bool _failed = failed();
    if (currentroute != null) {
      try {
        if ((!_failed) && currentroute.hasNextContextHandler(this)) {
          _currentRouteNextHandlerIndex.incrementAndGet();
          await currentroute.handleContext(this);
          return true;
        } else {
          if (_failed && currentroute.hasNextFailureHandler(this)) {
            _currentRouteNextFailureHandlerIndex.incrementAndGet();
            await currentroute.handleFailure(this);
            return true;
          }
        }
      } catch (t) {
        if (!_failed) {
          fail(t);
        } else {
          await unhandledFailure(-1, t, currentroute.router());
        }
        return true;
      }
    }
    while (iter.moveNext()) {
      RouteImpl route = iter.current;
      _currentRouteNextHandlerIndex.set(0);
      _currentRouteNextFailureHandlerIndex.set(0);
      try {
        if (route.matches(this, mountPoint(), _failed)) {
          try {
            currentroute = route;
            if (_failed && currentroute.hasNextFailureHandler(this)) {
              _currentRouteNextFailureHandlerIndex.incrementAndGet();
              await route.handleFailure(this);
            } else if (currentroute.hasNextContextHandler(this)) {
              _currentRouteNextHandlerIndex.incrementAndGet();
              await route.handleContext(this);
            } else {
              continue;
            }
          } catch (t) {
            if (!_failed) {
              fail(t);
            } else {
              await unhandledFailure(-1, t, route.router());
            }
          }
          return true;
        }
      } catch (e) {
        if (!this.response().ended())
          await unhandledFailure(
              (e is IllegalArgumentException) != null ? 400 : -1,
              e,
              route.router());
        return true;
      }
    }
    return false;
  }

  Future<void> unhandledFailure(
      int statusCode, Object failure, RouterImpl router) async {
    int code = statusCode != -1 ? statusCode : 500;

    Handler<RoutingContext> errorHandler =
        router.getErrorHandlerByStatusCode(code);
    if (errorHandler == null) {
      this.response().fail(ResponseStatusException(code, failure));
    } else {
      await errorHandler.handle(this);
    }
  }
}
