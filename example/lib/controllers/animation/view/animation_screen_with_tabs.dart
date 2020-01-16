import 'package:example/base/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:routex/routex.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class AnimationScreenWithTabs extends BaseView {
  final List<WidgetBuilder> tabsWbs;
  _Fields fields;

  AnimationScreenWithTabs(this.tabsWbs);

  @override
  void handleManagedFields() {
    final context = useContext();
    fields = managedField(() => _Fields(context, tabsWbs));
  }

  Widget buildWidget(BuildContext context) => Observer<int>(
        stream: fields.selectedTab,
        onSuccess: (ctx, selectedTab) => Scaffold(
            body: fields.tabs[selectedTab],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  title: Text("Stateful"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  title: Text("Hook"),
                ),
              ],
              currentIndex: selectedTab,
              selectedItemColor: Theme.of(context).accentColor,
              onTap: _onItemTapped,
            )),
      );

  void _onItemTapped(int value) {
    fields.selectedTab.add(value);
  }
}

class _Fields {
  final List<Widget> tabs;

  // ignore: close_sinks
  final selectedTab = BehaviorSubject.seeded(0);

  _Fields(BuildContext context, List<WidgetBuilder> tabsWbs)
      : this.tabs = tabsWbs
            .map((wb) => wb(context))
            .toList() {
    print(this.tabs);
  }
}
