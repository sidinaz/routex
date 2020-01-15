import 'package:daggerito/daggerito.dart';
import 'package:example/controllers/posts/posts_manager.dart';
import 'package:example/controllers/posts/posts_screen_with_slider.dart';
import 'package:example/model/countries_manager.dart';
import 'package:example/model/country.dart';
import 'package:example/widgets/countries_screen.dart';
import 'package:example/widgets/search_countries_screen.dart';

class CountriesModule implements Module {
  @override
  void register(DependencyContainer container) {
    container.registerSingleton((_) => getCountriesManager());
    container.register(($) => CountriesScreen($()));
    container.register(($) => SearchCountriesScreen($()));
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
