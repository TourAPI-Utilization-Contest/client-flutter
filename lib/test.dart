import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: MapScreen(),
  ));
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  final LatLng _startLocation = LatLng(37.7749, -122.4194); // 출발지
  final LatLng _destination = LatLng(37.7849, -122.4294); // 목적지
  String _googleAPIKey =
      'AIzaSyA0-BKUMEPvt8w27G-lcp2sWQp3zjuAw8w'; // 여기에 발급받은 API 키 추가

  @override
  void initState() {
    super.initState();
    _getDirections();
  }

  // Directions API를 통해 경로 데이터를 가져오는 함수
  Future<void> _getDirections() async {
    // String url =
    //     'https://maps.googleapis.com/maps/api/directions/json?origin=${_startLocation.latitude},${_startLocation.longitude}&destination=${_destination.latitude},${_destination.longitude}&key=$_googleAPIKey';
    //
    // final response = await http.get(Uri.parse(url));
    final json = """
{"geocoded_waypoints":[{"geocoder_status":"OK","place_id":"ChIJEdGJjp6AhYARLq47wZq8Vtk","types":["street_address"]},{"geocoder_status":"OK","place_id":"ChIJ9UNO0L6AhYARzock0NnfE2I","types":["establishment","food","point_of_interest","restaurant"]}],"routes":[{"bounds":{"northeast":{"lat":37.785487,"lng":-122.4187449},"southwest":{"lat":37.7718139,"lng":-122.4293908}},"copyrights":"Map data ©2024 Google","legs":[{"distance":{"text":"1.6 mi","value":2610},"duration":{"text":"8분","value":498},"end_address":"22 Peace Plaza, #510, 2nd Floor, San Francisco, CA 94115 미국","end_location":{"lat":37.7848562,"lng":-122.4293908},"start_address":"5911 US-101, San Francisco, CA 94103 미국","start_location":{"lat":37.7749145,"lng":-122.4193077},"steps":[{"distance":{"text":"0.1 mi","value":212},"duration":{"text":"1분","value":66},"end_location":{"lat":37.7730562,"lng":-122.4187449},"html_instructions":"\u003Cb\u003ES Van Ness Ave\u003C/b\u003E에서 \u003Cb\u003E12th St\u003C/b\u003E 방면 \u003Cb\u003E남쪽\u003C/b\u003E으로 출발","polyline":{"points":"e|peFt_ejVLCd@IPEXGbB_@l@MXGb@I`AU"},"start_location":{"lat":37.7749145,"lng":-122.4193077},"travel_mode":"DRIVING"},{"distance":{"text":"0.1 mi","value":197},"duration":{"text":"1분","value":58},"end_location":{"lat":37.7718139,"lng":-122.4203357},"html_instructions":"\u003Cb\u003E우회전\u003C/b\u003E하여 \u003Cb\u003EOtis St\u003C/b\u003E에 진입","maneuver":"turn-right","polyline":{"points":"sppeFb|djVdAzA`@d@n@|@l@~@b@j@NR"},"start_location":{"lat":37.7730562,"lng":-122.4187449},"travel_mode":"DRIVING"},{"distance":{"text":"0.1 mi","value":195},"duration":{"text":"1분","value":38},"end_location":{"lat":37.7730448,"lng":-122.4219117},"html_instructions":"\u003Cb\u003E우회전\u003C/b\u003E하여 \u003Cb\u003EGough St\u003C/b\u003E에 진입","maneuver":"turn-right","polyline":{"points":"yhpeFbfejVY^s@~@c@j@{@lAm@|@Y`@"},"start_location":{"lat":37.7718139,"lng":-122.4203357},"travel_mode":"DRIVING"},{"distance":{"text":"148 ft","value":45},"duration":{"text":"1분","value":12},"end_location":{"lat":37.7733218,"lng":-122.4215392},"html_instructions":"\u003Cb\u003E우회전\u003C/b\u003E하여 \u003Cb\u003EMarket St\u003C/b\u003E에 진입","maneuver":"turn-right","polyline":{"points":"oppeF|oejVOSU]QW"},"start_location":{"lat":37.7730448,"lng":-122.4219117},"travel_mode":"DRIVING"},{"distance":{"text":"325 ft","value":99},"duration":{"text":"1분","value":23},"end_location":{"lat":37.7739696,"lng":-122.4207761},"html_instructions":"\u003Cb\u003EFranklin St\u003C/b\u003E 방면 \u003Cb\u003E좌회전\u003C/b\u003E","maneuver":"turn-slight-left","polyline":{"points":"grpeFrmejVGAAACA]e@uAkB"},"start_location":{"lat":37.7733218,"lng":-122.4215392},"travel_mode":"DRIVING"},{"distance":{"text":"0.8 mi","value":1298},"duration":{"text":"3분","value":209},"end_location":{"lat":37.785487,"lng":-122.4230519},"html_instructions":"\u003Cb\u003EFranklin St\u003C/b\u003E(으)로 계속 진행","polyline":{"points":"ivpeFzhejVCCCACAC?C?G?QDSB]F_AJSBy@HMB_@Dc@FQBG@kANQBQ@e@Fe@DQBi@FG@UDc@D{@JM@i@HK@E@Q@uC^e@Da@Fy@Je@FQ@c@Fc@FWBc@Fc@Dw@Ja@FC?C@s@HM@UBKBk@FUBeAL]FK@M@g@FM@E@[Di@Fu@HE@a@Fc@DK@YDSBe@FSBc@F{APo@Hm@F"},"start_location":{"lat":37.7739696,"lng":-122.4207761},"travel_mode":"DRIVING"},{"distance":{"text":"0.4 mi","value":564},"duration":{"text":"2분","value":92},"end_location":{"lat":37.7848562,"lng":-122.4293908},"html_instructions":"\u003Cb\u003E좌회전\u003C/b\u003E하여 \u003Cb\u003EGeary Blvd\u003C/b\u003E에 진입\u003Cdiv style=\"font-size:0.9em\"\u003E목적지는 길의 오른쪽에 있습니다.\u003C/div\u003E","maneuver":"turn-left","polyline":{"points":"i~reF`wejV@VBR@N?FBX@RBh@@L?N?l@Et@Ap@A^@V?NBf@@NHhA@DBl@Dd@?DB`@@J@RBX@JTdCHjADl@B\\VzDDv@"},"start_location":{"lat":37.785487,"lng":-122.4230519},"travel_mode":"DRIVING"}],"traffic_speed_entry":[],"via_waypoint":[]}],"overview_polyline":{"points":"e|peFt_ejV~A[nE_A`AUdAzApAbBpAjBNRY^s@~@_BxBgA~Ae@q@QWGAECsBqCGESAcC\\eGt@{OjBg]bEwGv@}APDj@FdADtBGfB?v@NpCJ~AJzAf@jG`@pG"},"summary":"Franklin St","warnings":[],"waypoint_order":[]}],"status":"OK"}
""";
    Map<String, dynamic> data = jsonDecode(json);
    _decodePolyline(data['routes'][0]['overview_polyline']['points']);
  }

  // Polyline 데이터를 디코딩하는 함수
  void _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    setState(() {
      polylineCoordinates = points;
      _setPolyline();
    });
  }

  // Polyline을 설정하는 함수
  void _setPolyline() {
    _polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Directions'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _startLocation,
          zoom: 14.0,
        ),
        polylines: _polylines,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId('start'),
            position: _startLocation,
          ),
          Marker(
            markerId: MarkerId('destination'),
            position: _destination,
          ),
        },
      ),
    );
  }
}
