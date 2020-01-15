import 'package:daggerito/daggerito.dart';
import 'package:example/model/post_api.dart';
import 'package:example/model/user.dart';

class UserModule implements Module {
  final User _user;

  UserModule(this._user);

  @override
  void register(DependencyContainer container) {
    container.register((_) => _user);
    container.registerSingleton(($) => PostApi($()));
  }
}
