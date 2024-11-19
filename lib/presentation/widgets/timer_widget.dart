import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/grid_cubit/grid_cubit.dart';
import 'package:segment_display/segment_display.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _current = 0;
  // ignore: unused_field
  Timer? _timer;
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        {
          setState(() {
            _current++;
          });
        }
      },
    );
  }

  String _formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GridCubit, GridState>(
      listenWhen: (previous, current) {
        return previous != current &&
            (current is GameStart ||
                current is GameOver ||
                current is GameRestart);
      },
      listener: (context, state) {
        if (state is GameStart) {
          _startTimer();
        } else if (state is GameOver) {
          _timer?.cancel();
        } else if (state is GameRestart) {
          _timer?.cancel();
          setState(() {
            _current = 0;
          });
        }
      },
      child: SevenSegmentDisplay(
        value: _formatHHMMSS(_current),
        size: 4,
      ),
    );
  }
}
