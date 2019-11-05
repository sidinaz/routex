import 'dart:async';

abstract class Handler<E> {
  Future<void> handle(E context);
}
