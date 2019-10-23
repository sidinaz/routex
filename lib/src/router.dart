import 'package:routex/src/impl/router_impl.dart';
import 'package:routex/src/route.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/util/routing_execution.dart';

abstract class Router {
  static RouterImpl router() => RouterImpl();

  Route route(String path);

  Route wb(String path);

  Route string(String path);

  Route dynamic(String path);

  Route object(String path);

  RoutingExecution<T> handle<T>(RoutingRequest<T> request);

  Router errorHandler(int statusCode, Object errorHandler);
}
