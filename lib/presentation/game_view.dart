import 'package:flutter/material.dart';
import 'package:minesweeper/presentation/widgets/emojie_widget.dart';
import 'package:minesweeper/presentation/widgets/flags_count_widget.dart';
import 'package:minesweeper/presentation/widgets/grid_widget.dart';
import 'package:minesweeper/presentation/widgets/load_widget.dart';
import 'package:minesweeper/presentation/widgets/redo_widget.dart';
import 'package:minesweeper/presentation/widgets/save_widget.dart';
import 'package:minesweeper/presentation/widgets/timer_widget.dart';
import 'package:minesweeper/presentation/widgets/undo_widget.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: const SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SaveWidget(),
                UndoWidget(),
                RedoWidget(),
                LoadWidget(),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: FlagsCountWidget(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: TimerWidget(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmojieWidget(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
