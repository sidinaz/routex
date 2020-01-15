import 'package:example/base/view.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import '../model/countries_manager.dart';
import '../model/country.dart';

// ignore: must_be_immutable
class CountriesScreen extends BaseView {
  final CountriesManager manager;
  @override
  get model => manager.viewModel;

  CountriesScreen(this.manager);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchAppBar.appBar(context, manager.sink.setTerm),
      body: Observer<List<CountryPresentation>>(
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
