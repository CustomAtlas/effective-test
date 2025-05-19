import 'package:effective_test/core/providers/theme_provider.dart';
import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:flutter/material.dart';

class ThemeSwitcherWidget extends StatefulWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  State<ThemeSwitcherWidget> createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isDarkMode = ThemeInherited.of(context).isDarkTheme;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: () => setState(() {
        isDarkMode = !isDarkMode;
        ThemeInherited.of(context).toggleTheme();
      }),
      child: Icon(
        isDarkMode ? Icons.wb_sunny : Icons.dark_mode_rounded,
        color: context.colors.text,
        size: 24,
      ),
    );
  }
}
