import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

class NavigatorCustomizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('White - simple'),
          onTap: () => RoutexNavigator.shared.push("/white", context),
        ),
        ListTile(
          title: Text('Green - delay'),
          onTap: () => RoutexNavigator.shared.push("/green", context),
        ),
        ListTile(
          title: Text('Blue - error'),
          onTap: () => RoutexNavigator.shared.push("/blue", context),
        ),
        ListTile(
          title: Text('Yellow'),
          onTap: () => RoutexNavigator.shared.push("invalid path", context),
        ),
      ],
    );
  }
}
