import 'package:daggerito/daggerito.dart';
import 'package:example/di/test_module.dart';
import 'package:example/di/user_module.dart';
import 'package:example/model/user.dart';

import 'app_component.dart';

class UserComponent extends SubComponent {
  static final String key = "user_component";

  UserComponent(AppComponent appComponent, User user)
      : super(
          [appComponent],
          modules: [UserModule(user), TestModule(),
          ],
        );
}
