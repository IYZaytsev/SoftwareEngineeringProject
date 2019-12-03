
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';


part 'candidates.g.dart';



@JsonSerializable()
class Candidates {
  Candidates({
    this.county,
    this.position,
    this.name,
    this.lat,
    this.lng,
    this.city
  });

  factory Candidates.fromJson(Map<String, dynamic> json) => _$CandidatesFromJson(json);
  Map<String, dynamic> toJson() => _$CandidatesToJson(this);

  final String county;
  final String position;
  final String name;
  final double lat;
  final double lng;
  final String city;

}


@JsonSerializable()
class CurrentRunning {
  CurrentRunning({
    this.elections
  });

  factory CurrentRunning.fromJson(Map<String, dynamic> json) =>
      _$CurrentRunningFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentRunningToJson(this);

  final List<Candidates> elections;

}

class  JsonLoader{
  static Future<String> loadMapAsset() async {
  return await rootBundle.loadString('assets/candidates.json');
  }

  static CurrentRunning results;

  static Future<CurrentRunning> getMapmarkers()async{
  String stringJson = await loadMapAsset();
  print(stringJson);
  var jsonData = json.decode(stringJson);
  results = new CurrentRunning.fromJson(jsonData);
  print(results.elections[0].name);
  return results;
  }

}