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

  /// Execute an async function with loader shown
  Future<T> withLoader<T>(Future<T> Function() action) async {
    showLoader();
    try {
      return await action();
    } finally {
      if (mounted) {
        hideLoader();
      }
    }
  }
}
