import '../model/countries_manager.dart';
import '../model/country.dart';
import '../model/user.dart';

class UserComponent{
  static final String key = "user_component";
  final User user;

  UserComponent._(this.user);

static Future<UserComponent> create(User user) async => UserComponent._(user);
  CountriesManager getCountriesManager(){
    var sink = CountriesSink();
    var viewModel = CountriesViewModel(sink.term,Country.all,SelectionMode.multiSelect);
    return CountriesManager(sink, viewModel);
  }
}