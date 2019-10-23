import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import '../model/countries_manager.dart';
import '../model/country.dart';

class CountriesScreen extends StatefulWidget {
  final CountriesManager _manager;

  CountriesScreen(this._manager);

  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  @override
  void initState() {
    super.initState();
    widget._manager.viewModel.start();
  }

  @override
  void dispose() {
    widget._manager.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchAppBar.appBar(context, widget._manager.sink.setTerm),
      body: Observer<List<CountryPresentation>>(
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
      ),
    );
  }
}

class CustomSearchAppBar {
  static SearchAppBar appBar(BuildContext context, Function(String) onChange){
    final AppBarController appBarController = AppBarController();
    return SearchAppBar(
      primary: Theme.of(context).primaryColor,
      appBarController: appBarController,
      // You could load the bar with search already active
      autoSelected: false,
      searchHint: "Search countries...",
      mainTextColor: Colors.white,
      onChange: onChange,
      mainAppBar: AppBar(
        title: Text("Countries"),
        actions: <Widget>[
          InkWell(
            child: Icon(
              Icons.search,
            ),
            onTap: () => appBarController.stream.add(true),
          ),
        ],
      ),
    );
  }
}
