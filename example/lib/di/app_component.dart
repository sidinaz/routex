import 'package:daggerito/daggerito.dart';
import 'package:example/di/net_module.dart';

import 'common_module.dart';

class AppComponent extends Component {
  static final String key = "app_component";

  AppComponent._()
      : super(
          modules: [
            CommonModule(),
            NetModule(),
          ],
        );

  static Future<AppComponent> create() async => AppComponent._();
}
