
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';


part 'counties.g.dart';


@JsonSerializable()
class LatLng {
  LatLng({
    this.lat,
    this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class County {
  County({
    this.countyName,
    this.coordinates,
  });

  factory County.fromJson(Map<String, dynamic> json) => _$CountyFromJson(json);
  Map<String, dynamic> toJson() => _$CountyToJson(this);

  final String countyName;
  final List<LatLng> coordinates;
}


@JsonSerializable()
class Locations {
  Locations({
    this.counties
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<County> counties;

}

class  Counties{
  static Future<String> loadMapAsset() async {
  return await rootBundle.loadString('assets/counties.json');
  }

  static Locations results;

  static Future<Locations> getMapmarkers()async{
  String stringJson = await loadMapAsset();
  var jsonData = json.decode(stringJson);
  results = new Locations.fromJson(jsonData);
  //print(results.counties[0].countyName);
  return results;
  }

}