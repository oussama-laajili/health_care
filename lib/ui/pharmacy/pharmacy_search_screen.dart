import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/styles.dart';
import '../../providers/pharmacy_provider.dart';
import '../../providers/loader_provider.dart';

class PharmacySearchScreen extends StatefulWidget {
  const PharmacySearchScreen({super.key});

  @override
  State<PharmacySearchScreen> createState() => _PharmacySearchScreenState();
}

class _PharmacySearchScreenState extends State<PharmacySearchScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-search on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchNearby();
    });
  }

  Future<void> _searchNearby() async {
    final loaderProvider = context.read<LoaderProvider>();
    final pharmacyProvider = context.read<PharmacyProvider>();

    loaderProvider.show();
    await pharmacyProvider.searchNearby(radiusKm: 5.0, limit: 50);
    loaderProvider.hide();

    if (mounted && pharmacyProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pharmacyProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDefaultImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppStyles.secondaryColor.withValues(alpha: 0.3),
            AppStyles.accentPurple.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.local_pharmacy,
        size: 60,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: AppBar(
        title: Text(
          'Nearby Pharmacies',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppStyles.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _searchNearby,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<PharmacyProvider>(
        builder: (context, provider, _) {
          if (provider.pharmacies.isEmpty && !provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_pharmacy_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No pharmacies found nearby',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _searchNearby,
                    icon: const Icon(Icons.search),
                    label: Text(
                      'Search Again',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Location info header
              if (provider.userLocation != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: AppStyles.accentPurple.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        color: AppStyles.accentPurple,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Found ${provider.pharmacies.length} pharmacies near you',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppStyles.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Pharmacy list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = provider.pharmacies[index];
                    final isOpen = pharmacy.isOpen;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pharmacy image with open/closed badge
                          Stack(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: pharmacy.imageUrl != null
                                    ? Image.network(
                                        pharmacy.imageUrl!,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildDefaultImage();
                                        },
                                      )
                                    : _buildDefaultImage(),
                              ),
                              // Open/Closed badge
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isOpen
                                        ? AppStyles.secondaryColor
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    isOpen ? 'OPEN' : 'CLOSED',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Pharmacy info
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pharmacy.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (pharmacy.distanceKm != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${pharmacy.distanceKm!.toStringAsFixed(2)} km away',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                if (pharmacy.address != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    pharmacy.address!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (pharmacy.phone != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        pharmacy.phone!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (pharmacy.openingHours != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          pharmacy.openingHours!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Navigate to maps or call
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Selected: ${pharmacy.name}'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppStyles.secondaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(Icons.directions,
                                        size: 18, color: Colors.white),
                                    label: Text(
                                      'Get Directions',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
