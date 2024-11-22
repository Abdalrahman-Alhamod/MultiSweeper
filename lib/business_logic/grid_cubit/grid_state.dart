part of 'grid_cubit.dart';

@immutable
sealed class GridState {}

final class GridInitial extends GridState {}

final class GridUpdate extends GridState {
  final Grid grid;
  final bool isMinesReveled;
  final bool isGameOver;
  final int flagsCount;
  GridUpdate(this.grid, this.isMinesReveled, this.isGameOver, this.flagsCount);
}

final class GameStart extends GridState {}

final class GameRestart extends GridState {}

final class GameOver extends GridState {
  final bool win;
  GameOver({required this.win});
}
