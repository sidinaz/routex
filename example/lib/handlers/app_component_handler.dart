import 'package:routex/routex.dart';
import '../di/app_component.dart';

class AppComponentHandler implements Handler<RoutingContext> {
  //every time each handler is executed, tips:
  //Your main components like AppComponent or UserComponent keep as singletons,
  //and any other component create every time when you request some route.
  static AppComponent _component;

  Future<AppComponent> _getComponent() async => _component ??= await AppComponent.create();

  @override
  Future<void> handle(RoutingContext context) async {
    var component = await _getComponent();
    context.put(AppComponent.key, component);
    context.next();
  }
}
