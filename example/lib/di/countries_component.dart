import 'package:daggerito/daggerito.dart';

import 'countries_module.dart';
import 'user_component.dart';

class CountriesComponent extends SubComponent {
  CountriesComponent(
    UserComponent userComponent,
  ) : super(
          [userComponent],
          modules: [CountriesModule()],
        );
}
