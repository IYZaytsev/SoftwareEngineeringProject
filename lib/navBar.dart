import "dart:core";
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'main.dart';

class NavBar extends StatefulWidget {
  final Function onPressedFunction;

  NavBar(this.onPressedFunction);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.red,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      widget.onPressedFunction("City");
                      //_askUser(context);
                    },
                    color: Colors.red[500],
                    child: Text(
                      "City",
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 2.5,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      widget.onPressedFunction("County");
                      //_askUser(context);
                    },
                    color: Colors.red[500],
                    child: Text(
                      "County",
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 2.5,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      widget.onPressedFunction("State");
                      //_askUser(context);
                    },
                    color: Colors.red[500],
                    child: Text(
                      "State",
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 2.5,
                    ),
                  ),
                ])));
  }
}
