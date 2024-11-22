import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/grid_cubit/grid_cubit.dart';
import 'package:minesweeper/data/cell.dart';
import 'package:minesweeper/data/grid_action.dart';
import 'package:minesweeper/data/grid_action_type.dart';
import 'package:minesweeper/helpers/app_font.dart';
import 'package:minesweeper/helpers/app_images.dart';

// ignore: must_be_immutable
class CellWidget extends StatelessWidget {
  CellWidget({
    super.key,
    required this.cell,
    this.isMinesReveled = false,
    required this.isGameOver,
  });
  Cell cell;
  final bool isMinesReveled;
  final bool isGameOver;
  @override
  Widget build(BuildContext context) {
    Color? fillColor = Colors.grey[300];
    Color? disabledColor = Colors.grey[300];
    Color? topBorderColor = Colors.grey[100];
    Color? bottomBorderColor = Colors.grey[500];
    double borderWidth = 6;
    return Material(
      child: InkWell(
        onTap: _getOnPressedAction(context),
        onLongPress: _getOnLongPressAction(context),
        child: Ink(
          decoration: BoxDecoration(
            border: _getOnPressedAction(context) != null
                ? Border(
                    top: BorderSide(
                      width: borderWidth,
                      color: topBorderColor!,
                    ),
                    left: BorderSide(
                      width: borderWidth,
                      color: topBorderColor,
                    ),
                    right: BorderSide(
                      width: borderWidth,
                      color: bottomBorderColor!,
                    ),
                    bottom: BorderSide(
                      width: borderWidth,
                      color: bottomBorderColor,
                    ),
                  )
                : null,
            color: cell.isMined && cell.isOpened && isMinesReveled
                ? Colors.red
                : _getOnPressedAction(context) == null
                    ? disabledColor
                    : fillColor,
          ),
          child: _getCellContent(),
        ),
      ),
    );
  }

  void Function()? _getOnPressedAction(BuildContext context) {
    if (isGameOver) {
      return null;
    }
    if (cell.isClosed) {
      // return () => context.read<GridCubit>().openCell(position: cell.position);
      return () => context.read<GridCubit>().execute(
            action: GridAction(
              actionType: GridActionType.open,
              position: cell.position,
            ),
          );
    } else if (cell.isOpened && !cell.isEmpty) {
      // return () => context.read<GridCubit>().chordCell(position: cell.position);
      return () => context.read<GridCubit>().execute(
            action: GridAction(
              actionType: GridActionType.chord,
              position: cell.position,
            ),
          );
    } else if (cell.isFlagged) {
      return () {};
    }
    return null;
  }

  void Function()? _getOnLongPressAction(BuildContext context) {
    if (isGameOver) {
      return null;
    }
    if (cell.isClosed || cell.isFlagged) {
      // return () => context.read<GridCubit>().flagCell(position: cell.position);
      return () => context.read<GridCubit>().execute(
            action: GridAction(
              actionType: GridActionType.flag,
              position: cell.position,
            ),
          );
    }
    return null;
  }

  Widget _getReveledCellContent() {
    if (cell.isMined) {
      if (cell.isClosed) {
        return const CellIcon(
          icon: AppImages.mine,
        ); // normal mine
      } else if (cell.isFlagged) {
        return const CellIcon(
          icon: AppImages.flag,
        );
      } else if (cell.isOpened) {
        return const CellIcon(
          icon: AppImages.mine,
        ); // blown mine
      }
    } else {
      if (cell.isClosed) {
        return const SizedBox();
      } else if (cell.isFlagged) {
        return const CellIcon(
          icon: AppImages.wrongFlag,
        ); // false flag place
      } else if (cell.isOpened && !cell.isEmpty) {
        return Center(
          child: Text(
            '${cell.adjacentMinesCount}',
            style: TextStyle(
              color: _getDigitColor(
                cell.adjacentMinesCount,
              ),
              fontSize: 24,
              fontFamily: AppFonts.minesweeper,
            ),
          ),
        );
      } else if (cell.isOpened && cell.isEmpty) {
        return const SizedBox();
      }
    }
    return const SizedBox();
  }

  Widget _getNormalCellContent() {
    if (cell.isOpened && !cell.isEmpty) {
      return Center(
        child: Text(
          '${cell.adjacentMinesCount}',
          style: TextStyle(
            color: _getDigitColor(
              cell.adjacentMinesCount,
            ),
            fontSize: 24,
            fontFamily: AppFonts.minesweeper,
          ),
        ),
      );
    } else if (cell.isFlagged) {
      return const CellIcon(
        icon: AppImages.flag,
      );
    }
    return const SizedBox();
  }

  Widget _getCellContent() {
    if (isMinesReveled) {
      return _getReveledCellContent();
    } else {
      return _getNormalCellContent();
    }
  }

  Color _getDigitColor(int digit) {
    switch (digit) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.indigo;
      case 5:
        return Colors.pink;
      case 6:
        return Colors.blueAccent;
      case 7:
        return Colors.black;
      case 8:
        return Colors.grey[700]!;
    }
    return Colors.black;
  }
}

class CellIcon extends StatelessWidget {
  const CellIcon({
    super.key,
    required this.icon,
  });
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      icon,
    );
  }
}
