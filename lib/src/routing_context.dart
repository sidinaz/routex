import 'package:routex/routex.dart';
import 'package:routex/src/route.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/routing_response.dart';

/// Represents the context for the handling of a request in Routex.
/// A new instance is created for each request that is received in the [Router.handle] of the router.
abstract class RoutingContext<E> {
  RoutingRequest request();

  RoutingResponse response();

  void next();

  String normalisedPath();

  bool failed();

  void fail(Object object);

  RoutingContext put(String key, dynamic obj);

  T get<T>(String key);

  Map<String, dynamic> data();

  T getParam<T>(String key);

  Map<String, dynamic> params();

  Object failure;

  int get statusCode;

  void reroute(String path);

  String mountPoint();

  Route currentRoute();
}
