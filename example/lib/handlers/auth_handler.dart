import 'package:routex/routex.dart';
import '../di/app_component.dart';
import '../model/user.dart';

class AuthHandler implements Handler<RoutingContext> {
  final String redirectTo;

  AuthHandler({this.redirectTo});

  @override
  Future<void> handle(RoutingContext context) async {
    //AppComponentHandler is handled before and here we use result: context.get<AppComponent>(AppComponent.key)
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
