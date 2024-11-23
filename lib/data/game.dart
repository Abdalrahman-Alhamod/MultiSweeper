import 'dart:async';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:minesweeper/data/grid.dart';
import 'package:minesweeper/data/grid_action.dart';
import 'package:minesweeper/data/position.dart';
import 'package:minesweeper/helpers/stack.dart';
part 'game.g.dart';

@HiveType(typeId: 5)
class Game extends HiveObject {
  @HiveField(0)
  late Grid grid;
  @HiveField(1)
  int minesCount;
  @HiveField(2)
  int usedFlagsCount;
  @HiveField(3)
  int saveCellsOpenedCount;
  @HiveField(4)
  bool isFirstCellOpened;
  @HiveField(5)
  bool isGameOver;
  @HiveField(6)
  int time;
  Timer? _timer;
  bool isGameStarted;
  DStack<GridAction> previousActions;
  DStack<GridAction> nextActions;
  void Function() onStart;
  void Function() onRestart;
  void Function() onWin;
  void Function() onLose;
  void Function() onUpdate;
  void Function() onTimeUpdate;

  Game(
    this.grid,
    this.minesCount,
    this.usedFlagsCount,
    this.saveCellsOpenedCount,
    this.isFirstCellOpened,
    this.isGameOver,
    this.time,
  )   : onLose = (() {}),
        onRestart = (() {}),
        onStart = (() {}),
        onUpdate = (() {}),
        onWin = (() {}),
        onTimeUpdate = (() {}),
        nextActions = DStack.empty(),
        previousActions = DStack.empty(),
        isGameStarted = false;

  Game.clone(Game game)
      : this(
          Grid.clone(game.grid),
          game.minesCount,
          game.usedFlagsCount,
          game.saveCellsOpenedCount,
          game.isFirstCellOpened,
          game.isGameOver,
          game.time,
        );

  Game.init({
    required int rowsCount,
    required int columnsCount,
    required this.minesCount,
    required this.onStart,
    required this.onRestart,
    required this.onWin,
    required this.onLose,
    required this.onUpdate,
    required this.onTimeUpdate,
  })  : grid = Grid.generate(rowsCount: rowsCount, columnsCount: columnsCount),
        previousActions = DStack.empty(),
        nextActions = DStack.empty(),
        usedFlagsCount = 0,
        saveCellsOpenedCount = 0,
        isGameOver = false,
        isFirstCellOpened = false,
        isGameStarted = false,
        time = 0;

  int get flagsCount => minesCount - usedFlagsCount;

  void plantMines({required Position exludedPosition}) {
    int plantedMines = minesCount;
    while (plantedMines > 0) {
      Random random = Random();
      int randomX = random.nextInt(grid.columnsCount);
      int randomY = random.nextInt(grid.rowsCount);
      if (!grid.getCell(randomX, randomY).isMined &&
          (randomX != exludedPosition.x || randomY != exludedPosition.y)) {
        grid.getCell(randomX, randomY).plantMine();
        plantedMines--;
        grid.runOnAdjacentCells(
          randomX,
          randomY,
          (cell) {
            if (!cell.isMined) {
              cell.incrementAdjacentMinesCount();
            }
          },
        );
      }
    }
  }

  void setOnActions({
    required void Function() onStart,
    required void Function() onRestart,
    required void Function() onWin,
    required void Function() onLose,
    required void Function() onUpdate,
    required void Function() onTimeUpdate,
  }) {
    this.onStart = onStart;
    this.onRestart = onRestart;
    this.onWin = onWin;
    this.onLose = onLose;
    this.onUpdate = onUpdate;
    this.onTimeUpdate = onTimeUpdate;
  }

  void resetActionsStacks() {
    previousActions.clear();
    nextActions.clear();
  }

  void execute({required GridAction action}) {
    action.run(game: this);
    nextActions.clear();
    previousActions.push(action);
    update();
  }

  void undo() {
    if (previousActions.isEmpty || isGameOver) {
      return;
    }
    GridAction lastAction = previousActions.pop();
    nextActions.push(lastAction);
    lastAction.undo(game: this);
    update();
  }

  void redo() {
    if (nextActions.isEmpty || isGameOver) {
      return;
    }
    GridAction nextAction = nextActions.pop();
    previousActions.push(nextAction);
    nextAction.redo(game: this);
    update();
  }

  bool checkWin() {
    return saveCellsOpenedCount == (grid.getCellsCount() - minesCount);
  }

  void endWithWin() {
    isGameOver = true;
    _cancelTimer();
    onWin.call();
  }

  void endWithLoss() {
    grid.revealMines = true;
    isGameOver = true;
    _cancelTimer();
    onLose.call();
  }

  void restart() {
    usedFlagsCount = 0;
    saveCellsOpenedCount = 0;
    isFirstCellOpened = false;
    isGameOver = false;
    grid = Grid.generate(
      rowsCount: grid.rowsCount,
      columnsCount: grid.columnsCount,
    );
    previousActions.clear();
    nextActions.clear();
    update();
    isGameStarted = false;
    time = 0;
    _cancelTimer();
    onRestart.call();
  }

  void start() {
    isGameStarted = true;
    _startTimer();
    onStart.call();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => incrementTimer(),
    );
  }

  void dispose() {
    _cancelTimer();
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  void incrementTimer() {
    time++;
    onTimeUpdate.call();
  }

  void update() {
    onUpdate.call();
  }
}
