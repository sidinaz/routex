import 'package:routex/routex.dart';
import '../di/user_component.dart';
import '../model/user.dart';

class UserComponentHandler implements Handler<RoutingContext> {
  static UserComponent _component;

  Future<UserComponent> _getComponent(User user) async => _component != null
      ? _component
      : _component = await UserComponent.create(user);

  @override
  Future<void> handle(RoutingContext context) async {
    User user = context.get(User.key);
    var component = await _getComponent(user);
    context.put(UserComponent.key, component);
    context.next();
  }
}
