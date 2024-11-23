import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/grid_cubit/grid_cubit.dart';
import 'package:segment_display/segment_display.dart';

import '../../helpers/date_time_helper.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    int time = 0;
    context.read<GridCubit>().updateTimer();
    return BlocBuilder<GridCubit, GridState>(
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
