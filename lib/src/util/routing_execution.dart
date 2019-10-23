import 'package:routex/src/routing_context.dart';
import 'package:rxdart/rxdart.dart';

class RoutingExecution<T> {

  final RoutingContext _context;

  RoutingExecution(this._context);

  Future<T> asFuture() {
    _context.next();
    return _context.response().materialize();
  }

  Observable<T> asStream() => Observable.fromFuture(asFuture());
}