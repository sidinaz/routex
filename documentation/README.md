About this document
========
Each important topic will have it's own page in this documentation folder.

Documentation will cover example app, for now watch in code comments, documentation should be finished in first half of November.

# Basics
This is just short mention of some core functionalities implemented in detail in example app.

1. [Routing](#routing)
1. [Composing asynchronous and synchronous events](#composing-asynchronous-and-synchronous-events)
1. [Error handling](#error-handling)

## Routing

Routing by exact path
```dart
router
.route("/app/main")...
```

Routing by paths that begin with something
```dart
router
.route("/app/*")...
```

## Composing asynchronous and synchronous events
Define any number of asynchronous or synchronous handlers for given route.
```dart
  router.route("/*").handler(AppComponentHandler()); //basic app dependencies, available on app level

  router
    .route("/app/*") //each route that starts with /app/ requires authenthicated user, and user component for di
    .handler(AuthHandler(redirectTo: "/public/login")) //redirects to /public/login if user isn't presented.
    .handler((context) => context.put("sync_handler_between_two_asyncs", "Hello ${context.get<User>(User.key).name} :)").next())
    .handler(UserComponentHandler()); //creates user component

  router.route("/public/login").handler((context) =>
    context.response().end((_) => LoginScreen(context.get<AppComponent>(AppComponent.key).setUser)));
```

## Error handling
Look at example app for many detailed examples of controlling exceptions, by catching and propagating it, or explicitly failing context with context.fail(...).
```dart
router
    .route("/app/main")
  //.handler((context) => throw "Exceptions are propagated to failureHandlers or left to global error handlers.")
    .handler(mainScreen)
    .failureHandler((context) =>
    context.response().end((_) =>
      Text("if some exception happens you can" +
          " continue contex with any number of failure handlers, you can show error screen or simply omit failureHandlers and propagate error to global error handlers.")));

router.errorHandler(404, (context) => context.response().end(_errorScreen(ResponseStatusException(404))));
router.errorHandler(500, (context) => context.response().end(_errorScreen(ResponseStatusException(500, context.failure))));
```

## Routex core
In Routex, Router is core part.  
It keeps all routes organized, which can have associated handlers to execute requests.
Routex associate logic to uri-path, so we can request to anything and get that.
That is useful for testing specially, we can build app against and test response against string or any other type 
and when we have our screen we can then use WidgetBuilder.
Routex have single consumer named [RoutexNavigator](#routexnavigator).

### RoutexNavigator
RoutexNavigator is wrapper for interacting with Router, it is place for defining any custom FutureBuilder, error screen, global error handlers, it always use WidgetBuilder as request type, see example app.  
It main method is get -> WidgetBuilder, and once that we have WidgetBuilder, we just use Material's Navigator for actions.
It's highly customizable, as seen in snippet below:  
```dart
  Future<T> push<T extends Object>(String path, BuildContext context, [Map<String, dynamic> params]) =>
    Navigator.push(context, MaterialPageRoute(builder: asWidgetBuilder(path, params)));

  Future<T> pushReplacement<T extends Object>(String path, BuildContext context, [Map<String, dynamic> params]) =>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: asWidgetBuilder(path, params)));

  Future<T> replaceRoot<T extends Object>(String path, BuildContext context, [Map<String, dynamic> params]) =>
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: asWidgetBuilder(path, params)), (_) => false,);

  Future<WidgetBuilder> asWidgetBuilderFuture(String path, [Map<String, dynamic> params]) =>
    _router.handle(BaseRequest<WidgetBuilder>(path, params: params)).asFuture();

  WidgetBuilder asWidgetBuilder(String path, [Map<String, dynamic> params]) =>
      (ctx) => _futureObserver(asWidgetBuilderFuture(path, params));

  WidgetBuilder get(String path, [Map<String, dynamic> params]) =>
    asWidgetBuilder(path, params);

  Observable<WidgetBuilder> asWidgetBuilderStream(String path, [Map<String, dynamic> params]) =>
    Observable.fromFuture(asWidgetBuilderFuture(path, params));
  
  router.errorHandler(404, (context) => context.response().end(_errorScreen(ResponseStatusException(404))));
  router.errorHandler(500, (context) => context.response().end(_errorScreen(ResponseStatusException(500, context.failure))));
  
  Widget _futureObserver(Future<WidgetBuilder> wb) =>
      futureBuilder != null ?
      futureBuilder(wb) :
      FutureObserver<WidgetBuilder>(
        future: wb,
        onSuccess: (ctx, widget) => widget(ctx),
      );
  
  WidgetBuilder Function(ResponseStatusException) _errorScreen;
  
  Widget Function(Future<WidgetBuilder> wb) futureBuilder;
 ```