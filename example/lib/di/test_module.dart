import 'package:daggerito/daggerito.dart';
import 'package:example/widgets/test_screens.dart';

class TestModule implements Module{

  @override
  void register(DependencyContainer container) {
    container.register(($) => TestStartScreen($()));
  }
}