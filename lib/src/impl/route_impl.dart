import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart' as ui;
import 'package:routex/src/content_type.dart';
import 'package:routex/src/exceptions/illegal_argument_exception.dart';
import 'package:routex/src/handler.dart';
import 'package:routex/src/impl/router_impl.dart';
import 'package:routex/src/impl/routing_context_impl_base.dart';
import 'package:routex/src/route.dart';
import 'package:routex/src/routing_context.dart';
import 'package:routex/src/routing_request.dart';


class RouteImpl implements Route {
  final RouterImpl _router;
  int order;
  bool useNormalisedPath = true;
  bool enabled = true;

  List<Handler<RoutingContext>> contextHandlers = [];
  List<Handler<RoutingContext>> failureHandlers = [];
  String _path;
  bool exactPath;
  final Set<ContentType> _contents = HashSet();

  RouteImpl(this._router, this.order, String path, {ContentType content}) {
    if (content != null) {
      _contents.add(content);
    }
    checkPath(path);
    setPath(path);
  }

  void checkPath(String path) {
    if (("" == path) || (path.codeUnitAt(0) != '/'.codeUnitAt(0))) {
      throw new IllegalArgumentException("Path must start with /");
    }
  }

  void setPath(String path) {
    if (path.codeUnitAt(path.length - 1) != '*'.codeUnitAt(0)) {
      exactPath = true;
      this._path = path;
    } else {
      exactPath = false;
      this._path = path.substring(0, path.length - 1);
    }
  }

  bool added = false;

  void checkAdd() {
    if (!added) {
      _router.add(this);
      added = true;
    }
  }

  @override
  Route handler(Object handler) {
    this.contextHandlers.add(Action(handler));
    checkAdd();
    return this;
  }


  @override
  Route content(ContentType content) {
    _contents.add(content);
    return this;
  }


  @override
  Set<ContentType> contents() => _contents;

  @override
  Route failureHandler(Object handler) {
    this.failureHandlers.add(Action(handler));
    checkAdd();
    return this;
  }

  @override
  String toString() =>
    'RouteImpl{router: $_router, order: $order, contextHandlers: $contextHandlers, failureHandlers: $failureHandlers, path: $_path, exactPath: $exactPath, added: $added}';

//implements Route
  bool hasNextContextHandler(RoutingContextImplBase context) =>
    context.currentRouteNextHandlerIndex() < contextHandlers.length;

  bool hasNextFailureHandler(RoutingContextImplBase context) =>
    context.currentRouteNextFailureHandlerIndex() < failureHandlers.length;

  RouterImpl router() => _router;

  Future<void> handleContext(RoutingContextImplBase context) async {
    Handler<RoutingContext> contextHandler;

    var currentRouteNextHandlerIndex =
      context.currentRouteNextHandlerIndex() - 1;
    contextHandler = contextHandlers[currentRouteNextHandlerIndex];
    await contextHandler.handle(context);
  }

  Future<void> handleFailure(RoutingContextImplBase context) async {
    Handler<RoutingContext> failureHandler;
    failureHandler =
    failureHandlers[context.currentRouteNextFailureHandlerIndex() - 1];
    await failureHandler.handle(context);
  }

  bool matches(RoutingContextImplBase context, String mountPoint,
    bool failure) {
    if ((failure && (!hasNextFailureHandler(context))) ||
      ((!failure) && (!hasNextContextHandler(context)))) {
      return false;
    }

    if (!enabled) {
      return false;
    }

    RoutingRequest request = context.request();
    if (_contents.isNotEmpty && !_contents.contains(request.content())) {
      return false;
    }
    if ((_path != null) && (!pathMatches(mountPoint, context))) {
      return false;
    }

    return true;
  }

  bool pathMatches(String mountPoint, RoutingContext context) {
    String thePath = ((mountPoint == null) ? _path : (mountPoint + _path));
    String requestPath;
    if (useNormalisedPath) {
      requestPath = context.normalisedPath();
    } else {
      requestPath = context.request().path();
      if (requestPath == null) {
        requestPath = "/";
      }
    }
    if (exactPath) {
      return pathMatchesExact(requestPath, thePath);
    } else {
      if (thePath.endsWith("/") && (requestPath == removeTrailing(thePath))) {
        return true;
      }
      return requestPath.startsWith(thePath);
    }
  }

  bool pathMatchesExact(String path1, String path2) {
    return removeTrailing(path1) == removeTrailing(path2);
  }

  String removeTrailing(String path) {
    int i = path.length;
    if (path.codeUnitAt(i - 1) == '/'.codeUnitAt(0)) {
      path = path.substring(0, i - 1);
    }
    return path;
  }
}

//
class _AsyncAction implements Action {
  final Future<void> Function(RoutingContext context) _handler;

  _AsyncAction(this._handler);

  @override
  Future<void> handle(RoutingContext context) async {
    await _handler(context);
  }
}

class _AsyncActionImpl implements Action {
  final Handler<RoutingContext> _handler;

  _AsyncActionImpl(this._handler);

  @override
  Future<void> handle(RoutingContext context) async {
    await _handler.handle(context);
  }
}

class _SyncAction implements Action {
  final void Function(RoutingContext context) _handler;

  _SyncAction(this._handler);

  @override
  Future<void> handle(RoutingContext context) async {
    _handler(context);
  }
}

class _WidgetBuilderNonVoidAction implements Action {
  final ui.WidgetBuilder Function(RoutingContext context) _handler;

  _WidgetBuilderNonVoidAction(this._handler);

  ui.WidgetBuilder _createWidgetBuilder(RoutingContext context) {
    try {
      return _handler(context);
    } catch (error) {
      throw "Function that creates widgetBuilder for: ${context.request()
        .path()}\n is throwing error: $error";
    }
  }

  @override
  Future<void> handle(RoutingContext context) async {
    context.response().end(_createWidgetBuilder(context));
  }
}

class _WidgetNonVoidAction implements Action {
  final ui.Widget Function(RoutingContext context) _handler;

  _WidgetNonVoidAction(this._handler);

  ui.Widget _createWidget(RoutingContext context) {
    try {
      return _handler(context);
    } catch (error) {
      throw "Function that creates widget for: ${context.request()
        .path()}\n is throwing error: $error";
    }
  }

  @override
  Future<void> handle(RoutingContext context) async {
    context.response().end((_) => _createWidget(context));
  }
}

typedef AsyncRoutingContextHandler = Future<void> Function(RoutingContext);
typedef SyncRoutingContextHandler = void Function(RoutingContext);
typedef WidgetBuilderNonVoidContextHandler = ui.WidgetBuilder Function(RoutingContext context);
typedef WidgetNonVoidContextHandler = ui.Widget Function(RoutingContext context);

abstract class Action implements Handler<RoutingContext> {
  factory Action(Object handler) {
    if (handler is AsyncRoutingContextHandler) {
      return _AsyncAction(handler);
    } else if (handler is WidgetBuilderNonVoidContextHandler) {
      return _WidgetBuilderNonVoidAction(handler);
    } else if (handler is WidgetNonVoidContextHandler) {
      return _WidgetNonVoidAction(handler);
    } else if (handler is SyncRoutingContextHandler) {
      return _SyncAction(handler);
    } else if (handler is Handler<RoutingContext>) {
      return _AsyncActionImpl(handler);
    }
    return _SyncAction((context) =>
      context.fail(IllegalArgumentException("Check your handler: $handler")));
  }
}
