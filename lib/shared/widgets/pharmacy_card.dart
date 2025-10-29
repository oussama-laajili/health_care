import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/styles.dart';
import '../../entities/pharmacy.dart';

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;
  final double imageHeight;
  final VoidCallback? onTap;

  const PharmacyCard({
    super.key,
    required this.pharmacy,
    this.imageHeight = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = pharmacy.isOpen;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon and status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppStyles.secondaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.local_pharmacy,
                      color: AppStyles.secondaryColor,
                      size: 24,
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOpen ? AppStyles.secondaryColor : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isOpen ? 'OPEN' : 'CLOSED',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Pharmacy name
              Text(
                pharmacy.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppStyles.textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Distance
              if (pharmacy.distanceKm != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${pharmacy.distanceKm!.toStringAsFixed(2)} km',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              // Pharmacy name
              Text(
                pharmacy.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppStyles.textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Distance
              if (pharmacy.distanceKm != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${pharmacy.distanceKm!.toStringAsFixed(2)} km',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
