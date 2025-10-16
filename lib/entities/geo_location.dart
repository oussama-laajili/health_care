/// Domain entities representing coordinates and a resolved place.
 class Coordinates {
   final double latitude;
   final double longitude;
   final double? accuracyMeters;

   const Coordinates({
     required this.latitude,
     required this.longitude,
     this.accuracyMeters,
   });
 }

 class ResolvedPlace {
   final String? city;
   final String? country;
   final String? countryCode; // ISO 3166-1 alpha-2 (e.g., 'FR', 'US')
   final String? displayName; // Full formatted name

   const ResolvedPlace({
     this.city,
     this.country,
     this.countryCode,
     this.displayName,
   });
 }
