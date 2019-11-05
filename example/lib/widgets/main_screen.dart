import 'package:flutter/material.dart';
import 'package:routex/routex.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _selectedIndex = 0;
  List<Widget> _tabs;

  @override
  void dispose() {
    print("MainScreen diposed");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabs = [
      RoutexNavigator.shared.get("/app/test/")(context),
//      RoutexNavigator.shared.get("/v1/app/countries/")(context),
      RoutexNavigator.shared.get("/app/countries/")(context),
      RoutexNavigator.shared.get("/app/examples/")(context),
    ];
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _tabs.elementAt(_selectedIndex),
      ),
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
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
