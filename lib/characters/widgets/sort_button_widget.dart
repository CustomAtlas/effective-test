import 'package:effective_test/characters/characters_bloc/characters_bloc.dart';
import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortButtonWidget extends StatelessWidget {
  const SortButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      focusColor: Colors.transparent,
      onTap: () {
        context.read<CharactersBloc>().add(SortFavoriteEvent());
      },
      child: Icon(
        Icons.sort_by_alpha,
        color: context.colors.text,
      ),
    );
  }
}
