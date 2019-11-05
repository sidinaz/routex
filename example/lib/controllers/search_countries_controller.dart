import 'package:routex/routex.dart';
import '../di/user_component.dart';
import '../model/country.dart';
import '../widgets/search_countries_screen.dart';
import '../widgets/country_details.dart';


class SearchCountriesController implements Controller {
  @override
  void bindRouter(Router router) {
    router
        .route("/app/countries/")
        .handler(countriesHandler);

    router
        .route("/app/country-details")
        .handler(countryDetails);
  }

  void countriesHandler(RoutingContext context) {
    var countriesManager = context.get<UserComponent>(UserComponent.key).getCountriesManager();
    context.response().end((bc) => SearchCountriesScreen(countriesManager));
  }

  void countryDetails(RoutingContext context) {
    var countryModel = context.getParam<CountryPresentation>("model");
    context.response().end((bc) => CountryDetailsScreen(countryModel));
  }
}


