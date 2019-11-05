import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import '../model/countries_manager.dart';
import '../model/country.dart';

class SearchCountriesScreen extends StatefulWidget {
  final CountriesManager _manager;

  SearchCountriesScreen(this._manager);

  @override
  _SearchCountriesScreenState createState() => _SearchCountriesScreenState();
}

class _SearchCountriesScreenState extends State<SearchCountriesScreen> {
  _SearchCountriesSearchDelegate _searchDelegate;
  Widget _resultsWidget;

  @override
  void initState() {
    super.initState();
    widget._manager.viewModel.start();
    _searchDelegate = _SearchCountriesSearchDelegate(_clearAction, _buildResults);

  }

  @override
  void dispose() {
    widget._manager.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: showSearchScreen,
          ),
        ],
      ),
      body: Observer<List<CountryPresentation>>(
        stream: widget._manager.viewModel.selectedCountries,
        onSuccess: (ctx, items) => items.length > 0 ?  ListView.builder(
          itemBuilder: (context, index) =>
          Card(color: !items[index].isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
            child: ListTile(
              onTap: () => widget._manager.viewModel.handleSelection(model: items[index]),
              title: Text(items[index].name),
              trailing: IconButton(icon: Icon(Icons.arrow_forward),
                onPressed: () => RoutexNavigator.shared.push("/app/country-details", context, {"model" : items[index]})),
            ),
          ),
          itemCount: items.length,
        ) :
        _buildResults(context),
      ),
    );
  }

  void showSearchScreen(){
    showSearch(context: context, delegate: _searchDelegate, query: widget._manager.sink.term.value);
  }


  //search

  Widget _buildResults(BuildContext context,[String query]){
    if (query != null) {
    widget._manager.sink.setTerm(query);
    }

    return _resultsWidget ??= Observer<List<CountryPresentation>>(
      stream: widget._manager.viewModel.countries,
      onSuccess: (ctx, items) => ListView.builder(
        itemBuilder: (context, index) =>    Card(
          color: !items[index].isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).accentColor,
          child: ListTile(
            onTap: () => widget._manager.viewModel.handleSelection(model: items[index]),
            title: Text(items[index].name),
            trailing: IconButton(icon: Icon(Icons.arrow_forward),
              onPressed: () => RoutexNavigator.shared.push("/app/country-details", context, {"model" : items[index]})),
          ),
        ),
        itemCount: items.length,
      ),
    );
  }

void _clearAction(){
  widget._manager.sink.setTerm("");
}

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
