import 'package:effective_test/characters/characters_bloc/characters_bloc.dart';
import 'package:effective_test/characters/widgets/character_widget.dart';
import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:effective_test/core/utils/show_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharactersBloc, CharactersState>(
      listener: (context, state) {
        if (state is ErrorCharactersState && state.error != null) ShowMessage.showMessage(context, state.error ?? '');
      },
      builder: (context, state) {
        if (state.characters.isEmpty && (state is LoadedCharactersState || state is ErrorCharactersState)) {
          return Center(
            child: RichText(
              text: TextSpan(
                text: "Something went wrong. Check your internet connection and ",
                style: TextStyle(fontSize: 18, color: context.colors.textGray),
                children: [
                  TextSpan(
                    text: "tap on me",
                    style: TextStyle(
                      fontSize: 18,
                      color: context.colors.startNameGradient,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.read<CharactersBloc>().add(LoadCharactersEvent());
                      },
                  ),
                ],
              ),
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
          itemCount: state.characters.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, i) {
            if (state.characters.isEmpty || state.isLoading && i == state.characters.length) {
              return SizedBox(
                height: 66,
                width: 66,
                child: Center(
                  child: CircularProgressIndicator(
                    color: context.colors.startNameGradient,
                  ),
                ),
              );
            }
            if (!state.isLoading && i == state.characters.length - 3) {
              context.read<CharactersBloc>().add(LoadCharactersEvent());
            }
            final character = state.characters[state.isLoading ? i - 1 : i];
            return CharacterWidget(
              character,
              isMainScreen: true,
              index: i,
              key: ValueKey(character.id),
            );
          },
        );
      },
    );
  }
}
