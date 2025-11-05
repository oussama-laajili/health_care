import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/loader_provider.dart';

extension LoaderExtension on BuildContext {
  /// Show the global loader
  void showLoader() {
    if (mounted) {
      read<LoaderProvider>().show();
    }
  }

  /// Hide the global loader
  void hideLoader() {
    if (mounted) {
      read<LoaderProvider>().hide();
    }
  }

  /// Execute an async function with loader shown (minimum 2 seconds)
  Future<T> withLoader<T>(Future<T> Function() action) async {
    showLoader();

    // Start the action and a minimum delay simultaneously
    final startTime = DateTime.now();

    try {
      final result = await action();

      // Calculate how much time has passed
      final elapsed = DateTime.now().difference(startTime);
      const minimumDuration = Duration(seconds: 1);

      // If less than 2 seconds, wait for the remainder
      if (elapsed < minimumDuration) {
        final remainingTime = minimumDuration - elapsed;
        await Future.delayed(remainingTime);
      }

      return result;
    } finally {
      if (mounted) {
        hideLoader();
      }
    }
  }
}
