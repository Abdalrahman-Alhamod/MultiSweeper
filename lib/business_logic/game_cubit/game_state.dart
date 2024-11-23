part of 'game_cubit.dart';

@immutable
sealed class GameState {}

final class GameInitial extends GameState {}

final class GameUpdate extends GameState {
  final Grid grid;
  final bool isMinesReveled;
  final bool isGameOver;
  final int flagsCount;
  GameUpdate(
    this.grid,
    this.isMinesReveled,
    this.isGameOver,
    this.flagsCount,
  );
}

final class GameStart extends GameState {}

final class GameRestart extends GameState {}

final class GameTimeUpdate extends GameState {
  final int time;
  GameTimeUpdate(this.time);
}

final class GameOver extends GameState {
  final bool win;
  GameOver({required this.win});
}

final class GameSaveLoading extends GameState {}

final class GameSaveSuccess extends GameState {}

final class GameSaveFailure extends GameState {
  final String error;

  GameSaveFailure({required this.error});
}

final class GameLoadSuccess extends GameState {}

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
