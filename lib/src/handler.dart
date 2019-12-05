import 'dart:async';

/// A generic event handler.
abstract class Handler<E> {
  /// Something has happened, so handle it.
  /// [context] the event to handle
  Future<void> handle(E context);
}
