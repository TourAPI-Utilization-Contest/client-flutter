import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tradule/server_wrapper/data/movement_data.dart';
import 'package:tradule/server_wrapper/data/movement_detail_data.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';

String _proxyUrl = 'https://proxy-iubedabnlq-du.a.run.app';
// String _proxyUrl = 'http://127.0.0.1:5001/tradule-com/asia-northeast3/proxy';

Future<MovementData?> getGoogleMapRoutes(PlaceData start, PlaceData end,
    {int recursionCount = 0}) async {
  final proxyUrl = '$_proxyUrl/computeRoutes';
  var now = DateTime.now();
  var visitDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    start.visitTime?.hour ?? 0,
    start.visitTime?.minute ?? 0,
  );
  var departureTime = visitDateTime.add(start.stayTime ?? const Duration());
  var departureTimeString = departureTime.toUtc().toIso8601String();

  var response = await http.post(
    Uri.parse(proxyUrl),
    headers: {
      'Content-Type': 'application/json',
      'X-Goog-FieldMask': 'routes.*',
      // 'Access_token': 'ya29',
      // 'access_token': 'ya29',
      // 'access_token': 'ya29',
    },
    body: jsonEncode({
      "origin": {
        "location": {
          "latLng": {
            "latitude": start.latitude,
            "longitude": start.longitude,
          },
        },
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": end.latitude,
            "longitude": end.longitude,
          },
        },
      },
      "travelMode": "TRANSIT",
      "departureTime": departureTimeString,
    }),
  );
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var legs = data['routes'][0]['legs'];
    var steps = legs[0]['steps'];
    var cumulativeSeconds = 0;
    // var details = steps.map<MovementDetailData>((step) {
    //   int seconds = int.parse(step['staticDuration'].replaceAll('s', ''));
    //   cumulativeSeconds += seconds;
    //   return MovementDetailData(
    //     path: step['polyline']['encodedPolyline'],
    //     duration: Duration(seconds: seconds),
    //     distance: step['distanceMeters'].toDouble(),
    //     method: step['travelMode'],
    //     source: 'Google',
    //   );
    // }).toList();
    List<MovementDetailData> details = [];
    for (var step in steps) {
      var distance = step['distanceMeters'];
      if (distance == null) continue;
      int seconds = int.parse(step['staticDuration'].replaceAll('s', ''));
      cumulativeSeconds += seconds;
      var travelMode = step['travelMode'];
      String method = "unknown";
      String? nameShort;
      String? name;
      int? stopCount;
      if (travelMode == 'WALK') {
        method = 'WALK';
      } else if (travelMode == 'TRANSIT') {
        method = step['transitDetails']['transitLine']['vehicle']['type'];
        name = step['transitDetails']['transitLine']['name'];
        nameShort = step['transitDetails']['transitLine']['shortName'];
        stopCount = step['transitDetails']['stopCount'];
      }
      details.add(MovementDetailData(
        path: step['polyline']['encodedPolyline'],
        duration: Duration(seconds: seconds),
        distance: distance.toDouble(),
        method: method,
        nameShort: nameShort,
        name: name,
        stopCount: stopCount,
        source: 'Google',
      ));
    }

    var leg = legs[0];
    return MovementData(
      startTime: departureTime,
      endTime: departureTime.add(Duration(seconds: cumulativeSeconds)),
      duration: Duration(
        seconds: int.parse(leg['duration'].replaceAll('s', '')),
      ),
      distance: leg['distanceMeters'].toDouble(),
      method: 'TRANSIT',
      source: 'Google',
      details: details,
    );
  } else {
    if (3 < recursionCount) return null; // 3회 이상 재시도하지 않음
    return getGoogleMapRoutes(start, end, recursionCount: recursionCount + 1);
  }
}

Future<List<int>?> optimizedRoute(List<PlaceData> places) async {
  final proxyUrl = '$_proxyUrl/computeRoutes';
  print('places: $places');
  String body = jsonEncode({
    "origin": {
      "location": {
        "latLng": {
          "latitude": places.first.latitude,
          "longitude": places.first.longitude,
        },
      },
    },
    "destination": {
      "location": {
        "latLng": {
          "latitude": places.last.latitude,
          "longitude": places.last.longitude,
        },
      },
    },
    "intermediates": places
        .sublist(1, places.length - 1)
        .map((place) => {
              "location": {
                "latLng": {
                  "latitude": place.latitude,
                  "longitude": place.longitude,
                },
              },
            })
        .toList(),
    "travelMode": "DRIVE",
    "optimizeWaypointOrder": "true",
  });
  print('body: $body');
  var response = await http.post(
    Uri.parse(proxyUrl),
    headers: {
      'Content-Type': 'application/json',
      'X-Goog-FieldMask':
          'routes.optimizedIntermediateWaypointIndex,geocodingResults.intermediates.intermediateWaypointRequestIndex',
    },
    body: jsonEncode({
      "origin": {
        "location": {
          "latLng": {
            "latitude": places.first.latitude,
            "longitude": places.first.longitude,
          },
        },
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": places.last.latitude,
            "longitude": places.last.longitude,
          },
        },
      },
      "intermediates": places
          .sublist(1, places.length - 1)
          .map((place) => {
                "location": {
                  "latLng": {
                    "latitude": place.latitude,
                    "longitude": place.longitude,
                  },
                },
              })
          .toList(),
      "travelMode": "DRIVE",
      "optimizeWaypointOrder": "true",
    }),
  );
  if (response.statusCode == 200) {
    print('response.body: ${response.body}');
    var data = jsonDecode(response.body);
    List<int> order = data['routes']['optimizedIntermediateWaypointIndex'];
    return order;
  } else {
    throw Exception('Failed to load routes');
  }
}
