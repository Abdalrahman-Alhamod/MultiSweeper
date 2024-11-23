import 'package:flutter/material.dart';
import 'package:minesweeper/presentation/load_game_view.dart';


class LoadWidget extends StatelessWidget {
  const LoadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoadGameView(),
          ),
        );
      },
      icon: const Icon(
        Icons.source,
        size: 40,
      ),
    );
  }
}
