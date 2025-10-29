import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/pharmacy.dart';
import '../entities/geo_location.dart';
import 'location_service.dart';

class PharmacyService {
  final LocationService _locationService;

  const PharmacyService({LocationService? locationService})
      : _locationService = locationService ?? const LocationService();

  /// Search for pharmacies within a radius (in kilometers) of given coordinates
  Future<List<Pharmacy>> searchNearby({
    required Coordinates coordinates,
    double radiusKm = 5.0,
    int limit = 50,
  }) async {
    // Build Overpass QL query
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="pharmacy"](around:${radiusKm * 1000},${coordinates.latitude},${coordinates.longitude});
  way["amenity"="pharmacy"](around:${radiusKm * 1000},${coordinates.latitude},${coordinates.longitude});
);
out center $limit;
''';

    final uri = Uri.parse('https://overpass-api.de/api/interpreter');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'data': query},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch pharmacies: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = (data['elements'] as List<dynamic>?) ?? [];

    final pharmacies = elements
        .map((e) => Pharmacy.fromOverpassJson(
              e as Map<String, dynamic>,
              coordinates.latitude,
              coordinates.longitude,
            ))
        .toList();

    // Sort by distance
    pharmacies.sort((a, b) {
      final distA = a.distanceKm ?? double.infinity;
      final distB = b.distanceKm ?? double.infinity;
      return distA.compareTo(distB);
    });

    return pharmacies;
  }

  /// Get user's current location and search for nearby pharmacies
  Future<(Coordinates, List<Pharmacy>)> searchNearMe({
    double radiusKm = 5.0,
    int limit = 50,
    bool highAccuracy = true,
  }) async {
    final coordinates = await _locationService.getCurrentCoordinates(
      highAccuracy: highAccuracy,
    );

    final pharmacies = await searchNearby(
      coordinates: coordinates,
      radiusKm: radiusKm,
      limit: limit,
    );

    return (coordinates, pharmacies);
  }
}
