import 'package:cached_network_image/cached_network_image.dart';
import 'package:effective_test/characters/characters_bloc/characters_bloc.dart';
import 'package:effective_test/core/data/character_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterWidget extends StatelessWidget {
  final Character character;

  const CharacterWidget(this.character, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        final isFavorite = state.favoriteCharacters.where((c) => c.id == character.id).isNotEmpty;
        return DecoratedBox(
          decoration: ShapeDecoration(
            color: Color.fromARGB(120, 204, 255, 255),
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: character.image,
                          width: 170,
                          height: 170,
                          errorWidget: (_, __, ___) => Icon(
                            Icons.no_photography_outlined,
                            size: 170,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                        onTap: () {
                          context.read<CharactersBloc>().add(ChangeFavoriteEvent(character, isFavorite));
                        },
                        child: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Center(
                  child: Text(
                    character.name,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Status: ${character.status}'),
                      Text('Species: ${character.species}'),
                      Text('Gender: ${character.gender}'),
                      Text('From: ${character.origin}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
