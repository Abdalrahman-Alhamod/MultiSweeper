import 'package:flutter/material.dart';
import 'add_game_widget.dart';

import 'emojie_widget.dart';
import 'flags_count_widget.dart';
import 'grid_widget.dart';
import 'redo_widget.dart';
import 'timer_widget.dart';
import 'undo_widget.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
    required this.gameId,
    required this.isLastElement,
  });
  final String gameId;
  final bool isLastElement;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 60,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: FlagsCountWidget(
                        gameId: gameId,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: TimerWidget(
                        gameId: gameId,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UndoWidget(
                      gameId: gameId,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    EmojieWidget(
                      gameId: gameId,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RedoWidget(
                      gameId: gameId,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridWidget(
              gameId: gameId,
            ),
          ),
          isLastElement ? const AddGameWidget() : const SizedBox(),
        ],
      ),
    );
  }
}
