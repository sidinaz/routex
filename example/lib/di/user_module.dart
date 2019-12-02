import 'package:daggerito/daggerito.dart';
import 'package:example/model/countries_manager.dart';
import 'package:example/model/country.dart';
import 'package:example/model/post_api.dart';
import 'package:example/model/user.dart';

class UserModule implements Module {
  final User _user;

  UserModule(this._user);

  @override
  void register(DependencyContainer container) {
    container.register((_) => getCountriesManager());
    container.register((_) => _user);
    container.registerSingleton(($) => PostApi($()));
  }

  CountriesManager getCountriesManager() {
    var sink = CountriesSink();
    var viewModel = CountriesViewModel(
      sink.term,
      Country.all,
      SelectionMode.multiSelect,
    );
    return CountriesManager(
      sink,
      viewModel,
    );
  }
}
