import 'package:daggerito/daggerito.dart';
import 'package:example/model/user.dart';

class CommonModule implements Module {
  Future<User> _loadUser() =>
      Future.delayed(Duration(milliseconds: 200), () => User("Flutter"));

  @override
  void register(DependencyContainer container) {
    container.register((_) => _loadUser());
  }
}
