import "dart:core";
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'dart:async' show Future;
import 'package:async/async.dart';
import 'package:location/location.dart';
import 'src/counties.dart' as counties;
import 'src/candidates.dart' as candidates;
import 'package:poli_map/mapHelper.dart';
import 'package:poli_map/navBar.dart';
void main() => runApp(new MaterialApp(home: new MyApp()));

enum Answer { YES, NO, MAYBE }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Marker> allmapMarkers = [];
  List<Marker> mapMarkers = [];
  List<Polygon> plist = [];
  double currentZoom = 0;
  LatLng visiableCenter;
  String _answer = "";
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  GoogleMapController mapController;
  LatLng userLocation = LatLng(0, 0);

  void setAnswer(String value) {
    setState(() {
      _answer = value;
    });
  }

  //Gets passed a value and
  void updateMapMarker(String value) {
    mapMarkers.clear();
    for (final marks in allmapMarkers) {
      if (marks.infoWindow.snippet == value) {
        mapMarkers.add(marks);

      }
    }
    setState(() {});
  }

  Future<Null> _askUser(BuildContext context) async {
    candidates.CurrentRunning meck =
        await candidates.JsonLoader.getMapmarkers();
    for (final person in meck.elections) {
      final marker = Marker(
          consumeTapEvents: false,
          markerId: MarkerId(person.name),
          position: LatLng(person.lat, person.lng),
          infoWindow: InfoWindow(
            title: person.name,
            snippet: person.position,
          ));
      allmapMarkers.add(marker);
    }

    List<Widget> listofPositionWidgets = [];
    List<String> listOfPosition = [];
    for (final person in meck.elections) {
      if (listOfPosition.contains(person.position)) {
        continue;
      } else {
        listOfPosition.add(person.position);
      }
    }
    for (final position in listOfPosition) {
      listofPositionWidgets.add(SimpleDialogOption(
        child: Text(position),
        onPressed: () {
          updateMapMarker(position);
          Navigator.pop(context);
        },
      ));
    }
    await showDialog(
        context: context,
        child: new SimpleDialog(
          title: Text("Positions"),
          children: listofPositionWidgets,
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //takes the result from the call back functino From NavBar.dart and rebuilds the map
  void _mapRefresh(String s) {
    switch (s) {
      case "City":
        {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: userLocation, zoom: 11)));
          _askUser(context);
        }
        break;
      case "County":
        {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: userLocation, zoom: 9)));
          _askUser(context);
        }
        break;
      case "State":
        {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: userLocation, zoom: 8)));
          _askUser(context);
        }
        break;
    }
  }

//When the camera is moved this function fires and updates global variables for use in calculations
  Future<void> _onGeoChanged(CameraPosition position) async {
    setState(() {
      visiableCenter = position.target;
      currentZoom = position.zoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("PoliMap"),
        backgroundColor: Colors.red[500],
      ),
      bottomNavigationBar: NavBar(_mapRefresh),
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
                      markers: mapMarkers.toSet(),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapToolbarEnabled: false,
                      polygons: plist.toSet(),
                      initialCameraPosition: CameraPosition(
                        target: userLocation,
                        zoom: 11.0,
                      ),
                      onCameraMove: _onGeoChanged,
                    );
                }
              })
        ],
      ),
    ));
  }

  //loads in the Json and gets location data of user
  Future<void> _loadInAssets() async {
    counties.Locations countyLines = await counties.Counties.getMapmarkers();
    //loads in countyLines and converts to a polygon set
    for (final location in countyLines.counties) {
      List<LatLng> points = [];
      for (final p in location.coordinates) {
        points.add(LatLng(p.lat, p.lng));
      }
      Polygon polyGon = Polygon(
          polygonId: PolygonId(location.countyName),
          points: points,
          geodesic: true,
          strokeColor: Colors.blue,
          fillColor: Colors.lightBlue.withOpacity(0.1),
          visible: false);
      plist.add(polyGon);
    }
  }

  //Map loads faster than flutter can get GPS coordinates, so it has to be have priority, Getting
  //User location is only takes long on startup for some reason, otherwise it updates fast.
  // it also figure out what county you are in and displays it accordingly
  _getLocationMemorize() {
    return this._memoizer.runOnce(() async {
      await _loadInAssets();
      LatLng intialPosition = await MapMath.getLocation();
      userLocation = intialPosition;
      int index = MapMath.whichCounty(plist, intialPosition);
      plist[index] = Polygon(
          polygonId: plist[index].polygonId,
          points: plist[index].points,
          geodesic: true,
          strokeColor: Colors.blue,
          fillColor: Colors.lightBlue.withOpacity(0.1),
          visible: true);
      setState(() {});
      return intialPosition;
    });
  }
}