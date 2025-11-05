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
            print('🎯 GlobalLoader: isLoading = ${loaderProvider.isLoading}');
            if (!loaderProvider.isLoading) {
              return const SizedBox.shrink();
            }

            return Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  'assets/animations/loader.json',
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
