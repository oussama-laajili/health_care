import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/styles.dart';
import '../../entities/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onTap;
  final double height;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = doctor.isOpen;

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
                      color: AppStyles.accentPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: AppStyles.accentPurple,
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
                      color:
                          isAvailable ? AppStyles.secondaryColor : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isAvailable ? 'AVAILABLE' : 'UNAVAILABLE',
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

              // Doctor name
              Text(
                doctor.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppStyles.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Specialty
              if (doctor.specialty != null)
                Text(
                  doctor.specialty!,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppStyles.accentPurple,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 4),

              // Distance
              if (doctor.distanceKm != null)
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
                        '${doctor.distanceKm!.toStringAsFixed(2)} km',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
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
