import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:drift/drift.dart';
import 'package:effective_test/core/data/api.dart';
import 'package:effective_test/core/data/character_model.dart';
import 'package:effective_test/core/local_storages/database.dart' as db;
import 'package:effective_test/core/local_storages/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final ApiClient _apiClient;
  final db.AppDatabase _database;
  CharactersBloc(this._apiClient, this._database) : super(const InitialCharactersState()) {
    on<CharactersEvent>(
      (event, emit) async {
        switch (event) {
          case LoadCharactersEvent():
            await _loadCharacters(event, emit);
          case ChangeFavoriteEvent():
            await _changeFavorite(event, emit);
          case SortFavoriteEvent():
            await _sortFavorite(event, emit);
        }
      },
      transformer: sequential(),
    );
    page = SharedPrefs.getData(key: pageKey, type: DataType.int) ?? 1;
  }

  final List<Character> _characters = [];
  final List<Character> _favoriteCharacters = [];
  int page = 1;
  final pageKey = 'page_key';
  bool hasLastLoadFromDB = false;
  bool hasSorted = false;
  bool hasFirstLoadFromDB = false;

  Future<void> _loadCharacters(
    LoadCharactersEvent event,
    Emitter<CharactersState> emit,
  ) async {
    try {
      final response = await _apiClient.getCharacters(page);
      if (response == null && hasLastLoadFromDB) return;
      emit(LoadingCharactersState(
        characters: _characters,
        favoriteCharacters: _favoriteCharacters,
      ));
      if (response == null) {
        final dbCharacters = (await _database.characters.select().get()).map((e) => Character.fromJson(e.character));
        if (dbCharacters.isEmpty) {
          emit(ErrorCharactersState(
            characters: _characters,
            favoriteCharacters: _favoriteCharacters,
            error: 'Something went wrong. Check your internet connection or try again later',
          ));
        } else {
          if (hasLastLoadFromDB || hasFirstLoadFromDB) {
            emit(LoadedCharactersState(
              characters: _characters,
              favoriteCharacters: _favoriteCharacters,
            ));
            hasLastLoadFromDB = true;
            return;
          }
          _characters.addAll(dbCharacters);
          _favoriteCharacters.addAll(dbCharacters.where((c) => c.isFavorite));
          emit(LoadedCharactersState(
            characters: _characters,
            favoriteCharacters: _favoriteCharacters,
          ));
          hasLastLoadFromDB = true;
          hasFirstLoadFromDB = true;
        }
        return;
      }
      if (!hasFirstLoadFromDB) {
        final dbCharacters = (await _database.characters.select().get()).map((e) => Character.fromJson(e.character));
        if (dbCharacters.isNotEmpty) {
          _characters.addAll(dbCharacters);
          _favoriteCharacters.addAll(dbCharacters.where((c) => c.isFavorite));
          hasFirstLoadFromDB = true;
        }
      }
      hasLastLoadFromDB = false;
      page++;
      SharedPrefs.setData(key: pageKey, type: DataType.int, data: page);
      _characters.addAll(response);
      emit(LoadedCharactersState(
        characters: _characters,
        favoriteCharacters: _favoriteCharacters,
      ));
      await _database.batch(
        (batch) {
          batch.insertAll(
            _database.characters,
            response.map(
              (e) => db.CharactersCompanion.insert(
                id: Value(e.id),
                character: e.toJson(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(ErrorCharactersState(
        characters: _characters,
        favoriteCharacters: _favoriteCharacters,
        error: 'Something went wrong. Check your internet connection or try again later',
      ));
    }
  }

  Future<void> _changeFavorite(
    ChangeFavoriteEvent event,
    Emitter<CharactersState> emit,
  ) async {
    emit(ChangingFavoriteCharactersState(
      characters: _characters,
      favoriteCharacters: _favoriteCharacters,
    ));
    try {
      var character = await _database.managers.characters.filter((c) => c.id(event.character.id)).getSingle();
      character = character.copyWith(character: event.character.copyWith(isFavorite: !event.isFavorite).toJson());
      await _database.managers.characters.replace(character);
      event.isFavorite
          ? _favoriteCharacters.removeWhere((c) => c.id == event.character.id)
          : _favoriteCharacters.add(event.character);
      emit(ChangedFavoriteCharactersState(
        characters: _characters,
        favoriteCharacters: _favoriteCharacters,
      ));
    } catch (e) {
      emit(ErrorCharactersState(
        characters: _characters,
        favoriteCharacters: _favoriteCharacters,
        error: 'Something went wrong. Try again later',
      ));
    }
  }

  Future<void> _sortFavorite(
    SortFavoriteEvent event,
    Emitter<CharactersState> emit,
  ) async {
    emit(SortingFavoriteCharactersState(
      characters: _characters,
      favoriteCharacters: _favoriteCharacters,
    ));
    try {
      hasSorted
          ? _favoriteCharacters.sort((a, b) => a.name.compareTo(b.name))
          : _favoriteCharacters.sort((a, b) => b.name.compareTo(a.name));
      hasSorted = !hasSorted;
      emit(SortedFavoriteCharactersState(
        characters: _characters,
        favoriteCharacters: _favoriteCharacters,
      ));
    } catch (e) {
      emit(ErrorCharactersState(
        characters: _characters,
        favoriteCharacters: _favoriteCharacters,
        error: 'Something went wrong. Try again later',
      ));
    }
  }
}
