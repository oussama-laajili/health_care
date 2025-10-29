import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../constants/styles.dart';
import '../../../entities/doctor.dart';
import '../../../shared/widgets/doctor_card.dart';
import '../../doctor/doctor_search_screen.dart';

class DoctorCarousel extends StatefulWidget {
  final List<Doctor> doctors;

  const DoctorCarousel({super.key, required this.doctors});

  @override
  State<DoctorCarousel> createState() => _DoctorCarouselState();
}

class _DoctorCarouselState extends State<DoctorCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDoctorDetails(BuildContext context, Doctor doctor) {
    // Navigate to doctor search screen for details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorSearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.doctors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Doctors',
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

        // Carousel
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.doctors.length,
            itemBuilder: (context, index) {
              final doctor = widget.doctors[index];
              final isFocused = index == _currentPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(
                  horizontal: isFocused ? 4 : 12,
                  vertical: isFocused ? 0 : 15,
                ),
                transform: Matrix4.identity()..scale(isFocused ? 1.0 : 0.9),
                child: DoctorCard(
                  doctor: doctor,
                  height: 150,
                  onTap: () => _showDoctorDetails(context, doctor),
                ),
              );
            },
          ),
        ),

        // Page indicator
        const SizedBox(height: 12),
        Center(
          child: SmoothPageIndicator(
            controller: _controller,
            count: widget.doctors.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppStyles.accentPurple,
              dotColor: AppStyles.accentPurple.withValues(alpha: 0.3),
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 3,
            ),
          ),
        ),
      ],
    );
  }
}
