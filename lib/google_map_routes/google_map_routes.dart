import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tradule/server_wrapper/data/movement_data.dart';
import 'package:tradule/server_wrapper/data/movement_detail_data.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';

String _proxyUrl = 'https://proxy-iubedabnlq-du.a.run.app';
// String _proxyUrl = 'http://127.0.0.1:5001/tradule-com/asia-northeast3/proxy';

Future<MovementData> getGoogleMapRoutes(PlaceData start, PlaceData end) async {
  final proxyUrl = '$_proxyUrl/computeRoutes';
  var departureTime = start.visitTime ?? DateTime.now();
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
    var details = steps.map<MovementDetailData>((step) {
      int seconds = int.parse(step['staticDuration'].replaceAll('s', ''));
      cumulativeSeconds += seconds;
      return MovementDetailData(
        path: step['polyline']['encodedPolyline'],
        duration: Duration(seconds: seconds),
        distance: step['distanceMeters'].toDouble(),
        method: step['travelMode'],
        source: 'Google',
      );
    }).toList();
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
    throw Exception('Failed to load routes');
  }
}
