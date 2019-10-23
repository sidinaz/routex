import 'dart:async';

import 'package:routex/src/routing_response.dart';

class BaseResponse<T> implements RoutingResponse<T> {
  Completer<T> _completer = Completer();

  void end(T model) {
    _completer.complete(model);
  }

  void fail(Object error) {
    if (!ended()) {
      _completer.completeError(error);
    }
  }

  @override
  bool ended() => _completer.isCompleted;

  Future<T> materialize() {
    var future = _completer.future;
    return future;
  }
}