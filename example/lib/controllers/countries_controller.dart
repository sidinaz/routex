import 'package:example/model/countries_manager.dart';
import 'package:routex/routex.dart';

import '../di/user_component.dart';
import '../model/country.dart';
import '../widgets/countries_screen.dart';
import '../widgets/country_details.dart';

class CountriesController implements Controller {
  @override
  void bindRouter(Router router) {
    router.route("/app/countries/").handler(countriesHandler);

    router.route("/app/country-details").handler(countryDetails);
  }

  void countriesHandler(RoutingContext context) {
    CountriesManager countriesManager =
        context.get<UserComponent>(UserComponent.key)();
    context.response().end((bc) => CountriesScreen(countriesManager));
  }

  void countryDetails(RoutingContext context) {
    var countryModel = context.getParam<CountryPresentation>("model");
    context.response().end((bc) => CountryDetailsScreen(countryModel));
  }
}
