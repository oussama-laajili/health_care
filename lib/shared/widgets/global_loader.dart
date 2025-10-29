import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../providers/loader_provider.dart';

class GlobalLoader extends StatelessWidget {
  final Widget child;

  const GlobalLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Consumer<LoaderProvider>(
          builder: (context, loaderProvider, _) {
            if (!loaderProvider.isLoading) {
              return const SizedBox.shrink();
            }

            return Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Lottie.asset(
                    'assets/animations/loader.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
