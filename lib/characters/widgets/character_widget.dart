import 'package:cached_network_image/cached_network_image.dart';
import 'package:effective_test/characters/characters_bloc/characters_bloc.dart';
import 'package:effective_test/core/data/character_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterWidget extends StatefulWidget {
  final Character character;
  final bool isMainScreen;
  final int index;

  const CharacterWidget(
    this.character, {
    super.key,
    this.isMainScreen = false,
    this.index = 0,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> offsetAnimation;
  bool isAnimating = false;
  bool isIndexEven = true;
  double turns = 0;

  @override
  void initState() {
    super.initState();
    isIndexEven = widget.index % 2 == 0;
    turns = isIndexEven ? -0.2 : 0.2;
    controller = AnimationController(duration: const Duration(milliseconds: 1400), vsync: this);
    final dx = isIndexEven ? 180.0 : -40.0;
    final dy = 800.0;
    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx, dy),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    Future.delayed(Duration.zero, () {
      if (!context.mounted || !mounted) return;
      final isFavorite =
          context.read<CharactersBloc>().state.favoriteCharacters.where((c) => c.id == widget.character.id).isNotEmpty;
      if (isFavorite) controller.value = 1.0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> onStarTap(BuildContext context, bool isFavorite) async {
    if (widget.isMainScreen) {
      isFavorite ? controller.reverse() : controller.forward();
      context.read<CharactersBloc>().add(ChangeFavoriteEvent(widget.character, isFavorite));
    } else {
      isAnimating = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        final isFavorite = state.favoriteCharacters.where((c) => c.id == widget.character.id).isNotEmpty;
        return AnimatedRotation(
          turns: isAnimating ? turns : 0,
          alignment: isIndexEven ? Alignment.bottomLeft : Alignment.bottomRight,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          onEnd: () {
            context.read<CharactersBloc>().add(ChangeFavoriteEvent(widget.character, isFavorite));
          },
          child: AnimatedOpacity(
            opacity: isAnimating ? 0 : 1,
            duration: Duration(milliseconds: 1200),
            child: DecoratedBox(
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
                              imageUrl: widget.character.image,
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
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: offsetAnimation.value,
                                child: child,
                              );
                            },
                            child: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                              size: 24,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            onTap: () async => await onStarTap(context, isFavorite),
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
                        widget.character.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Status: ${widget.character.status}'),
                          Text('Species: ${widget.character.species}'),
                          Text('Gender: ${widget.character.gender}'),
                          Text('From: ${widget.character.origin}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
