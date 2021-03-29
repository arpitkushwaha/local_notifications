import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Stack(
        children: <Widget>[
          // Max Size
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.blue,
            height: 300.0,
            width: 300.0,
          ),
          Positioned(
            right: 40.0,
            top: 40.0,
            child: Container(
              color: Colors.pink,
              height: 150.0,
              width: 150.0,
            ),
          )
        ],
      ),
    );
  }
}
