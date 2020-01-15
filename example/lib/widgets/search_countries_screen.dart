import 'package:example/base/view.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import '../model/countries_manager.dart';
import '../model/country.dart';

// ignore: must_be_immutable
class SearchCountriesScreen extends BaseView {
  final CountriesManager manager;
  _Fields fields;
  @override
  get model => manager.viewModel;

  SearchCountriesScreen(this.manager);

  @override
  void handleManagedFields() {
    fields = managedField(() => _Fields(_SearchCountriesSearchDelegate(_clearAction, _buildResults)));
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Countries'),
        actions: <Widget>[
          //Adding the search widget in AppBar
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            //Don't block the main thread
            onPressed: () => showSearchScreen(context),
          ),
        ],
      ),
      body: Observer<List<CountryPresentation>>(
        stream: manager.viewModel.selectedCountries,
        onSuccess: (ctx, items) => items.length > 0 ?  ListView.builder(
          itemBuilder: (context, index) =>
          Card(color: !items[index].isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
            child: ListTile(
              onTap: () => manager.viewModel.handleSelection(model: items[index]),
              title: Text(items[index].name),
              trailing: IconButton(icon: Icon(Icons.arrow_forward),
                onPressed: () => RoutexNavigator.shared.push("/app/countries/country-details", context, {"model" : items[index]})),
            ),
          ),
          itemCount: items.length,
        ) :
        _buildResults(context),
      ),
    );
  }

  void showSearchScreen(BuildContext context){
    showSearch(context: context, delegate: fields._delegate, query: manager.sink.term.value);
  }


  //search

  Widget _buildResults(BuildContext context,[String query]){
    if (query != null) {
    manager.sink.setTerm(query);
    }

    return Observer<List<CountryPresentation>>(
      stream: manager.viewModel.countries,
      onSuccess: (ctx, items) => ListView.builder(
        itemBuilder: (context, index) =>    Card(
          color: !items[index].isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).accentColor,
          child: ListTile(
            onTap: () => manager.viewModel.handleSelection(model: items[index]),
            title: Text(items[index].name),
            trailing: IconButton(icon: Icon(Icons.arrow_forward),
              onPressed: () => RoutexNavigator.shared.push("/app/countries/country-details", context, {"model" : items[index]})),
          ),
        ),
        itemCount: items.length,
      ),
    );
  }

void _clearAction(){
  manager.sink.setTerm("");
}
}

class _Fields{
  final _SearchCountriesSearchDelegate _delegate;

  _Fields(this._delegate);

}

class _SearchCountriesSearchDelegate extends  SearchDelegate<List<CountryPresentation>> {
  final Function _clearAction;
  final Widget Function(BuildContext,String) _buildResults;


  _SearchCountriesSearchDelegate(this._clearAction,
    this._buildResults); // SearchDelegate implementation

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          _clearAction();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildResults(context, query);

  @override
  Widget buildSuggestions(BuildContext context) => _buildResults(context, query);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryTextTheme: theme.textTheme,
    );
  }

}
