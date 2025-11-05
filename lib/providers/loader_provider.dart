import 'package:flutter/material.dart';

class LoaderProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void show() {
    print('🔄 LoaderProvider: showing loader');
    _isLoading = true;
    notifyListeners();
  }

  void hide() {
    print('✅ LoaderProvider: hiding loader');
    _isLoading = false;
    notifyListeners();
  }
}
