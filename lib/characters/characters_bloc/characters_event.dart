part of 'characters_bloc.dart';

sealed class CharactersEvent extends Equatable {}

class LoadCharactersEvent extends CharactersEvent {
  LoadCharactersEvent();

  @override
  List<Object?> get props => [];
}

class ChangeFavoriteEvent extends CharactersEvent {
  final Character character;
  final bool isFavorite;

  ChangeFavoriteEvent(this.character, this.isFavorite);

  @override
  List<Object?> get props => [character, isFavorite];
}

class SortFavoriteEvent extends CharactersEvent {
  SortFavoriteEvent();

  @override
  List<Object?> get props => [];
}
