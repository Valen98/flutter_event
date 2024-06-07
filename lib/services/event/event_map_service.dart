import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventMapService extends ChangeNotifier {
  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          return data['result'];
        } else {
          throw Exception('Failed to load place details: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load place details');
    }
  }
}
