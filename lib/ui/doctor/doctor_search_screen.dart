import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/styles.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/loader_provider.dart';
import '../../shared/widgets/doctor_card.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-search on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchNearby();
    });
  }

  Future<void> _searchNearby() async {
    if (!mounted) return;

    final doctorProvider = context.read<DoctorProvider>();
    final loaderProvider = context.read<LoaderProvider>();

    loaderProvider.show();
    await doctorProvider.searchNearby(radiusKm: 10.0, limit: 50);

    if (mounted) {
      loaderProvider.hide();

      if (doctorProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(doctorProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDoctorDetails(BuildContext context, doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                doctor.name,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (doctor.specialty != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.medical_services,
                        size: 18, color: AppStyles.accentPurple),
                    const SizedBox(width: 8),
                    Text(
                      doctor.specialty!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppStyles.accentPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              if (doctor.address != null)
                _InfoRow(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: doctor.address!,
                ),
              if (doctor.phone != null)
                _InfoRow(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: doctor.phone!,
                ),
              if (doctor.openingHours != null)
                _InfoRow(
                  icon: Icons.access_time,
                  label: 'Hours',
                  value: doctor.openingHours!,
                ),
              if (doctor.distanceKm != null)
                _InfoRow(
                  icon: Icons.directions,
                  label: 'Distance',
                  value: '${doctor.distanceKm!.toStringAsFixed(2)} km',
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement navigation/directions
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Navigation feature coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions),
                  label: Text(
                    'Get Directions',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (doctor.phone != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement phone call
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${doctor.phone}...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone),
                    label: Text(
                      'Call Now',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppStyles.secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppStyles.secondaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: AppBar(
        title: Text(
          'Nearby Doctors',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppStyles.accentPurple,
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
      body: Consumer<DoctorProvider>(
        builder: (context, provider, _) {
          if (provider.doctors.isEmpty && !provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No doctors found nearby',
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
                          'Found ${provider.doctors.length} doctors near you',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppStyles.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Doctors grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: provider.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = provider.doctors[index];
                    return DoctorCard(
                      doctor: doctor,
                      onTap: () => _showDoctorDetails(context, doctor),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppStyles.secondaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
