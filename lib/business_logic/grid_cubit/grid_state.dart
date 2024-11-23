part of 'grid_cubit.dart';

@immutable
sealed class GridState {}

final class GridInitial extends GridState {}

final class GridUpdate extends GridState {
  final Grid grid;
  final bool isMinesReveled;
  final bool isGameOver;
  final int flagsCount;
  GridUpdate(
    this.grid,
    this.isMinesReveled,
    this.isGameOver,
    this.flagsCount,
  );
}

final class GameStart extends GridState {}

final class GameRestart extends GridState {}

final class GameTimeUpdate extends GridState {
  final int time;
  GameTimeUpdate(this.time);
}

final class GameOver extends GridState {
  final bool win;
  GameOver({required this.win});
}

final class GameSaveLoading extends GridState {}

final class GameSaveSuccess extends GridState {}

final class GameSaveFailure extends GridState {
  final String error;

  GameSaveFailure({required this.error});
}

final class GameLoadSuccess extends GridState {}

final class GameLoadFailure extends GridState {
  final String error;

  GameLoadFailure({required this.error});
}

final class GameDeleteLoading extends GridState {}

final class GameDeleteSuccess extends GridState {}

final class GameDeleteFailure extends GridState {
  final String error;

  GameDeleteFailure({required this.error});
}
