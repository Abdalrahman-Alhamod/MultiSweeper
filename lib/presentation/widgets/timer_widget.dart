import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/game_cubit/game_cubit.dart';
import 'package:segment_display/segment_display.dart';

import '../../helpers/date_time_helper.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    int time = 0;
    context.read<GameCubit>().updateTimer();
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        return previous != current && current is GameTimeUpdate;
      },
      builder: (context, state) {
        if (state is GameTimeUpdate) {
          time = state.time;
        }
        return SevenSegmentDisplay(
          value: DateTimeHelper.formatHHMMSS(time),
          size: 4,
        );
      },
    );
  }
}
