import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants/styles.dart';
import '../../../providers/doctor_provider.dart';
import '../../../shared/widgets/doctor_card.dart';
import '../../doctor/doctor_search_screen.dart';

class NearbyDoctorsWidget extends StatelessWidget {
  const NearbyDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProvider>(
      builder: (context, provider, _) {
        // Get first 4 doctors
        final doctors = provider.doctors.take(4).toList();

        if (doctors.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with See All button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Doctors',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DoctorSearchScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.accentPurple,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppStyles.accentPurple,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2x2 Grid of doctor cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return DoctorCard(
                    doctor: doctor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DoctorSearchScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
