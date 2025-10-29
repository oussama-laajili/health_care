import 'package:flutter/material.dart';
import '../entities/pharmacy.dart';
import '../entities/geo_location.dart';
import '../services/pharmacy_service.dart';

class PharmacyProvider extends ChangeNotifier {
  final PharmacyService _pharmacyService;

  PharmacyProvider({PharmacyService? pharmacyService})
      : _pharmacyService = pharmacyService ?? const PharmacyService();

  List<Pharmacy> _pharmacies = [];
  Coordinates? _userLocation;
  bool _isLoading = false;
  String? _errorMessage;

  List<Pharmacy> get pharmacies => _pharmacies;
  Coordinates? get userLocation => _userLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> searchNearby({double radiusKm = 5.0, int limit = 50}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final (coords, pharmacies) = await _pharmacyService.searchNearMe(
        radiusKm: radiusKm,
        limit: limit,
      );

      _userLocation = coords;
      _pharmacies = pharmacies;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _pharmacies = [];
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clear() {
    _pharmacies = [];
    _userLocation = null;
    _errorMessage = null;
    notifyListeners();
  }
}
