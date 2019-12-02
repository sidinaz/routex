import 'package:example/di/app_component.dart';
import 'package:example/di/user_module.dart';
import 'package:routex/routex.dart';

import '../di/user_component.dart';
import '../model/user.dart';

//
class UserComponentHandler implements Handler<RoutingContext> {
  static UserComponent _component;

  Future<UserComponent> _getComponent(
          AppComponent appComponent, User user) async =>
      _component ??= await UserComponent.create(appComponent, UserModule(user));

  @override
  Future<void> handle(RoutingContext context) async {
    var component = await _getComponent(
      context.get(AppComponent.key),
      context.get(User.key),
    );

    context.put(UserComponent.key, component);
    context.next();
  }
}
