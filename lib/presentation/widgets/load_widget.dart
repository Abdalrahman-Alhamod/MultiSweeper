import 'package:flutter/material.dart';
import '../load_game_view.dart';

import '../../helpers/app_font.dart';

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
      icon: const Row(
        children: [
          Icon(
            Icons.source,
            size: 40,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Load Game",
            style: TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.minesweeper,
            ),
          ),
        ],
      ),
    );
  }
}
