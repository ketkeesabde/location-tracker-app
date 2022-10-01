import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class MapScreen extends StatefulWidget {
  final String grpDocId;
  const MapScreen({required this.grpDocId, Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CollectionReference grpRef =
      FirebaseFirestore.instance.collection('groups');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String grpDocID;
  bool isLoading = true;
  double _value = 0.0;
  String _label = 'Adjust Radius';

  BehaviorSubject<double> radius = BehaviorSubject();

  GoogleMapController? mapController;
  Geoflutterfire geo = Geoflutterfire();

  // Map markers
  late Set<Marker> _markers = {};

  // Stateful Data
  late Stream<List<DocumentSnapshot>> stream;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: <Widget>[
              GoogleMap(
                myLocationEnabled: true,
                markers: _markers,
                initialCameraPosition:
                    CameraPosition(target: LatLng(24.142, -110.321)),
                onMapCreated: _onMapCreated,
              ),
              Positioned(
                bottom: 50,
                left: 10,
                child: Slider(
                  min: 0,
                  max: 1000,
                  divisions: 200,
                  value: _value,
                  label: _label,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.withOpacity(0.2),
                  onChanged: (double value) {
                    changedRadius(value);
                  },
                ),
              )
            ],
          );
  }

  void _onMapCreated(GoogleMapController mapController) {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(intervalDuration: Duration(minutes: 1))
            .listen((Position position) async {
      double prevZoom = await mapController.getZoomLevel();
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: prevZoom,
        )),
      );
      GeoFirePoint myLocation = Geoflutterfire()
          .point(latitude: position.latitude, longitude: position.longitude);
      addToDB(myLocation);
    });
    setState(() {
      this.mapController = mapController;
    });
    stream.listen((List<DocumentSnapshot> documentList) {
      updateMarkers(documentList);
    });
  }

  addToDB(myLocation) {
    grpRef
        .doc(grpDocID)
        .collection('locations')
        .doc(_auth.currentUser!.uid)
        .set({'uid': _auth.currentUser!.uid, 'position': myLocation.data});
  }

  changedRadius(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      _markers.clear();
    });
    radius.add(value);
  }

  updateMarkers(List<DocumentSnapshot> documentList) {
    setState(() {
      _markers.clear();
    });
    documentList.forEach((DocumentSnapshot document) {
      final GeoPoint point = document['position']['geopoint'];
      addMarker(point.latitude, point.longitude, document['uid']);
    });
  }

  addMarker(double latitude, double longitude, String name) {
    _markers.add(Marker(
      markerId: MarkerId(name),
      position: LatLng(latitude, longitude),
      draggable: false,
      infoWindow: InfoWindow(
        title: name,
      ),
    ));
  }

  initStream(Position curPos) {
    GeoFirePoint center = Geoflutterfire()
        .point(latitude: curPos.latitude, longitude: curPos.longitude);
    stream = radius.switchMap((rad) {
      return Geoflutterfire()
          .collection(
              collectionRef: grpRef.doc(grpDocID).collection('locations'))
          .within(
            center: center,
            radius: rad,
            field: 'position',
            strictMode: true,
          );
    });
  }

  fetchData() async {
    Position curPos = await getCurrentLocation();

    initStream(curPos);
    setState(() {
      isLoading = false;
    });
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position currentPosiition = await Geolocator.getCurrentPosition();
    return currentPosiition;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      this.grpDocID = widget.grpDocId;
    });
    this.fetchData();
  }


  @override
  void dispose() {
    mapController!.dispose();
    stream.drain();
    super.dispose();
  }
}
