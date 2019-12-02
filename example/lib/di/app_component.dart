import 'package:daggerito/daggerito.dart';
import 'package:example/di/net_module.dart';

import '../model/user.dart';
import 'common_module.dart';

class AppComponent extends Component {
  static final String key = "app_component";
  User _user;

  AppComponent._(
    CommonModule commonModule,
    NetModule netModule,
  ) : super(
          modules: [
            commonModule,
            netModule,
          ],
        );

  static Future<AppComponent> create(
    CommonModule commonModule,
    NetModule netModule,
  ) async {
    //initialize component which contains container
    var appComponent = AppComponent._(
      commonModule,
      netModule,
    );

    Future<User> userFuture = appComponent();

    appComponent.setUser(await userFuture);

    return appComponent;
  }

  setUser(User value) => _user = value;

  User getUser() => _user;
}
