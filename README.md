# Routex  
[![pub](https://img.shields.io/pub/v/routex?color=orange)](https://pub.dev/packages/routex) [![pub](https://img.shields.io/github/last-commit/sidinaz/routex)](https://pub.dev/packages/routex)  
 
Identify your logic with URI, apply any number of composable asynchronous or synchronous handlers using intuitive syntax and return anything as a result, all that with powerful and flexible error handling and testing.

## Routex in action
Example app has built in parallel with framework, and it has over 20+ examples, designed to show framework capabilities, composition, error handling, and RoutexNavigator - Routex consumer ready to use in your app.  

Each snippet in this document comes from example app:  

<img src="https://raw.githubusercontent.com/sidinaz/routex/master/documentation/images/routex_example_app.png" width="100%" />  

Try to notice relation between screens and code in example.dart file:  
```dart
void main() => runApp(AppWidget());

void bindRouter(Router router) {

  router.route("/*").handler(AppComponentHandler()); //basic app dependencies, available on app level

  router
    .route("/app/*") //each route that starts with /app/ requires authenthicated user, and user component for di
    .handler(AuthHandler(redirectTo: "/public/login")) //redirects to /public/login if user isn't presented.
    .handler((context) => context.put("sync_handler_between_two_asyncs", "Hello ${context.get<User>(User.key).name} :)").next())
    .handler(UserComponentHandler()); //creates user component

  router.route("/public/login").handler((context) =>
    context.response().end((_) => LoginScreen(context.get<AppComponent>(AppComponent.key).setUser)));

  router
    .route("/app/main")
  //.handler((context) => throw "Exceptions are propagated to failureHandlers or left to global error handlers.")
    .handler(mainScreen)
    .failureHandler((context) => context.response().end((_) =>
      Text("if some exception happens you can" +
          " continue contex with any number of failure handlers, you can show error screen or simply omit failureHandlers and propagate error to global error handlers.")));

  var testController = TestController();
  testController.bindRouter(router);

  var countriesController = CountriesController();
  countriesController.bindRouter(router);

  var examplesController = ExamplesController();
  examplesController.bindRouter(router);

  //Controller is just convinient way to group related routes and handlers, it doesn't have any other purpose
  //    abstract class Controller {
  //    void bindRouter(Router router);
  //    }
}

//equivalent of .handler((context) => context.response().end((_) => MainScreen()))
WidgetBuilder mainScreen(RoutingContext context) => (_) => MainScreen();

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //To support hot reload in development, use RoutexNavigator.newInstance() to ensure new instance on each reload
    //otherwise just use RoutexNavigator.shared and instance will be automatically created.
    bindRouter(RoutexNavigator.newInstance().router);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.instance,
      home: RoutexNavigator.shared.get("/app/main")(context),
    );
  }
}
``` 
Main app content:  
* Test tab shows how to start another screen for result using handler and ability to log out.  
* Countries tab gives you idea how to integrate Routex in your app with other code.  
* Examples tab shows usage of router directly with streams without RoutexNavigator (ExamplesController => ExamplesSource =>  ExamplesScreen)

### About
In handlers execute any code that can potentially change your main flow of execution or to get any dependencies and then create cleaner models to work with inherited widgets, streams pattern as you used to.

Idea for handling events in that way comes from [Vertx](https://vertx.io/).  
Routex in combination with dart and hot reload is worth of programmers attention.  
It's amazing experience if you are interested in flutter and mobile development.

The main part of Dart VM is an event loop. Independent pieces of code can register callback functions as event handlers for certain types of events.
Vertx also achieves that in Java environment with [Vertx event loop](https://vertx.io/docs/vertx-core/java/#_reactor_and_multi_reactor).  
See Routex in action, 8 concurrent request were executed to populate ListView widget in examples tab of example application(even if one request is irresponsible and in total two are left to you to fix it for practice).  
Typically one request is one screen but in Routex you can request for anything, not just screens-WidgetBuilder.

### Handlers
Handler can be anything of this:  
```dart
Handler<RoutingContext>
Future<void> Function(RoutingContext)
void Function(RoutingContext)
//last two are special cases, they are used as input for response.end(fn)
WidgetBuilder Function(RoutingContext context)
Widget Function(RoutingContext context)
```
Handler example:
```dart
class AuthHandler implements Handler<RoutingContext> {
  final String redirectTo;

  AuthHandler({this.redirectTo});

  @override
  Future<void> handle(RoutingContext context) async {
    //AppComponentHandler is handled before and here we use: context.get<AppComponent>(AppComponent.key)
    var appComponent = context.get<AppComponent>(AppComponent.key);
    Objects.requireNonNull(appComponent);

    User user = await appComponent.loadUser();

    if (user != null) {
      context.put(User.key, user);
      context.next();
    } else {
      if (redirectTo != null) {
        context.reroute(redirectTo);
      } else {
        context.fail(401);
      }
    }
  }
}
```
Handlers will be executed in exact order each time with every request, in this example AuthHandler consumes AppComponent provided by previously 
executed handler. It also puts user into context, and that user info is used in another handler.  
If something is wrong in app flow, it is possible to reroute request to another route, explicitly fail context, or
if some exception happens, work will continue in failure handlers for that route if any, or in global error handlers defined for router if any, or if nothing of that resolves error,
context will fail, and that error will be assigned to future associated with request.
That means that code executed inside handlers acts as a safe zone and cant be unhandled exceptions thrown.
[More](documentation)  
But is it possible to ever get unhandled exception while you are working with Routex?  
If you use async keywoard in void function, your handler will be treated as synchronous and any thrown exceptions will be unhandled,
it is possible in dart to await void functions but Routex doesn't use that approach for handlers case, avoid combination of void and async keyword, instead use Future<void>.
Also your route should always start with /.  
[Function that receives handler](#handlers) is very flexible.  
If you provide invalid handler that will be transmitted to handler that just fails with invalid argument exception,it is easier to debug in that way, so there is no unhandled exception in invalid handler case.  
Be aware that WidgetBuilder and Widget returning functions provided as handlers will be used as input for handler with
context.response().end(input) call, which is valid response in Routex.
 

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