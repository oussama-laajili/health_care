import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/doctor.dart';
import '../entities/geo_location.dart';
import 'location_service.dart';

class DoctorService {
  final LocationService _locationService = LocationService();

  /// Search for doctors near a specific location
  Future<List<Doctor>> searchNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    int limit = 50,
  }) async {
    // Overpass API endpoint
    const overpassUrl = 'https://overpass-api.de/api/interpreter';

    // Convert radius to meters for Overpass query
    final radiusMeters = radiusKm * 1000;

    // Overpass QL query for doctors and clinics
    // Searches for nodes and ways tagged as doctors, clinics, or medical centers
    final query = '''
    [out:json][timeout:25];
    (
      node["amenity"="doctors"](around:$radiusMeters,$latitude,$longitude);
      node["amenity"="clinic"](around:$radiusMeters,$latitude,$longitude);
      node["healthcare"="doctor"](around:$radiusMeters,$latitude,$longitude);
      way["amenity"="doctors"](around:$radiusMeters,$latitude,$longitude);
      way["amenity"="clinic"](around:$radiusMeters,$latitude,$longitude);
      way["healthcare"="doctor"](around:$radiusMeters,$latitude,$longitude);
    );
    out body center $limit;
    ''';

    try {
      final response = await http.post(
        Uri.parse(overpassUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'data': query},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List<dynamic>? ?? [];

        final doctors = elements.map((element) {
          // For ways, use the center coordinates
          double lat = element['lat']?.toDouble() ??
              element['center']?['lat']?.toDouble() ??
              0.0;
          double lon = element['lon']?.toDouble() ??
              element['center']?['lon']?.toDouble() ??
              0.0;

          final doctorJson = Map<String, dynamic>.from({
            ...element as Map,
            'lat': lat,
            'lon': lon,
          });

          return Doctor.fromOverpassJson(doctorJson, latitude, longitude);
        }).toList();

        // Sort by distance
        doctors.sort((a, b) {
          if (a.distanceKm == null) return 1;
          if (b.distanceKm == null) return -1;
          return a.distanceKm!.compareTo(b.distanceKm!);
        });

        return doctors;
      } else {
        throw Exception('Failed to fetch doctors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching for doctors: $e');
    }
  }

  /// Search for doctors near the user's current location
  Future<List<Doctor>> searchNearMe({
    double radiusKm = 5.0,
    int limit = 50,
  }) async {
    try {
      final Coordinates location =
          await _locationService.getCurrentCoordinates();
      return await searchNearby(
        latitude: location.latitude,
        longitude: location.longitude,
        radiusKm: radiusKm,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }
}
