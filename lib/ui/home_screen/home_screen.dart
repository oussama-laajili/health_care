import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/styles.dart';
import '../../providers/pharmacy_provider.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/loader_provider.dart';
import 'widgets/nearby_pharmacies_widget.dart';
import 'widgets/doctor_carousel.dart';
import '../doctor/doctor_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load nearby pharmacies and doctors on screen init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNearbyData();
    });
  }

  Future<void> _loadNearbyData() async {
    if (!mounted) return;

    final pharmacyProvider = context.read<PharmacyProvider>();
    final doctorProvider = context.read<DoctorProvider>();
    final loaderProvider = context.read<LoaderProvider>();

    loaderProvider.show();

    // Load both pharmacies and doctors in parallel
    await Future.wait([
      pharmacyProvider.searchNearby(radiusKm: 5.0, limit: 50),
      doctorProvider.searchNearby(radiusKm: 10.0, limit: 50),
    ]);

    if (mounted) {
      loaderProvider.hide();

      if (pharmacyProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(pharmacyProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: AppBar(
        title: Text(
          'ALKALI DWE',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppStyles.secondaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNearbyData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppStyles.secondaryColor,
                      AppStyles.secondaryColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find nearby healthcare services',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.local_pharmacy,
                        title: 'Pharmacies',
                        color: AppStyles.secondaryColor,
                        onTap: () {
                          // Already handled by nearby widget
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.medical_services,
                        title: 'Doctors',
                        color: AppStyles.accentPurple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DoctorSearchScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Nearby Pharmacies Widget
              const NearbyPharmaciesWidget(),

              const SizedBox(height: 24),

              // Doctor Carousel
              Consumer<DoctorProvider>(
                builder: (context, provider, _) {
                  return DoctorCarousel(doctors: provider.doctors);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppStyles.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
