import '../routing_context.dart';
import '../routing_request.dart';
import '../routing_response.dart';
import 'route_impl.dart';
import 'routing_context_impl_base.dart';

class RoutingContextWrapper extends RoutingContextImplBase {
  final RoutingContext inner;
  String _mountPoint;

  RoutingContextWrapper(String mountPoint, RoutingRequest request,
      Set<RouteImpl> iter, this.inner)
      : super(mountPoint, request, iter) {
    String parentMountPoint = inner.mountPoint();
    if (mountPoint.endsWith('/')) {
      // Remove the trailing slash or we won't match
      mountPoint = mountPoint.substring(0, mountPoint.length - 1);
    }
    this._mountPoint =
        parentMountPoint == null ? mountPoint : parentMountPoint + mountPoint;
  }

  @override
  void reroute(String path) => inner.reroute(path);

  @override
  int get statusCode => inner.statusCode;

  @override
  Map<String, dynamic> params() => inner.params();

  @override
  T getParam<T>(String key) => inner.getParam(key);

  @override
  Map<String, dynamic> data() => inner.data();

  @override
  T get<T>(String key) => inner.get(key);

  @override
  RoutingContext put(String key, dynamic obj) {
    inner.put(key, obj);
    return this;
  }

  @override
  void fail(Object object) => inner.fail(object);

  @override
  bool failed() => inner.failed();

  @override
  String normalisedPath() => inner.normalisedPath();

  @override
  void next() async {
    if (!(await super.iterateNext())) {
      inner.next();
    }
  }

  @override
  String mountPoint() => _mountPoint;

//implementation
  @override
  RoutingResponse response() => inner.response();
}
