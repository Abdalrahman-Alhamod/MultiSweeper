import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/game_cubit/game_cubit.dart';
import 'package:segment_display/segment_display.dart';

class FlagsCountWidget extends StatelessWidget {
  const FlagsCountWidget({super.key, required this.gameId});
  final String gameId;
  @override
  Widget build(BuildContext context) {
    int flagsCount = 0;
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        return previous != current &&
            current is GameUpdate &&
            current.gamdId == gameId;
      },
      builder: (context, state) {
        if (state is GameUpdate) {
          flagsCount = state.flagsCount;
        }
        return SevenSegmentDisplay(
          value: getFomattedValue(flagsCount),
          size: 3,
          characterCount: 3,
        );
      },
    );
  }

  String getFomattedValue(int value) {
    String s = value.toString();
    if (s.length == 1) {
      s = s.padLeft(3, '0');
    } else if (s.length == 2) {
      s = s.padLeft(4, '0');
    }
    return s;
  }
}
