import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/styles.dart';
import '../login_screen/login_screen.dart';
import '../../providers/loader_provider.dart';

class LaunchingScreen extends StatefulWidget {
  const LaunchingScreen({super.key});

  @override
  State<LaunchingScreen> createState() => _LaunchingScreenState();
}

class _LaunchingScreenState extends State<LaunchingScreen>
    with SingleTickerProviderStateMixin {
  // bool _showContent = false; // no longer used; using _visible for stagger
  // animation controller values for stagger
  final List<bool> _visible = [false, false, false];

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    // Show the welcome content after a 5 second delay
    Timer(const Duration(seconds: 5), () async {
      if (!mounted) return;
      // staggered reveal: title -> description -> button
      for (var i = 0; i < _visible.length; i++) {
        await Future.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        setState(() => _visible[i] = true);
      }
    });

    // Play the animation once — stop when it completes
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // ensure it doesn't loop
        if (mounted && _lottieController.isAnimating) {
          _lottieController.stop();
        }
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie animation (3D JSON can be placed at assets/animations/launch.json)
                SizedBox(
                  height: 320,
                  child: Lottie.asset(
                    'assets/animations/3D Doctor Dancing.json',
                    fit: BoxFit.contain,
                    controller: _lottieController,
                    onLoaded: (composition) {
                      // configure the animation duration and start playing
                      _lottieController.duration = composition.duration;
                      _lottieController.forward();
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Welcome content appears after delay
                // Staggered animated content
                Column(
                  children: [
                    // Title
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _visible[0] ? 1.0 : 0.0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 600),
                        offset:
                            _visible[0] ? Offset.zero : const Offset(0, 0.2),
                        child: Text(
                          'Welcome to ALKALI DWE app',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: AppStyles.textColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _visible[1] ? 1.0 : 0.0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 600),
                        offset:
                            _visible[1] ? Offset.zero : const Offset(0, 0.2),
                        child: Text(
                          'It helps users to find nearby pharmacies and doctors and get information',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Button
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _visible[2] ? 1.0 : 0.0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 600),
                        offset:
                            _visible[2] ? Offset.zero : const Offset(0, 0.2),
                        child: SizedBox(
                          width: 180,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!mounted) return;

                              final navigator = Navigator.of(context);
                              final loaderProvider =
                                  Provider.of<LoaderProvider>(context,
                                      listen: false);

                              loaderProvider.show();

                              // Wait for at least 3 seconds
                              await Future.delayed(const Duration(seconds: 3));

                              if (!mounted) return;
                              loaderProvider.hide();

                              navigator.pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.poppins(
                                textStyle:
                                    AppStyles.buttonText.copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
