import 'package:google_maps_flutter/google_maps_flutter.dart';
import "dart:math" as math;
import 'package:location/location.dart';
class MapMath{
  //Algorithm that figures out if you point is insde a 
  static bool rayCrossesSegment(LatLng point, LatLng a, LatLng b) {
    const double infinity = 1.0 / 0.0;
    var px = point.longitude,
        py = point.latitude,
        ax = a.longitude,
        ay = a.latitude,
        bx = b.longitude,
        by = b.latitude;

    if (ay > by) {
      ax = b.longitude;
      ay = b.latitude;
      bx = a.longitude;
      by = a.latitude;
    }
    if (px < 0) {
      px += 360;
    }
    if (ax < 0) {
      ax += 360;
    }
    if (bx < 0) {
      bx += 360;
    }

    if (py == ay || py == by) py += 0.00000001;
    if ((py > by || py < ay) || (px > math.max(ax, bx))) return false;
    if (px < math.min(ax, bx)) return true;

    var red = (ax != bx) ? ((by - ay) / (bx - ax)) : infinity;
    var blue = (ax != px) ? ((py - ay) / (px - ax)) : infinity;
    return (blue >= red);
  }
  //Tells you if a gps point is inside of a poygon
  static bool doesContain(LatLng point, List<LatLng> bounds) {
    var crossings = 0;

    for (int i = 0; i < bounds.length; i++) {
      var a = bounds[i];
      var j = i + 1;
      if (j >= bounds.length) {
        j = 0;
      }
      var b = bounds[j];
      if (rayCrossesSegment(point, a, b)) {
        crossings++;
      }
    }
    return (crossings % 2 == 1);
  }
  //get passed the set of counties coordinates and figures out which one you are in 
  //returns the index.
  static int whichCounty(List<Polygon> polyset, LatLng userPosition){
    print(polyset.length);
    for(int i = 0; i < polyset.length; i++ ){
      if (doesContain(userPosition, polyset[i].points)){
        return i;
      }
    }

    return -1;
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

}