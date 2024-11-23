import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/grid_cubit/grid_cubit.dart';
import 'package:minesweeper/helpers/logger.dart';
import 'package:minesweeper/presentation/widgets/cell_widget.dart';

import '../../helpers/show_custom_dialog.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GridCubit>().updateGrid();
    return BlocConsumer<GridCubit, GridState>(
      buildWhen: (previous, current) {
        return previous != current && current is GridUpdate;
      },
      builder: (context, state) {
        if (state is GridUpdate) {
          return GridLayout(
            rowsCount: state.grid.rowsCount,
            colsCount: state.grid.columnsCount,
            colSpacing: 5,
            rowSpacing: 5,
            builder: (x, y) {
              return CellWidget(
                cell: state.grid.getCell(x, y),
                isMinesReveled: state.isMinesReveled,
                isGameOver: state.isGameOver,
              );
            },
          );
        }
        return const Placeholder();
      },
      listener: (context, state) {
        if (state is GridUpdate) {
          logger.print(state.grid, color: PrintColor.pink, title: "Grid");
        }
        if (state is GameOver) {
          if (state.win) {
            showCustomDialog(context, "Congrats", "You have won!");
          } else {
            showCustomDialog(context, "Game Over", "You have lost!");
          }
        }
      },
    );
  }
}

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.colsCount,
    required this.rowsCount,
    this.colSpacing = 0.0,
    this.rowSpacing = 0.0,
    required this.builder,
  });
  final int colsCount;
  final int rowsCount;
  final double colSpacing;
  final double rowSpacing;
  final Widget Function(int x, int y) builder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        (rowsCount * 2) - 1,
        (y) {
          return y % 2 == 1
              ? SizedBox(
                  height: rowSpacing,
                )
              : Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      (colsCount * 2) - 1,
                      (x) {
                        return x % 2 == 1
                            ? SizedBox(
                                width: colSpacing,
                              )
                            : Expanded(
                                child: builder.call(
                                    (x / 2).floor(), (y / 2).floor()),
                              );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
