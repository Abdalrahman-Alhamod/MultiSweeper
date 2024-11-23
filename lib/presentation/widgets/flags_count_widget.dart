import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/game_cubit/game_cubit.dart';
import 'package:segment_display/segment_display.dart';

class FlagsCountWidget extends StatefulWidget {
  const FlagsCountWidget({super.key});

  @override
  State<FlagsCountWidget> createState() => _FlagsCountWidgetState();
}

class _FlagsCountWidgetState extends State<FlagsCountWidget> {
  late int _flagsCount;
  @override
  void initState() {
    super.initState();
    _flagsCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        if (state is GameUpdate) {
          _flagsCount = state.flagsCount;
        }
        return SevenSegmentDisplay(
          value: getFomattedFlagsCount(),
          size: 4,
          characterCount: 3,
        );
      },
    );
  }

  String getFomattedFlagsCount() {
    String s = _flagsCount.toString();
    if (s.length == 1) {
      s = s.padLeft(3, '0');
    } else if (s.length == 2) {
      s = s.padLeft(4, '0');
    }
    return s;
  }
}
