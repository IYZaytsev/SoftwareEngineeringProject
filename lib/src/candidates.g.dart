// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Candidates _$CandidatesFromJson(Map<String, dynamic> json) {
  return Candidates(
    county: json['county'] as String,
    position: json['position'] as String,
    name: json['name'] as String,
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
    city: json['city'] as String,
  );
}

Map<String, dynamic> _$CandidatesToJson(Candidates instance) =>
    <String, dynamic>{
      'county': instance.county,
      'position': instance.position,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'city': instance.city,
    };

CurrentRunning _$CurrentRunningFromJson(Map<String, dynamic> json) {
  return CurrentRunning(
    elections: (json['elections'] as List)
        ?.map((e) =>
            e == null ? null : Candidates.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CurrentRunningToJson(CurrentRunning instance) =>
    <String, dynamic>{
      'elections': instance.elections,
    };
