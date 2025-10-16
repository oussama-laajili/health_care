import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:health_care/domain/entities/geo_location.dart';

/// Minimal service with no DI or repositories.
class LocationService {
  const LocationService();

  Future<Coordinates> getCurrentCoordinates({
    bool highAccuracy = true,
    Duration? timeout,
  }) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    final accuracy = highAccuracy ? LocationAccuracy.best : LocationAccuracy.low;
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
      timeLimit: timeout,
    );

    return Coordinates(
      latitude: pos.latitude,
      longitude: pos.longitude,
      accuracyMeters: pos.accuracy,
    );
  }

  Future<ResolvedPlace> reverseGeocode(Coordinates coords) async {
    final uri = Uri.parse('https://nominatim.openstreetmap.org/reverse').replace(
      queryParameters: {
        'format': 'jsonv2',
        'lat': coords.latitude.toString(),
        'lon': coords.longitude.toString(),
        'addressdetails': '1',
        'zoom': '10',
      },
    );

    final res = await http.get(uri, headers: const {
      'User-Agent': 'HealthCareApp/1.0 (contact@yourdomain.com)',
      'Accept-Language': 'en',
    });
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Reverse geocoding failed: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final address = (data['address'] ?? {}) as Map<String, dynamic>;

    final city = address['city'] ??
        address['town'] ??
        address['village'] ??
        address['municipality'] ??
        address['state_district'];

    final country = address['country'];
    final String? countryCode = (address['country_code'] as String?)?.toUpperCase();
    final displayName = data['display_name'];

    return ResolvedPlace(
      city: city?.toString(),
      country: country?.toString(),
      countryCode: countryCode,
      displayName: displayName?.toString(),
    );
  }

  Future<(Coordinates, ResolvedPlace)> getResolvedLocation({
    bool highAccuracy = true,
    Duration? timeout,
  }) async {
    final coords = await getCurrentCoordinates(
      highAccuracy: highAccuracy,
      timeout: timeout,
    );
    final place = await reverseGeocode(coords);
    return (coords, place);
  }
}
