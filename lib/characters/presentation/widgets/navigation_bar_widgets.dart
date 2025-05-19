import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:flutter/material.dart';

class SelectedBottomBarItem extends StatelessWidget {
  const SelectedBottomBarItem(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: context.colors.commonColor);
  }
}

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: context.colors.invertedScaffold);
  }
}
