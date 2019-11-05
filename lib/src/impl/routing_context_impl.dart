import 'package:routex/src/exceptions/response_status_exception.dart';
import 'package:routex/src/handler.dart';
import 'package:routex/src/impl/route_impl.dart';
import 'package:routex/src/impl/router_impl.dart';
import 'package:routex/src/impl/routing_context_impl_base.dart';
import 'package:routex/src/impl/routing_request_impl.dart';
import 'package:routex/src/routing_context.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/routing_response.dart';
import 'package:routex/src/util/objects.dart';

class RoutingContextImpl extends RoutingContextImplBase {
  final RouterImpl router;
  final Map<String, dynamic> _data = Map<String, dynamic>();
  final Map<String, dynamic> _params;
  String _normalisedPath;

  @override
  int statusCode = (-1);

  @override
  Object failure;

  RoutingContextImpl(String mountPoint, this.router, RoutingRequest request,
      Set<RouteImpl> routes)
      : this._params = request.params(),
        this._normalisedPath = request.path(),
        super(mountPoint, request, routes) {
    if (request.path().length == 0) {
      fail(400);
    } else {
      if (request.path().codeUnitAt(0) != '/'.codeUnitAt(0)) {
        fail(404);
      }
    }
  }

  @override
  void fail(Object object) {
    if (object is int) {
      this.statusCode = object;
    } else if (Objects.cast<Error>(
            object, (error) => print(error.stackTrace)) !=
        null) {
      this.statusCode = -1;
      this.failure = object;
    } else if (Objects.cast<Exception>(object) != null) {
      this.statusCode = -1;
      this.failure = object;
    } else {
      this.statusCode = -1;
      this.failure = object;
    }
    doFail();
  }

  void doFail() {
    this.iter = router.iterator();
    currentroute = null;
    next();
  }

  @override
  bool failed() => failure != null || statusCode != -1;

  @override
  String normalisedPath() {
    if (_normalisedPath == null) {
      String path = request().path();
      if (path == null) {
        _normalisedPath = "/";
      } else {
        _normalisedPath = path;
      }
    }
    return _normalisedPath;
  }

  @override
  void next() async {
    if (!(await iterateNext())) {
      await checkHandleNoMatch();
    }
  }

  @override
  RoutingResponse response() => request().response();

  Future<void> checkHandleNoMatch() async {
    if (failed()) {
      //In this case we have correct route and handlers but no failureHandlers for that route,
      await unhandledFailure(statusCode, failure, router);
    } else {
      Handler<RoutingContext> handler = router.getErrorHandlerByStatusCode(404);
      if (handler == null) {
        // Default 404 handling
        this.response().fail(ResponseStatusException(404));
      } else {
        await handler.handle(this);
      }
    }
  }

  @override
  Map<String, dynamic> data() => _data;

  @override
  T get<T>(String key) => data()[key];

  @override
  RoutingContext put(String key, dynamic obj) {
    _data[key] = obj;
    return this;
  }

  @override
  Map<String, dynamic> params() => _params;

  @override
  T getParam<T>(String key) => params()[key];

  @override
  void reroute(String path) {
    (request() as BaseRequest).setPath(path);
    request().params().clear();
    // we need to reset the normalized path
    _normalisedPath = null;

    // we also need to reset any previous status
    statusCode = -1;
    failure = null;
    restart();
  }
}
