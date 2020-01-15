import 'package:example/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import '../widgets/countries_screen.dart';
import '../widgets/country_details.dart';

class CountriesController implements BaseController {
  @override
  void bindRouter(Router router) {
    router.route("/app/countries/").handler(countriesHandler);

    router.route("/app/countries/country-details").handler(countryDetails);
  }

  WidgetBuilder countriesHandler(RoutingContext context) =>
      (_) => context<CountriesScreen>();

  WidgetBuilder countryDetails(RoutingContext context) =>
      (_) => CountryDetailsScreen(context.getParam("model"));
}
