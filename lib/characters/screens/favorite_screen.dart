import 'package:effective_test/characters/characters_bloc/characters_bloc.dart';
import 'package:effective_test/characters/widgets/character_widget.dart';
import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        if (state.favoriteCharacters.isEmpty) {
          return Center(
            child: Text(
              "You haven't add characters in favorite",
              style: TextStyle(fontSize: 18, color: context.colors.textGray),
              textAlign: TextAlign.center,
            ),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.45,
          ),
          itemCount: state.favoriteCharacters.length,
          itemBuilder: (context, i) {
            final character = state.favoriteCharacters[i];
            return CharacterWidget(character, index: i, key: ValueKey(character.id));
          },
        );
      },
    );
  }
}
