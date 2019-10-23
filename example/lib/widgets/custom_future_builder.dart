import 'package:flutter/material.dart';

class CustomFutureBuilder extends StatelessWidget {
  final Future<WidgetBuilder> _calculation;

  CustomFutureBuilder(this._calculation);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WidgetBuilder>(
      future: _calculation, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<WidgetBuilder> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('CustomFutureBuilder: Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('CustomFutureBuilder: Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('CustomFutureBuilder: Error: ${snapshot.error}');
            return snapshot.data(context);
        }
        return null; // unreachable
      },
    );
  }
}
