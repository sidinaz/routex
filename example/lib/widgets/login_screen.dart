import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import '../model/user.dart';

class LoginScreen extends StatelessWidget {
  final Function setUser;

  LoginScreen(this.setUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(child:
      RaisedButton(child: Text("Login",style: Theme.of(context).textTheme.body1),
        onPressed: (){
          setUser(User("Flutter user"));
          RoutexNavigator.shared.replaceRoot("/app/main", context);
        },
      ),
      ),
    );
  }
}