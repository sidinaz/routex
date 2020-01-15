import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import '../model/user.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(child:
      RaisedButton(child: Text("Login",style: Theme.of(context).textTheme.body1),
        onPressed: (){
          RoutexNavigator.shared.replaceRoot("/app/main", context, {"user" : User("Flutter user")});
        },
      ),
      ),
    );
  }
}