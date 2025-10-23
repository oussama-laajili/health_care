import 'package:flutter/material.dart';
import 'package:health_care/entities/geo_location.dart';
import 'package:health_care/services/location_service.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Coordinates? _coords;
  ResolvedPlace? _place;
  String? _error;
  bool _loading = false;
  final _service = const LocationService();

  Future<void> _resolveCurrent() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _service.getResolvedLocation(
        highAccuracy: true,
        timeout: const Duration(seconds: 10),
      );
      setState(() {
        _coords = result.$1;
        _place = result.$2;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _loading ? null : _resolveCurrent,
              icon: const Icon(Icons.my_location),
              label: const Text('Get my location (city, country)'),
            ),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) ...[
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
            ],
            if (_coords != null) ...[
              Text('Latitude: ${_coords!.latitude.toStringAsFixed(6)}'),
              Text('Longitude: ${_coords!.longitude.toStringAsFixed(6)}'),
              if (_coords!.accuracyMeters != null)
                Text('Accuracy: ${_coords!.accuracyMeters!.toStringAsFixed(1)} m'),
              const SizedBox(height: 8),
            ],
            if (_place != null) ...[
              Text('City: ${_place!.city ?? '-'}'),
              Text('Country: ${_place!.country ?? '-'} (${_place!.countryCode ?? '-'})'),
              if (_place!.displayName != null)
                Text('Full: ${_place!.displayName}'),
            ],
          ],
        ),
      ),
    );
  }
}
