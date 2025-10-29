import 'dart:math' as math;

class Pharmacy {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double? distanceKm;
  final String? address;
  final String? phone;
  final String? openingHours;
  final String? website;
  final String? imageUrl;

  const Pharmacy({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.distanceKm,
    this.address,
    this.phone,
    this.openingHours,
    this.website,
    this.imageUrl,
  });

  factory Pharmacy.fromOverpassJson(
      Map<String, dynamic> json, double? userLat, double? userLon) {
    final tags = json['tags'] as Map<String, dynamic>? ?? {};
    final lat = (json['lat'] as num?)?.toDouble() ?? 0.0;
    final lon = (json['lon'] as num?)?.toDouble() ?? 0.0;

    // Calculate distance if user coordinates provided
    double? distance;
    if (userLat != null && userLon != null) {
      distance = _calculateDistance(userLat, userLon, lat, lon);
    }

    return Pharmacy(
      id: json['id']?.toString() ?? '',
      name: tags['name'] ?? tags['brand'] ?? 'Pharmacy',
      latitude: lat,
      longitude: lon,
      distanceKm: distance,
      address: _buildAddress(tags),
      phone: tags['phone'],
      openingHours: tags['opening_hours'],
      website: tags['website'] ?? tags['contact:website'],
      imageUrl: tags['image'] ?? tags['wikimedia_commons'],
    );
  }

  /// Check if pharmacy is currently open based on opening_hours
  bool get isOpen {
    if (openingHours == null || openingHours!.isEmpty) {
      return true; // Unknown, assume open
    }

    // Handle 24/7 case
    if (openingHours == '24/7') {
      return true;
    }

    // For simple cases like "Mo-Fr 08:00-20:00" or "09:00-18:00"
    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);
    final currentTime = now.hour * 60 + now.minute;

    // Try to parse opening hours (simplified parser)
    try {
      final hoursLower = openingHours!.toLowerCase();

      // Check if it contains day ranges
      if (hoursLower.contains(currentDay.toLowerCase().substring(0, 2))) {
        final timePattern = RegExp(r'(\d{1,2}):(\d{2})-(\d{1,2}):(\d{2})');
        final match = timePattern.firstMatch(hoursLower);

        if (match != null) {
          final openHour = int.parse(match.group(1)!);
          final openMin = int.parse(match.group(2)!);
          final closeHour = int.parse(match.group(3)!);
          final closeMin = int.parse(match.group(4)!);

          final openTime = openHour * 60 + openMin;
          final closeTime = closeHour * 60 + closeMin;

          return currentTime >= openTime && currentTime <= closeTime;
        }
      }

      // If no day specified, check for time only
      final timePattern = RegExp(r'(\d{1,2}):(\d{2})-(\d{1,2}):(\d{2})');
      final match = timePattern.firstMatch(hoursLower);

      if (match != null) {
        final openHour = int.parse(match.group(1)!);
        final openMin = int.parse(match.group(2)!);
        final closeHour = int.parse(match.group(3)!);
        final closeMin = int.parse(match.group(4)!);

        final openTime = openHour * 60 + openMin;
        final closeTime = closeHour * 60 + closeMin;

        return currentTime >= openTime && currentTime <= closeTime;
      }
    } catch (e) {
      // If parsing fails, assume open
      return true;
    }

    return true; // Default to open if unable to parse
  }

  static String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  static String? _buildAddress(Map<String, dynamic> tags) {
    final parts = <String>[];
    if (tags['addr:street'] != null) {
      if (tags['addr:housenumber'] != null) {
        parts.add('${tags['addr:housenumber']} ${tags['addr:street']}');
      } else {
        parts.add(tags['addr:street']);
      }
    }
    if (tags['addr:city'] != null) parts.add(tags['addr:city']);
    if (tags['addr:postcode'] != null) parts.add(tags['addr:postcode']);
    return parts.isEmpty ? null : parts.join(', ');
  }

  /// Haversine formula to calculate distance between two coordinates
  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.asin(math.sqrt(a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  @override
  String toString() {
    return 'Pharmacy(name: $name, distance: ${distanceKm?.toStringAsFixed(2)}km, address: $address)';
  }
}
