import 'package:flutter/foundation.dart';
import '../entities/doctor.dart';
import '../entities/geo_location.dart';
import '../services/doctor_service.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _doctorService = DoctorService();

  List<Doctor> _doctors = [];
  bool _isLoading = false;
  String? _errorMessage;
  Coordinates? _userLocation;

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Coordinates? get userLocation => _userLocation;

  /// Search for nearby doctors
  Future<void> searchNearby({double radiusKm = 5.0, int limit = 50}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _doctors = await _doctorService.searchNearMe(
        radiusKm: radiusKm,
        limit: limit,
      );

      // Store user location from first doctor if available
      if (_doctors.isNotEmpty) {
        // This is approximate - we'd need to get actual user location
        // For now, we'll leave it null or get it from LocationService
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _doctors = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear the doctors list
  void clear() {
    _doctors = [];
    _errorMessage = null;
    _userLocation = null;
    notifyListeners();
  }
}
