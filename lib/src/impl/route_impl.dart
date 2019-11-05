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

//
class RouteImpl implements Route {
  final RouterImpl _router;
  int order;
  bool enabled = true;

  String _path;
  final Set<ContentType> _contents = HashSet();
  bool exactPath;
  List<Handler<RoutingContext>> contextHandlers = [];
  List<Handler<RoutingContext>> failureHandlers = [];
  Pattern pattern;
  bool useNormalisedPath = true;
  List<String> groups;
  List<String> namedGroupsInRegex = [];

  RouteImpl(this._router, this.order,
      {String path, String regex, ContentType content}) {
    if (content != null) {
      _contents.add(content);
    }

    if (path != null) {
      checkPath(path);
      setPath(path);
    } else if (regex != null) {
      setRegex(regex);
    }
  }

  void setRegex(String regex) {
    pattern = RegExp(regex);
    List<String> namedGroups = findNamedGroups(regex);
    if (namedGroups.isNotEmpty) {
      namedGroupsInRegex.addAll(namedGroups);
    }
  }

  List<String> findNamedGroups(String path) {
    List<String> result = [];
    Pattern pattern = RegExp(r"\(\?<([a-zA-Z][a-zA-Z0-9]*)>");
    Iterable<Match> matches = pattern.allMatches(path);
    for (Match m in matches) result.add(m.group(1));

    return result;
  }

  // ignore: non_constant_identifier_names
  static final Pattern RE_OPERATORS_NO_STAR = RegExp(r"([\(\)\$\+\.])");

  // ignore: non_constant_identifier_names
  static final Pattern RE_TOKEN_SEARCH = RegExp(r":([A-Za-z][A-Za-z0-9_]*)");

  void createPatternRegex(String path) {
    path = path.replaceAllMapped(
        RE_OPERATORS_NO_STAR, (Match m) => "\\${m.group(1)}");

    if (path.codeUnitAt(path.length - 1) == '*'.codeUnitAt(0)) {
      path = path.substring(0, path.length - 1) + ".*";
    }

    //IZDVOJITI
    groups = [];
    int index = 0;
    path = path.replaceAllMapped(RE_TOKEN_SEARCH, (Match m) {
      String param = "p$index";
      String group = m.group(0).substring(1);
      if (groups.contains(group))
        throw Exception("Cannot use identifier " +
            group +
            " more than once in pattern string");

      groups.add(group);
      index++;
      return "(?<" + param + ">[^/]+)";
    });

    pattern = RegExp(path);
  }

  void checkPath(String path) {
    if (("" == path) || (path.codeUnitAt(0) != '/'.codeUnitAt(0)))
      throw IllegalArgumentException("Path must start with /");
  }

  void setPath(String path) {
    if (path.indexOf(':') != -1) {
      createPatternRegex(path);
      this._path = path;
    } else {
      if (path.codeUnitAt(path.length - 1) != '*'.codeUnitAt(0)) {
        exactPath = true;
        this._path = path;
      } else {
        exactPath = false;
        this._path = path.substring(0, path.length - 1);
      }
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
  String getPath() => _path;

  @override
  Route setRegexGroupsNames(List<String> groups) {
    this.groups = groups;
    return this;
  }

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

  bool matches(
      RoutingContextImplBase context, String mountPoint, bool failure) {
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

    if (_path != null && pattern == null && !pathMatches(mountPoint, context)) {
      return false;
    }

    if (pattern != null) {
      String path = useNormalisedPath
          ? context.normalisedPath()
          : context.request().path();
      if (mountPoint != null) {
        path = path.substring(mountPoint.length);
      }

      Iterable<Match> matches = pattern.allMatches(path);
      if (matches.isNotEmpty) {
        for (Match m in matches) {
          if (m.groupCount > 0) {
            if (groups != null) {
              groups.asMap().forEach((index, k) {
                String undecodedValue;
                try {
                  var key = namedGroupsInRegex.indexOf("p$index");
                  if (key != -1)
                    undecodedValue = m.group(key + 1);
                  else
                    undecodedValue = m.group(index + 1);
                } catch (error) {
                  undecodedValue = m.group(index + 1);
                }
                addPathParam(context, k, undecodedValue);
              });
            } else {
              namedGroupsInRegex.asMap().forEach((index, namedGroup) {
                final String namedGroupValue = m.group(index + 1);
                addPathParam(context, namedGroup, namedGroupValue);
              });

              for (int i = 0; i < m.groupCount; i++) {
                addPathParam(context, "param$i", m.group(i + 1));
              }
            }
          }
        }
      } else {
        return false;
      }
    }

    return true;
  }

  void addPathParam(RoutingContext context, String name, String value) {
    context.params()[name] = value;
  }

  bool pathMatches(String mountPoint, RoutingContext context) {
    String thePath = mountPoint == null ? _path : mountPoint + _path;
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
      throw "Function that creates widgetBuilder for: ${context.request().path()}\n is throwing error: $error";
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
      throw "Function that creates widget for: ${context.request().path()}\n is throwing error: $error";
    }
  }

  @override
  Future<void> handle(RoutingContext context) async {
    context.response().end((_) => _createWidget(context));
  }
}

typedef AsyncRoutingContextHandler = Future<void> Function(RoutingContext);
typedef SyncRoutingContextHandler = void Function(RoutingContext);
typedef WidgetBuilderNonVoidContextHandler = ui.WidgetBuilder Function(
    RoutingContext context);
typedef WidgetNonVoidContextHandler = ui.Widget Function(
    RoutingContext context);

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
//
  }
}
