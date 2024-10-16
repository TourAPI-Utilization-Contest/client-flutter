import 'dart:convert';
import 'package:http/http.dart' as http;

class TspRouteFinder {
  static Future<List<List<int>>> findTspRoute(
      List<List<(double, double)>> locations) async {
    final List<Map<String, dynamic>> requestPayload =
        locations.map((waypoints) {
      return {
        "waypoints": waypoints.map((point) => [point.$1, point.$2]).toList(),
      };
    }).toList();
    final response =
        await http.post(Uri.parse('https://tsp-iubedabnlq-du.a.run.app/tsp'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"request": requestPayload}));
    // 응답 상태 확인
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> tspRoutes = responseBody['response'];

      // 경로 순서를 반환
      return tspRoutes.map((route) {
        return List<int>.from(route['order_of_waypoints']);
      }).toList();
    } else {
      // 오류 발생 시 예외 처리
      throw Exception('Failed to load tsp route');
    }
  }
}
