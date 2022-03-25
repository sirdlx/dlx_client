import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../store/store_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this.storeService);

  final StoreService storeService;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => ThemeMode.system;

  Future<void> loadSettings() async {
    var __themeMode = await storeService.get('themeMode');

    if (kDebugMode) {
      print(__themeMode);
    }

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await storeService.put('themeMode', newThemeMode);
  }
}
