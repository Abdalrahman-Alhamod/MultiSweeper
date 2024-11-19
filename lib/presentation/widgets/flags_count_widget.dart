import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/grid_cubit/grid_cubit.dart';
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
    return BlocBuilder<GridCubit, GridState>(
      builder: (context, state) {
        if (state is FlagsCountUpdate) {
          _flagsCount = state.flagsCount;
        }
        int minesCount = context.read<GridCubit>().minesCount;
        int usedFlagsCount = context.read<GridCubit>().usedFlagsCount;
        _flagsCount = minesCount - usedFlagsCount;
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
      s = s.padLeft(2, '0');
    }
    return s;
  }
}
