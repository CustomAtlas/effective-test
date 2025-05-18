import 'package:effective_test/core/local_storages/shared_preferences.dart';
import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static const isDarkThemeKey = 'is_dark_theme';

  bool _isDarkTheme = false;

  ThemeProvider(BuildContext context) {
    _loadThemeFromPrefs(context);
  }

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveThemeToPrefs();
    notifyListeners();
  }

  void _loadThemeFromPrefs(BuildContext context) {
    _isDarkTheme = SharedPrefs.getData(key: isDarkThemeKey, type: DataType.bool) ?? context.colors.isDarkTheme();
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs() async {
    await SharedPrefs.setData(key: isDarkThemeKey, data: _isDarkTheme, type: DataType.bool);
  }
}

class ThemeInherited extends InheritedNotifier<ThemeProvider> {
  const ThemeInherited({
    required super.notifier,
    required super.child,
    super.key,
  });

  // Метод для получения провайдера из контекста
  static ThemeProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeInherited>();
    assert(result != null, 'No ThemeProvider found in context');
    return result!.notifier!;
  }
}
