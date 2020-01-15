import 'package:example/base/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:routex/routex.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class MainScreen extends BaseView {
  _Fields fields;
  
  @override
  void handleManagedFields() {
    final context = useContext();
    fields = managedField(() => _Fields(context));
  }

  @override
  Widget buildWidget(BuildContext context) =>
    Observer<int>(
      stream: fields.selectedTab,
      onSuccess: (ctx, selectedTab) => Scaffold(
        body: fields.tabs[fields.selectedTab.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Test"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              title: Text("Countries"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sentiment_satisfied),
              title: Text("Examples"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              title: Text("Posts"),
            ),
          ],
          currentIndex: selectedTab,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: _onItemTapped,
        )
      ),
    );

  void _onItemTapped(int value) {
    fields.selectedTab.add(value);
  }
}

class _Fields{
  final List<Widget> tabs;
  // ignore: close_sinks
  final selectedTab = BehaviorSubject.seeded(0);
  _Fields(BuildContext context):this.tabs = [
    RoutexNavigator.shared.get("/app/test/")(context),
//    RoutexNavigator.shared.get("/v1/app/countries/")(context),
    RoutexNavigator.shared.get("/app/countries/")(context),
    RoutexNavigator.shared.get("/app/examples/")(context),
    RoutexNavigator.shared.get("/app/posts/")(context),
  ];
}