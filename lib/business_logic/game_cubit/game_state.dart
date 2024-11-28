part of 'game_cubit.dart';

@immutable
sealed class GameState {}

final class GameInitial extends GameState {}

final class GameUpdate extends GameState {
  final String gamdId;
  final Grid grid;
  final bool isMinesReveled;
  final bool isGameOver;
  final int flagsCount;
  GameUpdate(
    this.grid,
    this.isMinesReveled,
    this.isGameOver,
    this.flagsCount,
    this.gamdId,
  );
}

final class GameStart extends GameState {
  final String gamdId;

  GameStart(this.gamdId);
}

final class GameRestart extends GameState {
  final String gamdId;

  GameRestart(this.gamdId);
}

final class GameTimeUpdate extends GameState {
  final int time;
  final String gamdId;
  GameTimeUpdate(this.time, this.gamdId);
}

final class GameOver extends GameState {
  final bool win;
  final String gamdId;
  GameOver(this.gamdId, {required this.win});
}

final class GameSaveLoading extends GameState {}

final class GameSaveSuccess extends GameState {}

final class GameSaveFailure extends GameState {
  final String error;

  GameSaveFailure({required this.error});
}

final class GameLoadSuccess extends GameState {}

final class GameLoadLoading extends GameState {}

final class GameLoadFailure extends GameState {
  final String error;

  GameLoadFailure({required this.error});
}

final class GameDeleteLoading extends GameState {}

final class GameDeleteSuccess extends GameState {}

final class GameDeleteFailure extends GameState {
  final String error;

  GameDeleteFailure({required this.error});
}

final class GameAdd extends GameState {}

final class FetchAllSavedGamesSuccess extends GameState {
  final List<GameSave> savedGames;

  FetchAllSavedGamesSuccess(this.savedGames);
}

final class FetchAllSavedGamesLoading extends GameState {}

final class FetchAllSavedGamesFailure extends GameState {
  final String error;

  FetchAllSavedGamesFailure({required this.error});
}
