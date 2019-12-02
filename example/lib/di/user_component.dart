import 'package:daggerito/daggerito.dart';
import 'package:example/di/user_module.dart';

import 'app_component.dart';

class UserComponent extends SubComponent {
  static final String key = "user_component";

  UserComponent._(AppComponent appComponent, UserModule userModule)
      : super(
          [appComponent],
          modules: [userModule],
        );

  static Future<UserComponent> create(
    AppComponent appComponent,
    UserModule userModule,
  ) async =>
      UserComponent._(
        appComponent,
        userModule,
      );
}
