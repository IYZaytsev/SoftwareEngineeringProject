import "dart:core";
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'dart:async' show Future;
import 'package:async/async.dart';
import 'package:location/location.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  GoogleMapController mapController;
  LatLng userLocation = LatLng(0, 0);


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

   static Future<LatLng> getLocation() async {
    LocationData currentLocation;

    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      return LatLng(currentLocation.latitude, currentLocation.longitude);
    } on Exception {
      currentLocation = null;
    }
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("PoliMap"),
        backgroundColor: Colors.red[500],
      ),

      body: Stack(
        children: <Widget>[
          FutureBuilder(
              future: this._getLocationMemorize(),
              builder: (BuildContext context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container(
                        color: Colors.red[500],
                        child: Center(
                          child: Loading(
                              indicator: BallBeatIndicator(), size: 100.0),
                        ));
                  case ConnectionState.done:
                    return new GoogleMap(
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapToolbarEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: userLocation,
                        zoom: 11.0,
                      ),
                    );
                }
              })
        ],
      ),
    ));
  }

  //Map loads faster than flutter can get GPS coordinates, so it has to be have priority, Getting
  //User location is only takes long on startup for some reason, otherwise it updates fast.

  _getLocationMemorize() {
    return this._memoizer.runOnce(() async {
      LatLng intialPosition = await getLocation();
      userLocation = intialPosition;
      setState(() {});
      return intialPosition;
    });
  }
}
