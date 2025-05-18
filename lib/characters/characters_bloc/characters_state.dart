part of 'characters_bloc.dart';

sealed class CharactersState extends Equatable {
  final List<Character> characters;
  final List<Character> favoriteCharacters;
  final bool isLoading;
  final String? error;

  const CharactersState({
    this.characters = const [],
    this.favoriteCharacters = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [characters, favoriteCharacters, isLoading, error];
}

class InitialCharactersState extends CharactersState {
  const InitialCharactersState() : super();
}

class LoadingCharactersState extends CharactersState {
  const LoadingCharactersState({
    required super.characters,
    required super.favoriteCharacters,
  }) : super(isLoading: true);
}

class ErrorCharactersState extends CharactersState {
  const ErrorCharactersState({
    required super.characters,
    required super.favoriteCharacters,
    required String super.error,
  });
}

class LoadedCharactersState extends CharactersState {
  const LoadedCharactersState({
    required super.characters,
    required super.favoriteCharacters,
  });
}

class ChangingFavoriteCharactersState extends CharactersState {
  const ChangingFavoriteCharactersState({
    required super.characters,
    required super.favoriteCharacters,
  });
}

class ChangedFavoriteCharactersState extends CharactersState {
  const ChangedFavoriteCharactersState({
    required super.characters,
    required super.favoriteCharacters,
  });
}

class SortingFavoriteCharactersState extends CharactersState {
  const SortingFavoriteCharactersState({
    required super.characters,
    required super.favoriteCharacters,
  });
}

class SortedFavoriteCharactersState extends CharactersState {
  const SortedFavoriteCharactersState({
    required super.characters,
    required super.favoriteCharacters,
  });
}
