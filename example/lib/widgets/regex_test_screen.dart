import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

class RegexTestScreen extends StatefulWidget {
  @override
  _RegexTestScreenState createState() => _RegexTestScreenState();
}

class _RegexTestScreenState extends State<RegexTestScreen> {
  TextEditingController _textController = TextEditingController();
  final _url = "https://www.google.com/";
  final _color = "#fff";

  @override
  Widget build(BuildContext context) {
  final deviceSize = MediaQuery.of(context).size;
  return Scaffold(
    appBar: AppBar(
      title: Text("Route with regex"),
    ),
    body: Container(
      height: deviceSize.height,
      width: deviceSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(child: Text(_url), onPressed: useUrl,),
          RaisedButton(child: Text(_color), onPressed: useColor,),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[

              Flexible(
                flex: 3,
                child: TextField(
                  controller: _textController,
                ),
              ),
              Flexible(
                flex: 1,
                child: RaisedButton(child: Text("Test"), onPressed: test,),
              )
            ],
          )
        ],
      ),
    ),
  );
  }

  void useUrl() => _textController.text = _url;
  void useColor() => _textController.text = _color;
  void test(){
    RoutexNavigator.shared.push("/v1/main/home/foo", context);
  }

}
