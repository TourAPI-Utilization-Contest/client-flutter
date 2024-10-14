import 'package:flutter/material.dart';
import 'package:tsp_route_finder/tsp_route_finder.dart';

class FindTspRoute extends StatefulWidget {
  const FindTspRoute({super.key});

  @override
  State<FindTspRoute> createState() => _FindTspRouteState();
}

class _FindTspRouteState extends State<FindTspRoute> {
  List<int> tspRoute = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TSP Route Finder"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                findTSP();
                setState(() {});
              },
              color: Colors.deepPurpleAccent,
              child: const Text("Find", style: TextStyle(color: Colors.white)),
            ),
            if (tspRoute.isNotEmpty) Text(tspRoute.toString()),
          ],
        ),
      ),
    );
  }

  void findTSP() async {
    // Define a list locations
    final List<CitiesLocations> locations = [
      CitiesLocations(
          cityName: "Cairo",
          latitude: 30.04536650078621,
          longitude: 31.233230917179828),
      CitiesLocations(
          cityName: "Tanta",
          latitude: 30.78654967266781,
          longitude: 31.001245021237708),
      CitiesLocations(
          cityName: "Mansoura",
          latitude: 31.040718440307945,
          longitude: 31.380351843023824),
      CitiesLocations(
          cityName: "Aswan",
          latitude: 24.089512449946742,
          longitude: 32.89933393026378),
      CitiesLocations(
          cityName: "Alexandria",
          latitude: 31.200888037065972,
          longitude: 29.927766526114013),
    ];

    // Calculate the TSP route
    tspRoute = await TspPackage.calculateTspRoute(
        locations: locations, startingLocationIndex: 0);
  }
}

void main() {
  runApp(const MaterialApp(
    home: FindTspRoute(),
  ));
}
