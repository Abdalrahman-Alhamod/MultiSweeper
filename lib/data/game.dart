import 'dart:async';
import 'dart:math';

import 'grid.dart';
import 'grid_action.dart';
import 'position.dart';
import '../helpers/stack.dart';

class Game {
  late Grid _grid;
  final int _minesCount;
  int usedFlagsCount;
  int saveCellsOpenedCount;
  bool _isFirstCellOpened;
  bool _isGameOver;
  int _time;
  final String _id;
  final DStack<GridAction> _previousActions;
  final DStack<GridAction> _nextActions;
  bool _isGameStarted;
  Timer? _timer;
  void Function() _onStart;
  void Function() _onRestart;
  void Function() _onWin;
  void Function() _onLose;
  void Function() _onUpdate;
  void Function() _onTimeUpdate;

  Map<String, dynamic> toJson() => {
        'grid': _grid.toJson(),
        'minesCount': _minesCount,
        'usedFlagsCount': usedFlagsCount,
        'saveCellsOpenedCount': saveCellsOpenedCount,
        'isFirstCellOpened': _isFirstCellOpened,
        'isGameOver': _isGameOver,
        'time': _time,
        'id': _id,
        'previousActions':
            _previousActions.toJson((gridAction) => gridAction.toJson()),
        'nextActions': _nextActions.toJson((gridAction) => gridAction.toJson()),
      };

  static Game fromJson(
    Map<String, dynamic> json,
  ) {
    return Game(
      Grid.fromJson(json['grid']),
      json['minesCount'],
      json['usedFlagsCount'],
      json['saveCellsOpenedCount'],
      json['isFirstCellOpened'],
      json['isGameOver'],
      json['time'],
      json['id'],
      DStack.fromJson(
          json['previousActions'], (json) => GridAction.fromJson(json)),
      DStack.fromJson(json['nextActions'], (json) => GridAction.fromJson(json)),
    );
  }

  Game(
    this._grid,
    this._minesCount,
    this.usedFlagsCount,
    this.saveCellsOpenedCount,
    this._isFirstCellOpened,
    this._isGameOver,
    this._time,
    this._id,
    this._previousActions,
    this._nextActions,
  )   : _onLose = (() {}),
        _onRestart = (() {}),
        _onStart = (() {}),
        _onUpdate = (() {}),
        _onWin = (() {}),
        _onTimeUpdate = (() {}),
        _isGameStarted = false;

  Game.init({
    required int rowsCount,
    required int columnsCount,
    required int minesCount,
    required void Function() onStart,
    required void Function() onRestart,
    required void Function() onWin,
    required void Function() onLose,
    required void Function() onUpdate,
    required void Function() onTimeUpdate,
    required String id,
  })  : _minesCount = minesCount,
        _onTimeUpdate = onTimeUpdate,
        _onUpdate = onUpdate,
        _onLose = onLose,
        _onWin = onWin,
        _onRestart = onRestart,
        _onStart = onStart,
        _id = id,
        _grid = Grid.generate(rowsCount: rowsCount, columnsCount: columnsCount),
        _previousActions = DStack.empty(),
        _nextActions = DStack.empty(),
        usedFlagsCount = 0,
        saveCellsOpenedCount = 0,
        _isGameOver = false,
        _isFirstCellOpened = false,
        _isGameStarted = false,
        _time = 0;

  int get flagsCount => _minesCount - usedFlagsCount;

  int get time => _time;

  String get id => _id;

  bool get isGameOver => _isGameOver;

  Grid get grid => _grid;

  void _plantMines({required Position exludedPosition}) {
    int plantedMines = _minesCount;
    while (plantedMines > 0) {
      Random random = Random();
      int randomX = random.nextInt(_grid.columnsCount);
      int randomY = random.nextInt(_grid.rowsCount);
      if (!_grid.getCell(randomX, randomY).isMined &&
          (randomX != exludedPosition.x || randomY != exludedPosition.y)) {
        _grid.getCell(randomX, randomY).plantMine();
        plantedMines--;
        _grid.runOnAdjacentCells(
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

  void openFirstCell({required Position position}) {
    if (!_isFirstCellOpened) {
      _isFirstCellOpened = true;
      _plantMines(exludedPosition: position);
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
    _onStart = onStart;
    _onRestart = onRestart;
    _onWin = onWin;
    _onLose = onLose;
    _onUpdate = onUpdate;
    _onTimeUpdate = onTimeUpdate;
  }

  void execute({required GridAction action}) {
    action.run(game: this);
    _nextActions.clear();
    _previousActions.push(action);
    update();
  }

  void undo() {
    if (_previousActions.isEmpty || _isGameOver) {
      return;
    }
    GridAction lastAction = _previousActions.pop();
    _nextActions.push(lastAction);
    lastAction.undo(game: this);
    update();
  }

  void redo() {
    if (_nextActions.isEmpty || _isGameOver) {
      return;
    }
    GridAction nextAction = _nextActions.pop();
    _previousActions.push(nextAction);
    nextAction.redo(game: this);
    update();
  }

  bool checkWin() {
    return saveCellsOpenedCount == (_grid.getCellsCount() - _minesCount);
  }

  void endWithWin() {
    _isGameOver = true;
    _cancelTimer();
    _onWin.call();
  }

  void endWithLoss() {
    _grid.revealMines = true;
    _isGameOver = true;
    _cancelTimer();
    _onLose.call();
  }

  void restart() {
    usedFlagsCount = 0;
    saveCellsOpenedCount = 0;
    _isFirstCellOpened = false;
    _isGameOver = false;
    _grid = Grid.generate(
      rowsCount: _grid.rowsCount,
      columnsCount: _grid.columnsCount,
    );
    _previousActions.clear();
    _nextActions.clear();
    update();
    _isGameStarted = false;
    _time = 0;
    _cancelTimer();
    _onRestart.call();
    _onTimeUpdate.call();
  }

  void start() {
    if (!_isGameStarted) {
      _isGameStarted = true;
      _startTimer();
      _onStart.call();
    }
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
    _time++;
    if (_time > 999) {
      endWithLoss();
      update();
    } else {
      _onTimeUpdate.call();
    }
  }

  void update() {
    _onUpdate.call();
  }
}
