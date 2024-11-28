import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/game_cubit/game_cubit.dart';
import 'package:segment_display/segment_display.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key, required this.gameId});
  final String gameId;
  @override
  Widget build(BuildContext context) {
    int time = 0;
    context.read<GameCubit>().updateTimer(gameId);
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        return previous != current &&
            current is GameTimeUpdate &&
            current.gamdId == gameId;
      },
      builder: (context, state) {
        if (state is GameTimeUpdate) {
          time = state.time;
        }
        return SevenSegmentDisplay(
          value: getFomattedValue(time),
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
