import 'package:flutter/material.dart';
import 'package:minesweeper/presentation/widgets/emojie_widget.dart';
import 'package:minesweeper/presentation/widgets/flags_count_widget.dart';
import 'package:minesweeper/presentation/widgets/grid_widget.dart';
import 'package:minesweeper/presentation/widgets/timer_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: const SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(child: EmojieWidget()),
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
              ],
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
