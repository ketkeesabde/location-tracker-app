import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  final String message;
  Loading({required this.message});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Center(
            heightFactor: 8,
            child: SpinKitChasingDots(
              color: Colors.green,
              size: 50.0,
            ),
          ),
          Text(widget.message),
        ],
      ),
    );
  }
}
