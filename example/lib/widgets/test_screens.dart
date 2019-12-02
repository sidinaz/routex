import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

class TestStartScreen extends StatelessWidget {
  final Function logoutAction;

  TestStartScreen({this.logoutAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(child: Text("Test for result",style: Theme.of(context).textTheme.body1),
          onPressed: () => RoutexNavigator.shared.push("/app/test/result", context, { "build_context": context}),
        ),
        RaisedButton(child:
        Text("Log out", style: Theme.of(context).textTheme.body1),
          onPressed: logoutAction,
          color: Theme.of(context).primaryColor,
        ),
      ],
    ),);
  }
}

class TestResultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.done_outline, size: 50,color:Theme.of(context).primaryColor),
    );
  }
}

class TestFailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.remove_circle_outline, size: 50, color: Theme.of(context).primaryColor,),
    );
  }
}

class TestClickForSuccessBackForFailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child:
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Text("Press for success or back for failure",style: Theme.of(context).textTheme.body1),
        SizedBox(
          height: 20,
        ),
        RaisedButton(child: Text("Ok",style: Theme.of(context).textTheme.body1),
          onPressed: () => Navigator.pop(context, 200),
        )
      ]
    ));
  }
}

