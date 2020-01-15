import 'package:daggerito/daggerito.dart';
import 'package:example/config/config.dart';

class CommonModule implements Module {
  @override
  void register(DependencyContainer container) {
    container.registerSingleton((_) => Config());
  }
}
