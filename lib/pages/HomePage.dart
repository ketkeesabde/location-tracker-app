import 'package:flutter/material.dart';
import 'package:location_tracking_app_iitg/pages/Maps/map.dart';

class HomePage extends StatefulWidget {
  final String grpDocId;
  final String grpName;
  HomePage({required this.grpDocId,required this.grpName, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grpName),
      ),
      body: MapScreen(grpDocId: widget.grpDocId),
    );
  }
}
