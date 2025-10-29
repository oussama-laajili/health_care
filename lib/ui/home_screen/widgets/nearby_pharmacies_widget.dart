import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants/styles.dart';
import '../../../providers/pharmacy_provider.dart';
import '../../../providers/loader_provider.dart';
import '../../../shared/widgets/pharmacy_card.dart';
import '../../pharmacy/pharmacy_search_screen.dart';

class NearbyPharmaciesWidget extends StatelessWidget {
  const NearbyPharmaciesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(
      builder: (context, provider, _) {
        // Get first 4 pharmacies
        final pharmacies = provider.pharmacies.take(4).toList();

        if (pharmacies.isEmpty) {
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
                    'Nearby Pharmacies',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Show loader while navigating
                      final loaderProvider = context.read<LoaderProvider>();
                      loaderProvider.show();

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PharmacySearchScreen(),
                        ),
                      );

                      loaderProvider.hide();
                    },
                    child: Row(
                      children: [
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.secondaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppStyles.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2x2 Grid of pharmacy cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1, // Reduced height
                ),
                itemCount: pharmacies.length,
                itemBuilder: (context, index) {
                  final pharmacy = pharmacies[index];
                  return PharmacyCard(
                    pharmacy: pharmacy,
                    imageHeight: 70, // Decreased height
                    onTap: () async {
                      // Show loader while navigating
                      final loaderProvider = context.read<LoaderProvider>();
                      loaderProvider.show();

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PharmacySearchScreen(),
                        ),
                      );

                      loaderProvider.hide();
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
