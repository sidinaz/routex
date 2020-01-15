import 'package:example/di/app_component.dart';
import 'package:example/di/user_module.dart';
import 'package:routex/routex.dart';

import '../di/user_component.dart';
import '../model/user.dart';

class UserComponentHandler implements Handler<RoutingContext> {
  static UserComponent _component;

  @override
  Future<void> handle(RoutingContext context) async {
    User user;

    if(context.params().containsKey(User.key)){
      user = context.getParam(User.key);
      if(user != null){
        _component = UserComponent(context.get(AppComponent.key), user);
      }
    }

    context.put(UserComponent.key, _component);
    context.next();
  }
}
